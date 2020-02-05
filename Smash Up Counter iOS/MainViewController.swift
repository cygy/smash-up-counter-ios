//
//  MainViewController.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 01/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let skView = self.view as? SKView else {
            return
        }
        
        // Optimize drawing by ignoring the sort of nodes with the same Z-order.
        skView.ignoresSiblingOrder = true
        
        // Show or not some statistics.
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

