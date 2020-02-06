//
//  GameSceneController.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit

/*
 The class GameSceneController presents the points of all the players.
 Each player can increment or decrement its points.
 */

// MARK: - Protocol (GameSceneControllerDelegate)

protocol GameSceneControllerDelegate: class {
    func incrementScore(by points: Int, forPlayer name: String, from controller: GameSceneController)
    func decrementScore(by points: Int, forPlayer name: String, from controller: GameSceneController)
    func endGame(from controller: GameSceneController)
}


// MARK: - Definition

class GameSceneController: SceneController<GameScene> {
    
    // MARK: - Properties
    
    weak var delegate: GameSceneControllerDelegate?
    
    
    // MARK: - Life cycle
    
    override func start() {
        self.scene.sceneDelegate = self
        
        self.scene.setUpCompletion = { [unowned self] in
            self.scene.setPlayers(ApplicationState.instance.players.value)
        }
        
        self.scene.enterCompletion = { [unowned self] in
            for (index, _) in ApplicationState.instance.players.value.enumerated() {
                ApplicationState.instance.players.asObservable().map { $0[index] }.distinctUntilChanged{ $0.points == $1.points }.subscribe { [weak self] player in
                    guard let player = player.element else {
                        return
                        
                    }
                    self?.scene.updatePlayerNode(withPlayer: player)
                }.disposed(by: self.disposeBag)
            }
        }
        
        self.view.presentScene(self.scene)
    }
}


// MARK: - Extension (GameSceneDelegate)

extension GameSceneController: GameSceneDelegate {
    func endGame(from scene: GameScene) {
        scene.exit { [unowned self] in
            self.delegate?.endGame(from: self)
        }
    }
    
    func incrementScore(by points: Int, forPlayer name: String, from scene: GameScene) {
        self.delegate?.incrementScore(by: points, forPlayer: name, from: self)
    }
    
    func decrementScore(by points: Int, forPlayer name: String, from scene: GameScene) {
        self.delegate?.decrementScore(by: points, forPlayer: name, from: self)
    }
}
