//
//  PlayerNode.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 23/03/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Definition

class PlayerNode: SKNode {
    
    // MARK: - Children nodes
    
    fileprivate lazy var nameLabel: SKLabelNode? = {
        self.childNode(withName: "name") as? SKLabelNode
    }()
    
    fileprivate lazy var pointsLabel: SKLabelNode? = {
        self.childNode(withName: "points") as? SKLabelNode
    }()
    
    fileprivate lazy var firstFactionImageNode: SKSpriteNode? = {
        self.childNode(withName: "first_faction_image") as? SKSpriteNode
    }()
    
    fileprivate lazy var firstFactionNameNode: SKLabelNode? = {
        self.childNode(withName: "first_faction_name") as? SKLabelNode
    }()
    
    fileprivate lazy var secondFactionImageNode: SKSpriteNode? = {
        self.childNode(withName: "second_faction_image") as? SKSpriteNode
    }()
    
    fileprivate lazy var secondFactionNameNode: SKLabelNode? = {
        self.childNode(withName: "second_faction_name") as? SKLabelNode
    }()
    
    fileprivate lazy var incrementPointsNode: SKNode? = {
        self.childNode(withName: "increment_points")
    }()
    
    fileprivate lazy var decrementPointsNode: SKNode? = {
        self.childNode(withName: "decrement_points")
    }()
    
    
    // MARK: - Properties
    
    private(set) var playerName: String? = nil
    
    
    // MARK: - Life cycle
    
    func setUp(withPlayer player: Player, animated: Bool) {
        self.playerName = player.name
        
        // TODO : animation
        
        self.nameLabel?.text = player.name
        self.pointsLabel?.text = "\(player.points)"
        
        self.firstFactionNameNode?.text = player.factions[0].name
        self.secondFactionNameNode?.text = player.factions[1].name
        
        if let imageName = player.factions[0].image {
            self.firstFactionImageNode?.texture = SKTexture(imageNamed: imageName)
        }
        
        if let imageName = player.factions[1].image {
            self.secondFactionImageNode?.texture = SKTexture(imageNamed: imageName)
        }
        
        self.nameLabel?.applyTextStyle()
        self.pointsLabel?.applyTextStyle()
        self.incrementPointsNode?.applyTextStyle()
        self.decrementPointsNode?.applyTextStyle()
    }
}
