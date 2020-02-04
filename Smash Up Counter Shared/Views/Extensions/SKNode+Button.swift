//
//  SKNode+Button.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/04/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Extension

extension SKNode {
    // Returns the Button object from the node and update the text.
    func button(withName name: String, andSetLabel label: String) -> Button? {
        let node = self.childNode(withName: name)?.childNode(withName: ".//button") as? Button
        node?.label = label
        
        return node
    }
}
