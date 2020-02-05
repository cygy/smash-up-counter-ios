//
//  Button.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 30/03/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Definition

class Button: SKNode {
    
    // MARK: - Constants
    
    static let margin: CGFloat = 15.0
    static let size: CGFloat = 60.0
    
    
    // MARK: - Children nodes
    
    lazy var labelNode: SKLabelNode? = {
        self.childNode(withName: "label") as? SKLabelNode
    }()
    
    lazy var backgroundNode: SKSpriteNode? = {
        self.childNode(withName: "background") as? SKSpriteNode
    }()
    
    
    // MARK: - Properties
    
    var label: String? {
        set {
            if let labelNode = self.labelNode {
                labelNode.text = newValue
                labelNode.applyButtonStyle()
                
                if let background = self.backgroundNode {
                    background.centerRect = CGRect(x: Button.margin/Button.size, y: Button.margin/Button.size, width: (Button.size - 2*Button.margin)/Button.size, height: (Button.size - 2*Button.margin)/Button.size)
                    background.size = CGSize(width: labelNode.frame.size.width + Button.margin*2, height: labelNode.frame.size.height + Button.margin*2)
                }
            }
        }
        get {
            return self.labelNode?.text
        }
    }
    
    var referentNode: SKNode? {
        return self.parent
    }
    
    var isEnabled = true
    
    
    // MARK: - Touch handling
    
    func isTouched(node: SKNode) -> Bool {
        return node == self.labelNode || node == self.backgroundNode || node == self
    }
}
