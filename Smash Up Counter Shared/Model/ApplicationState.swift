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
    
    func addPlayer(name: String) {
        guard self.players.value.count < ApplicationState.numberMaxOfPlayers && !self.players.value.contains(where: { $0.name == name }) else {
            return
        }
        
        let player = Player(name: name, points: 0, factions: [Faction]())
        var players = self.players.value
        players.append(player)
        
        self.players.accept(players)
    }
    
    func removePlayer(name: String) {
        let players = self.players.value.filter { $0.name != name }
        self.players.accept(players)
    }
       
    func increment(score points: Int, forPlayer name: String) {
        let players = self.players.value.map { (p) -> Player in
            guard p.name == name else {
                return p
            }
            
            return Player(name: p.name, points: (p.points + points), factions: p.factions)
        }
        self.players.accept(players)
    }
       
    func decrement(score points: Int, forPlayer name: String) {
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
    
    func select(addOn addOnId: Int) {
        let addOns = self.update(addOn: addOnId, fromAddOns: self.addOns.value, isSelected: true)
        self.addOns.accept(addOns)
    }
    
    func unselect(addOn addOnId: Int) {
        let addOns = self.update(addOn: addOnId, fromAddOns: self.addOns.value, isSelected: false)
        self.addOns.accept(addOns)
    }
    
    // Private method
    
    private func update(addOn addOnId: Int, fromAddOns addOns: [AddOn], isSelected selected: Bool) -> [AddOn] {
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
    
    func select(faction factionId: Int, fromAddOn addOnId: Int) {
        let addOns = self.update(faction: factionId, fromAddOn: addOnId, andFromAddOns: self.addOns.value, isSelected: true)
        self.addOns.accept(addOns)
    }
    
    func unselect(faction factionId: Int, fromAddOn addOnId: Int) {
        let addOns = self.update(faction: factionId, fromAddOn: addOnId, andFromAddOns: self.addOns.value, isSelected: false)
        self.addOns.accept(addOns)
    }
    
    
    // Private method
    
    private func update(faction factionId: Int, fromAddOn addOnId: Int, andFromAddOns addOns: [AddOn], isSelected selected: Bool) -> [AddOn] {
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
    func initialize() {
        guard self.addOns.value.count == 0 else {
            self.state.accept(.ready)
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
                self.initializationDone(addOns: addOns)
            }
        }
    }
    
    func initializationDone(addOns: [AddOn]) {
        self.addOns.accept(addOns)
        self.state.accept(.ready)
    }
    
    func setUpPlayers() {
        let players = self.players.value.map { Player(name: $0.name, points: 0, factions: [Faction]()) }
        self.players.accept(players)
        self.state.accept(.settingUpPlayers)
    }
    
    func setUpFactions() {
        let players = self.players.value.map { Player(name: $0.name, points: 0, factions: [Faction]()) }
        self.players.accept(players)
        self.state.accept(.settingUpFactions)
    }
    
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
    
    func startGame() {
        self.state.accept(.playing)
    }
    
    func endGame() {
        let winner = self.players.value.max(by: { $0.points < $1.points })
        self.state.accept(.endGame(winner: winner))
    }
    
    func newGame() {
        self.setUpPlayers()
    }
    
    func replayGame() {
        let players = self.players.value.map { Player(name: $0.name, points: 0, factions: $0.factions) }
        self.players.accept(players)
        self.state.accept(.playing)
    }
    
    func resetGame() {
        self.setUpFactions()
    }
}
