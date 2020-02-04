//
//  EndGameCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 03/04/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import ReactiveReSwift


// MARK: - Protocol (EndGameCoordinatorDelegate)

protocol EndGameCoordinatorDelegate: class {
    func newGame(from coordinator: EndGameCoordinator)
    func replay(from coordinator: EndGameCoordinator)
    func reset(from coordinator: EndGameCoordinator)
}


// MARK: - Definition

class EndGameCoordinator: SceneCoordinator<EndGameScene> {
    
    // MARK: - Properties
    
    weak var delegate: EndGameCoordinatorDelegate?
    var winner: Player?
    
    
    // MARK: - Life cycle
    
    override func start() {
        self.scene.sceneDelegate = self
        
        self.scene.setUpCompletion = { [unowned self] in
            self.scene.setWinner(self.winner)
        }
        
        self.view.presentScene(self.scene)
    }
}


// MARK: - Extension (EndGameSceneDelegate)

extension EndGameCoordinator: EndGameSceneDelegate {
    func newGame(from scene: EndGameScene) {
        scene.exit { [unowned self] in
            self.delegate?.newGame(from: self)
        }
    }
    
    func replay(from scene: EndGameScene) {
        scene.exit { [unowned self] in
            self.delegate?.replay(from: self)
        }
    }
    
    func reset(from scene: EndGameScene) {
        scene.exit { [unowned self] in
            self.delegate?.reset(from: self)
        }
    }
}

