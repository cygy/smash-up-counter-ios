//
//  FactionsDistributionSceneController.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit

/*
 The class FactionsDistributionSceneController is only responsible to present the factions
 randomly distributed to the players.
 */

// MARK: - Protocol (FactionsDistributionSceneControllerDelegate)

protocol FactionsDistributionSceneControllerDelegate: class {
    func nextStep(from controller: FactionsDistributionSceneController)
}


// MARK: - Definition

class FactionsDistributionSceneController: SceneController<FactionsDistributionScene> {
    
    // MARK: - Properties
    
    weak var delegate: FactionsDistributionSceneControllerDelegate?
    
    
    // MARK: - Life cycle
    
    override func start() {
        self.scene.sceneDelegate = self
        
        self.scene.setUpCompletion = { [unowned self] in
            self.scene.setPlayers(ApplicationState.instance.players.value)
        }
        
        self.view.presentScene(self.scene)
    }
}


// MARK: - Extension (FactionsDistributionSceneDelegate)

extension FactionsDistributionSceneController: FactionsDistributionSceneDelegate {
    func nextStep(from scene: FactionsDistributionScene) {
        scene.exit { [unowned self] in
            self.delegate?.nextStep(from: self)
        }
    }
}
