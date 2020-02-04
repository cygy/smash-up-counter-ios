//
//  PlayersCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import ReactiveReSwift


// MARK: - Protocol (PlayersCoordinatorDelegate)

protocol PlayersCoordinatorDelegate: class {
    func nextStep(from coordinator: PlayersCoordinator)
}


// MARK: - Definition

class PlayersCoordinator: SceneCoordinator<PlayersScene> {
    
    // MARK: - Properties
    
    weak var delegate: PlayersCoordinatorDelegate?
    
    
    // MARK: - Life cycle
    
    override func start() {
        self.scene.sceneDelegate = self
        
        self.scene.setUpCompletion = { [unowned self] in
            self.updateScene(withPlayers: ApplicationState.instance.players.value, animated: false)
        }
        
        self.scene.enterCompletion = { [unowned self] in
            ApplicationState.instance.players.asObservable().distinctUntilChanged({ $0.count == $1.count }).subscribe { [weak self] players in
                guard let players = players.element else {
                    return
                }
                self?.updateScene(withPlayers: players, animated: true)
            }.disposed(by: self.disposeBag)
        }
        
        self.view.presentScene(self.scene)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func updateScene(withPlayers players: [Player], animated: Bool) {
        let numberOfPlayers = players.count
        
        self.scene.setPlayers(players)
        self.scene.updateAddPlayerButtonPosition()
        self.scene.enableAddPlayerButton(numberOfPlayers < ApplicationState.numberMaxOfPlayers)
        self.scene.enableNextButton(numberOfPlayers >= ApplicationState.numberMinOfPlayers, animated: animated)
    }
}


// MARK: - Extension (PlayersSceneDelegate)

extension PlayersCoordinator: PlayersSceneDelegate {
    func nextStep(from scene: PlayersScene) {
        scene.exit { [unowned self] in
            self.delegate?.nextStep(from: self)
        }
    }
    
    func addPlayer(from scene: PlayersScene) {
        let input = UIAlertController(title: NSLocalizedString("playersScene.dialogBox.title.playerName", value: "Player's name", comment: "Title of the dialog box to enter the player's name."), message: nil, preferredStyle: .alert)
        input.addTextField(configurationHandler: nil)
        
        input.addAction(UIAlertAction(title: NSLocalizedString("playersScene.dialogBox.button.ok", value: "OK", comment: "Label of the dialog box button OK."), style: .default) { [input] _ in
            guard let playerName = input.textFields?[0].text, playerName.count > 0 else {
                return
            }
            ApplicationState.instance.addPlayer(name: playerName)
        })
        
        self.viewController.present(input, animated: true, completion: nil)
    }
    
    func removePlayer(with name: String, from scene: PlayersScene) {
        ApplicationState.instance.removePlayer(name: name)
    }
}

