//
//  SKLabelNode+Stroke.swift
//  Smash Up Counter
//
//  Created by Cyril on 28/03/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit

/*
 This extension allows to apply a stroke to a SKLabelNode.
 */

// MARK: - Extension

extension SKNode {
    // Apply the global text style to the label.
    func applyTextStyle() {
        self.applyStyle(color: UIColor.black, width: -4.0)
    }
    
    // Apply the global title style to the label.
    func applyTitleStyle() {
        self.applyStyle(color: UIColor.white, width: -4.0)
    }
    
    // Apply the global buton style to the label.
    func applyButtonStyle() {
        self.applyStyle(color: UIColor.black, width: -4.0)
    }
    
    // Private method.
    fileprivate func applyStyle(color: UIColor, width: CGFloat) {
        guard let node = self as? SKLabelNode, let text = node.text, let fontName = node.fontName, let fontColor = node.fontColor else {
            return
        }
        
        node.attributedText = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : UIFont(name: fontName, size: node.fontSize)!,
            NSAttributedString.Key.foregroundColor: fontColor,
            NSAttributedString.Key.strokeColor: color,
            NSAttributedString.Key.strokeWidth: width,
            ])
    }
}
