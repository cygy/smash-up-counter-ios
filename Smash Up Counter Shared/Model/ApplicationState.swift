//
//  ApplicationState.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 23/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import Foundation
import Dispatch
import RxRelay

/*
 The class ApplicationState manages the state and the data (the players and the available add-ons) of the entire application.
 
 The singleton pattern is used to limit the occurences of objects from this class to one. This singleton is accessible
 from anywhere into the application.
 
 Each property of this class is an Observable. Then every controller can subscribe to these observable properties and update
 its view if needed.
 
 This class is composed of multiple extensions, each of these extensions provide methods concerning the management of its properties.
 Its properties must not be changed directtly, but the use of the methods are encouraged.
 */

// MARK: - Definition

class ApplicationState {
    
    // MARK: - Constants
    
    static let numberMinOfPlayers: Int = 2
    static let numberMaxOfPlayers: Int = 4
    static let numberOfFactionsByPlayers: Int = 2
    static let scoreMin: Int = 0
    static let scoreMax: Int = 25
    static let winningScore: Int = 15
    
    
    // MARK: - Properties
    
    var state = BehaviorRelay<State>(value: .none)
    var players = BehaviorRelay<[Player]>(value: [Player]())
    var addOns = BehaviorRelay<[AddOn]>(value: [AddOn]())
    
    
    // MARK: - Singleton
    
    static let instance = ApplicationState()
    
    
    // MARK: - Life cycle
    
    private init() {
    }
}


// MARK: - Managing players

extension ApplicationState {
    
    // Add a player with this name to the game.
    // A player is added if the maximum number of players is not reachedand if this player does not exist yet.
    func addPlayer(withName name: String) {
        guard self.players.value.count < ApplicationState.numberMaxOfPlayers && !self.players.value.contains(where: { $0.name == name }) else {
            return
        }
        
        let player = Player(name: name, points: 0, factions: [Faction]())
        var players = self.players.value
        players.append(player)
        
        self.players.accept(players)
    }
    
    // Remove a player with this name from the game.
    func removePlayer(withName name: String) {
        let players = self.players.value.filter { $0.name != name }
        self.players.accept(players)
    }
       
    // The score of a player with this name is incremented by 1.
    func incrementScore(by points: Int, forPlayer name: String) {
        let players = self.players.value.map { (p) -> Player in
            guard p.name == name else {
                return p
            }
            
            return Player(name: p.name, points: (p.points + points), factions: p.factions)
        }
        self.players.accept(players)
    }

    // The score of a player with this name is decremented by 1.
    // The score can not be lower than 0.
    func decrementScore(by points: Int, forPlayer name: String) {
        let players = self.players.value.map { (p) -> Player in
            guard p.name == name else {
                return p
            }
            
            let points = (p.points - points)
            return Player(name: p.name, points: (points > 0 ? points : 0), factions: p.factions)
        }
        self.players.accept(players)
    }
}


// MARK: - Managing addOns

extension ApplicationState {
    
    // Select an add-on to add its factions to the list.
    // The players will play with factions from this list.
    func selectAddOn(withId addOnId: Int) {
        let addOns = self.updateAddOn(withId: addOnId, fromAddOns: self.addOns.value, isSelected: true)
        self.addOns.accept(addOns)
    }
    
    // Unselect an add-on to remove its factions from the list.
    // The players will play with factions from this list.
    func unselectAddOn(withId addOnId: Int) {
        let addOns = self.updateAddOn(withId: addOnId, fromAddOns: self.addOns.value, isSelected: false)
        self.addOns.accept(addOns)
    }
    
    // Private method to update an add-on and its faction.
    private func updateAddOn(withId addOnId: Int, fromAddOns addOns: [AddOn], isSelected selected: Bool) -> [AddOn] {
        return addOns.map { (a) -> AddOn in
            guard a.id == addOnId else {
                return a
            }
            
            let factions = a.factions.map { Faction(id: $0.id, name: $0.name, image: $0.image, isSelected: selected) }
            
            return AddOn(id: a.id, name: a.name, image: a.image, factions: factions, isSelected: selected)
        }
    }
}


// MARK: - Managing factions

extension ApplicationState {
    
    // Select a faction from an add-on to add it to the list.
    // The players will play with factions from this list.
    func selectFaction(withId factionId: Int, fromAddOn addOnId: Int) {
        let addOns = self.updateFaction(withId: factionId, fromAddOn: addOnId, andFromAddOns: self.addOns.value, isSelected: true)
        self.addOns.accept(addOns)
    }
    
    // Unelect a faction from an add-on to remove it from the list.
    // The players will play with factions from this list.
    func unselectFaction(withId factionId: Int, fromAddOn addOnId: Int) {
        let addOns = self.updateFaction(withId: factionId, fromAddOn: addOnId, andFromAddOns: self.addOns.value, isSelected: false)
        self.addOns.accept(addOns)
    }
    
    // Private method to update a faction.
    private func updateFaction(withId factionId: Int, fromAddOn addOnId: Int, andFromAddOns addOns: [AddOn], isSelected selected: Bool) -> [AddOn] {
        return addOns.map { (a) -> AddOn in
            guard a.id == addOnId else {
                return a
            }
            
            let factions = a.factions.map { (f) -> Faction in
                guard f.id == factionId else {
                    return f
                }
                
                return Faction(id: f.id, name: f.name, image: f.image, isSelected: selected)
            }
            
            return AddOn(id: a.id, name: a.name, image: a.image, factions: factions, isSelected: (selected ? selected : a.isSelected))
        }
    }
}


// MARK: - Managing application state

extension ApplicationState {
    
    // Initialize the data of the application: load the add-ons and the factions from a stored json file in a background thread.
    // The state of the application is set to .initializing and is updated to .ready when all the data are up-to-date.
    func initialize() {
        guard self.addOns.value.count == 0 else {
            self.initializationDone()
            return
        }
        
        self.state.accept(.initializing)
        
        // Load the extensions from the JSON file.
        DispatchQueue.global(qos: .background).async {
            var addOns = [AddOn]()
            do {
                let decoder = JSONDecoder()
                let filePath = Bundle.main.path(forResource: "addOns", ofType: "json")
                let url = URL(fileURLWithPath: filePath!)
                let data = try Data(contentsOf: url)
                addOns = try decoder.decode([AddOn].self, from: data)
            } catch let e {
                debugPrint("Error: addOns not loaded: \(e)")
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.addOns.accept(addOns)
                self.initializationDone()
            }
        }
    }
    
    // Update the state of the application to .ready: the data are ready.
    func initializationDone() {
        self.state.accept(.ready)
    }
    
    // Reset the score and the factions of the existing players for the next game.
    // Update the state of the application to the choice of the players.
    func setUpPlayers() {
        let players = self.players.value.map { Player(name: $0.name, points: 0, factions: [Faction]()) }
        self.players.accept(players)
        self.state.accept(.settingUpPlayers)
    }
    
    // Reset the score and the factions of the existing players for the next game.
    // Update the state of the application to the choice of the factions.
    func setUpFactions() {
        let players = self.players.value.map { Player(name: $0.name, points: 0, factions: [Faction]()) }
        self.players.accept(players)
        self.state.accept(.settingUpFactions)
    }
    
    // The selected factions are distributed randomly to the players.
    // Update the state of the application to the reveal of the factions.
    func distributeFactions() {
        var selectedFactions: [Faction] = self.addOns.value.filter{ $0.isSelected }.flatMap { $0.factions }.filter{ $0.isSelected }
        
        guard selectedFactions.count >= (self.players.value.count * ApplicationState.numberOfFactionsByPlayers) else {
            self.state.accept(.settingUpFactions)
            return
        }
        
        let players = self.players.value.map { (player) -> Player in
            var factions = [Faction]()
            for _ in 0..<ApplicationState.numberOfFactionsByPlayers {
                let randomIndex = Int.random(in: 0 ..< selectedFactions.count)
                let faction = selectedFactions[randomIndex]
                factions.append(faction)
                selectedFactions.remove(at: randomIndex)
            }
            
            return Player(name: player.name, points: player.points, factions: factions)
        }
        
        self.players.accept(players)
        self.state.accept(.factionsDistributed)
    }
    
    // Update the state of the application to the playing state.
    func startGame() {
        self.state.accept(.playing)
    }
    
    // Update the state of the application to the end state with the winner.
    func endGame() {
        let winner = self.players.value.max(by: { $0.points < $1.points })
        self.state.accept(.endGame(winner: winner))
    }
    
    // Start a new game.
    // Update the state of the application to the choice of the players.
    func newGame() {
        self.setUpPlayers()
    }
    
    // Replay the game with the same players and the same factions.
    // Update the state of the application to the playing state.
    func replayGame() {
        let players = self.players.value.map { Player(name: $0.name, points: 0, factions: $0.factions) }
        self.players.accept(players)
        self.state.accept(.playing)
    }
    
    // Replay the game with the same players.
    // Update the state of the application to the choice of the factions.
    func resetGame() {
        self.setUpFactions()
    }
}
