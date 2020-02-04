//
//  AddOn.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 23/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//


// MARK: - Definition

struct AddOn: Codable {
    
    // MARK: - Properties
    
    var id: Int
    var name: String
    var image: String?
    var factions: [Faction]
    var isSelected: Bool = true
}


// MARK: - Extension (Equatable)

extension AddOn: Equatable {
    static func == (lhs: AddOn, rhs: AddOn) -> Bool {
        return lhs.id == rhs.id
    }
}
