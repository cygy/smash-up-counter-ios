//
//  FactionsDistributionCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import ReactiveReSwift


// MARK: - Protocol (FactionsDistributionCoordinatorDelegate)

protocol FactionsDistributionCoordinatorDelegate: class {
    func nextStep(from coordinator: FactionsDistributionCoordinator)
}


// MARK: - Definition

class FactionsDistributionCoordinator: SceneCoordinator<FactionsDistributionScene> {
    
    // MARK: - Properties
    
    weak var delegate: FactionsDistributionCoordinatorDelegate?
    
    
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

extension FactionsDistributionCoordinator: FactionsDistributionSceneDelegate {
    func nextStep(from scene: FactionsDistributionScene) {
        scene.exit { [unowned self] in
            self.delegate?.nextStep(from: self)
        }
    }
}
