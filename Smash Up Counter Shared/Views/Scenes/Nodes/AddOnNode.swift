//
//  AddOnNode.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 13/03/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Definition

class AddOnNode: SKNode {
    
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
    
    func setUp(withAddOn addOn: AddOn, andIndex index: Int) {
        self.id = addOn.id
        self.index = index
        
        self.nameLabel?.text = addOn.name
        self.nameLabel?.applyTextStyle()
        
        if let imageName = addOn.image {
            self.imageNode?.texture = SKTexture(imageNamed: imageName)
        }
        
        self.updateSelectedState(addOn.isSelected, animated: false)
        
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
    
    func hideName() {
        self.nameLabel?.isHidden = true
    }
    
    func showName() {
        self.nameLabel?.isHidden = false
    }
}
