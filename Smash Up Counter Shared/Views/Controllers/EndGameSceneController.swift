//
//  EndGameSceneController.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 03/04/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit

/*
 The class EndGameSceneController presents the winner of the game.
 A new game can be created from this scene. Replay or reset a game
 can also be done from this scene.
 */

// MARK: - Protocol (EndGameSceneControllerDelegate)

protocol EndGameSceneControllerDelegate: class {
    func newGame(from controller: EndGameSceneController)
    func replay(from controller: EndGameSceneController)
    func reset(from controller: EndGameSceneController)
}


// MARK: - Definition

class EndGameSceneController: SceneController<EndGameScene> {
    
    // MARK: - Properties
    
    weak var delegate: EndGameSceneControllerDelegate?
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

extension EndGameSceneController: EndGameSceneDelegate {
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

