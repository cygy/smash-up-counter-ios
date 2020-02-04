//
//  FactionNode.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 13/03/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Definition

class FactionNode: SKNode {
    
    // MARK: - Children nodes
    
    fileprivate lazy var nameLabel: SKLabelNode? = {
        self.childNode(withName: "name") as? SKLabelNode
    }()
    
    fileprivate lazy var imageNode: SKSpriteNode? = {
        self.childNode(withName: "image") as? SKSpriteNode
    }()
    
    fileprivate lazy var disabledNode: SKNode? = {
        self.childNode(withName: "disabled")
    }()
    
    
    // MARK: - Properties
    
    private(set) var id: Int? = nil
    private(set) var index: Int? = nil
    private(set) var isSelected = false
    
    
    // MARK: - Life cycle
    
    func setUp(withFaction faction: Faction, andIndex index: Int) {
        self.id = faction.id
        self.index = index
        
        self.nameLabel?.text = faction.name
        self.nameLabel?.applyTextStyle()
        
        if let imageName = faction.image {
            self.imageNode?.texture = SKTexture(imageNamed: imageName)
        }
        
        self.updateSelectedState(faction.isSelected, animated: false)
        
        self.isHidden = false
    }
    
    func setDown() {
        self.id = nil
        self.index = nil
        self.isHidden = true
    }
    
    
    // MARK: - Displaying
    
    func updateSelectedState(_ isSelected: Bool, animated: Bool) {
        self.isSelected = isSelected
        self.disabledNode?.isHidden = self.isSelected
    }
}
