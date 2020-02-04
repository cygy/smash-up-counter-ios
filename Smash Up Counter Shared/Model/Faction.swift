//
//  Faction.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 23/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//


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
