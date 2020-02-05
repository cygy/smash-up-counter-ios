//
//  ApplicationCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import RxSwift

/*
 The class ApplicationCoordinator manages the scenes in the application. It is its responsibility to transition the scenes.
 It observes the ApplicationState singleton's state property to know which scene to display.
 
 It conforms to the protocol of all the scene controllers to update the state of the ApplicationState singleton.
 
                                                    --------------- manage ---------------------
                                                    |                                          |
                                                    |                                          v
    ApplicationState ---- subscribe ---> ApplicationCoordinator <--- delegate (events) --- SceneCoordinators <--- delegate (UI events) --- Scene
            |        <----- update -----                                                       ^             ---------- update ---------->
            |                                                                                  |
            -------------------------------------- subscribe -----------------------------------
 */

// MARK: - Definition

class ApplicationCoordinator {
    
    // MARK: - Properties
    
    fileprivate let view: SKView
    fileprivate let viewController: UIViewController
    fileprivate var childController: Controller?
    
    fileprivate let disposeBag = DisposeBag()
    
    
    // MARK: - Life cycle
    
    init(withView view: SKView, andViewController viewController: UIViewController) {
        self.view = view
        self.viewController = viewController
    }
    
    // The ApplicationCoordinator observes the state of the application
    // and update the scenes accordingly.
    func start() {
        ApplicationState.instance.state.asObservable().distinctUntilChanged().subscribe { [weak self] state in
            guard let state = state.element else {
                return
            }
            
            switch state {
            case .none, .initializing, .ready:
                self?.showHomeScene()
            case .settingUpPlayers:
                self?.showSetUpPlayersScene()
            case .settingUpFactions:
                self?.showSetUpFactionsScene()
            case .factionsDistributed:
                self?.showFactionsDistributionScene()
            case .playing:
                self?.showGameScene()
            case .endGame(let winner):
                self?.showEndGameScene(withWinner: winner)
            }
        }.disposed(by: disposeBag)
    }
    
    
    // MARK: - Scene transitions
    
    fileprivate func showHomeScene() {
        if let _ = self.childController as? HomeSceneController {
            return
        }
        
        let controller = HomeSceneController(view: self.view, viewController: self.viewController)
        controller.delegate = self
        controller.start()
        self.childController = controller
    }
    
    fileprivate func showSetUpPlayersScene() {
        if let _ = self.childController as? PlayersSceneController {
            return
        }
        
        let controller = PlayersSceneController(view: self.view, viewController: self.viewController)
        controller.delegate = self
        controller.start()
        self.childController = controller
    }
    
    fileprivate func showSetUpFactionsScene() {
        if let _ = self.childController as? FactionsSceneController {
            return
        }
        
        let controller = FactionsSceneController(view: self.view, viewController: self.viewController)
        controller.delegate = self
        controller.start()
        self.childController = controller
    }
    
    fileprivate func showFactionsDistributionScene() {
        if let _ = self.childController as? FactionsDistributionSceneController {
            return
        }
        
        let controller = FactionsDistributionSceneController(view: self.view, viewController: self.viewController)
        controller.delegate = self
        controller.start()
        self.childController = controller
    }
    
    fileprivate func showGameScene() {
        if let _ = self.childController as? GameSceneController {
            return
        }
        
        let controller = GameSceneController(view: self.view, viewController: self.viewController)
        controller.delegate = self
        controller.start()
        self.childController = controller
    }
    
    fileprivate func showEndGameScene(withWinner winner: Player?) {
        if let _ = self.childController as? EndGameSceneController {
            return
        }
        
        let controller = EndGameSceneController(view: self.view, viewController: self.viewController)
        controller.delegate = self
        controller.winner = winner
        controller.start()
        self.childController = controller
    }
}


// MARK: - Extension (HomeCoordinatorDelegate)

extension ApplicationCoordinator: HomeSceneControllerDelegate {
    func nextStep(from controller: HomeSceneController) {
        ApplicationState.instance.setUpPlayers()
    }
}


// MARK: - Extension (PlayersCoordinatorDelegate)

extension ApplicationCoordinator: PlayersSceneControllerDelegate {
    func nextStep(from controller: PlayersSceneController) {
        ApplicationState.instance.setUpFactions()
    }
}


// MARK: - Extension (FactionsCoordinatorDelegate)

extension ApplicationCoordinator: FactionsSceneControllerDelegate {
    func nextStep(from controller: FactionsSceneController) {
        ApplicationState.instance.distributeFactions()
    }
    
    func previousStep(from controller: FactionsSceneController) {
        ApplicationState.instance.setUpPlayers()
    }
}


// MARK: - Extension (FactionsDistributionCoordinatorDelegate)

extension ApplicationCoordinator: FactionsDistributionSceneControllerDelegate {
    func nextStep(from controller: FactionsDistributionSceneController) {
        ApplicationState.instance.startGame()
    }
}


// MARK: - Extension (GameCoordinatorDelegate)

extension ApplicationCoordinator: GameSceneControllerDelegate {
    func endGame(from controller: GameSceneController) {
        ApplicationState.instance.endGame()
    }
}


// MARK: - Extension (EndGameCoordinatorDelegate)

extension ApplicationCoordinator: EndGameSceneControllerDelegate {
    func newGame(from controller: EndGameSceneController) {
        ApplicationState.instance.newGame()
    }
    
    func replay(from controller: EndGameSceneController) {
        ApplicationState.instance.replayGame()
    }
    
    func reset(from controller: EndGameSceneController) {
        ApplicationState.instance.resetGame()
    }
}

