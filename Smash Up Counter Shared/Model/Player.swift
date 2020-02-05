//
//  Player.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 23/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

/*
 This class describes a player.
 A player is uniquely created by its name, has a score (greater or equal to 0), and a list of factions to play with.
 */

// MARK: - Definition

struct Player {
    
    // MARK: - Properties
    
    var name: String
    var points: Int = 0
    var factions: [Faction] = [Faction]()
}


// MARK: - Extension (Equatable)

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
}
