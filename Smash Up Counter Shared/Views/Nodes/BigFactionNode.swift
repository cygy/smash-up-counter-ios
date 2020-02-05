//
//  BigFactionNode.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 23/03/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Definition

class BigFactionNode: SKNode {
    
    // MARK: - Children nodes
    
    fileprivate lazy var nameLabel: SKLabelNode? = {
        self.childNode(withName: "name") as? SKLabelNode
    }()
    
    fileprivate lazy var imageNode: SKSpriteNode? = {
        return self.childNode(withName: "image") as? SKSpriteNode
    }()
    
    fileprivate lazy var backNode: SKNode? = {
        return self.childNode(withName: "back")
    }()
    
    
    // MARK: - Life cycle
    
    func setUp(withFaction faction: Faction) {
        self.nameLabel?.text = faction.name
        self.nameLabel?.applyTextStyle()
        
        if let imageName = faction.image {
            self.imageNode?.texture = SKTexture(imageNamed: imageName)
        }
    }
    
    
    // MARK: - Displaying
    
    func hideFaction() {
        self.backNode?.isHidden = false
        self.nameLabel?.isHidden = true
    }
    
    func showFaction() {
        self.backNode?.isHidden = true
        self.nameLabel?.isHidden = false
    }
    
    func runDiscoverAction(withCompletion completion: (() -> Void)? = nil) {
        let explodeAction = SKAction.customAction(withDuration: 0.01) { (node, duration) in
            guard let emitter = SKEmitterNode(fileNamed: "explode.sks"), let imageNode = self.imageNode else {
                return
            }
            
            emitter.position = imageNode.position
            self.parent?.addChild(emitter)
        }
        
        let scaleUpAction = SKAction.scale(to: 1.75, duration: 0.3)
        scaleUpAction.timingMode = .easeOut
        let scaleDownAction = SKAction.scale(to: 1.0, duration: 0.2)
        scaleDownAction.timingMode = .easeIn
        let scaleAction = SKAction.sequence([explodeAction, scaleUpAction, scaleDownAction])
        
        self.hideFaction()
        
        self.parent?.run(SKAction.shakeAction(amplitudeX: 75.0, amplitudeY: 75.0, duration: 2.0)) {
            self.backNode?.isHidden = true
            self.parent?.run(scaleAction) {
                self.nameLabel?.isHidden = false
                completion?()
            }
        }
    }
}
