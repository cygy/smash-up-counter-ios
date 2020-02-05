//
//  Faction.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 23/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

/*
 This class describes a faction.
 A faction is a set of cards whih a player plays with.
 A faction is uniquely created by its identifier, has a name and an image.
 A faction can be selected or not to play with.
 */

// MARK: - Definition

struct Faction: Codable {
    
    // MARK: - Properties
    
    var id: Int
    var name: String
    var image: String?
    var isSelected: Bool = true
}


// MARK: - Extension (Equatable)

extension Faction: Equatable {
    static func == (lhs: Faction, rhs: Faction) -> Bool {
        return lhs.id == rhs.id
    }
}
