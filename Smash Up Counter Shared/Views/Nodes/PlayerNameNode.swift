//
//  PlayerNameNode.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 08/04/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Definition

class PlayerNameNode: SKNode {
    
    // MARK: - Children nodes
    
    fileprivate lazy var nameLabel: SKLabelNode? = {
        self.childNode(withName: "name") as? SKLabelNode
    }()
    
    fileprivate lazy var removeNode: SKNode? = {
        self.childNode(withName: "remove")
    }()
    
    fileprivate lazy var disabledNode: SKSpriteNode? = {
        self.childNode(withName: "disabled") as? SKSpriteNode
    }()
    
    fileprivate lazy var disabledLabel: SKLabelNode? = {
        self.childNode(withName: ".//disabledLabel") as? SKLabelNode
    }()
    
    
    // MARK: - Properties
    
    private(set) var playerName: String? = nil
    private(set) var isDisabled = true
    
    var positionInScene: CGPoint? {
        return self.parent?.parent?.position
    }
    
    
    // MARK: - Life cycle
    
    func update(size: CGSize, andCenter center: CGRect) {
        self.disabledNode?.centerRect = center
        self.disabledNode?.size = size
        self.disabledLabel?.text = NSLocalizedString("playersScene.playerView.hint", value: "No One", comment: "Hint of the player's name.")
        self.disabledLabel?.applyTextStyle()
    }
    
    func setUp(withPlayer player: Player) {
        self.playerName = player.name
        self.isDisabled = false
        
        self.disabledNode?.isHidden = true
        self.nameLabel?.isHidden = false
        self.removeNode?.isHidden = false
        
        self.nameLabel?.text = self.playerName
        self.nameLabel?.applyTextStyle()
        
        if let nameLabel = self.nameLabel, let removeNode = self.removeNode {
            removeNode.position = CGPoint(x: (nameLabel.position.x + nameLabel.frame.size.width/2.0 + removeNode.frame.size.width/2.0 + 3), y: removeNode.position.y)
        }
    }
    
    func setDown() {
        self.playerName = nil
        self.isDisabled = true
        
        self.disabledNode?.isHidden = false
        self.nameLabel?.isHidden = true
        self.removeNode?.isHidden = true
    }
}
