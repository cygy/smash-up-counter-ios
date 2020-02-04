//
//  GameCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import RxSwift


// MARK: - Protocol (GameCoordinatorDelegate)

protocol GameCoordinatorDelegate: class {
    func endGame(from coordinator: GameCoordinator)
}


// MARK: - Definition

class GameCoordinator: SceneCoordinator<GameScene> {
    
    // MARK: - Properties
    
    weak var delegate: GameCoordinatorDelegate?
    
    
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

extension GameCoordinator: GameSceneDelegate {
    func endGame(from scene: GameScene) {
        scene.exit { [unowned self] in
            self.delegate?.endGame(from: self)
        }
    }
    
    func incrementScoreBy(points: Int, ofPlayer name: String) {
        ApplicationState.instance.increment(score: points, forPlayer: name)
    }
    
    func decrementScoreBy(points: Int, ofPlayer name: String) {
        ApplicationState.instance.decrement(score: points, forPlayer: name)
    }
}
