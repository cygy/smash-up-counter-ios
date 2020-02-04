//
//  MainCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import RxSwift


// MARK: - Definition

class MainCoordinator {
    
    // MARK: - Properties
    
    fileprivate let view: SKView
    fileprivate let viewController: UIViewController
    fileprivate var childCoordinator: Coordinator?
    
    fileprivate let disposeBag = DisposeBag()
    
    
    // MARK: - Life cycle
    
    init(withView view: SKView, andViewController viewController: UIViewController) {
        self.view = view
        self.viewController = viewController
    }
    
    func start() {
        ApplicationState.instance.state.asObservable().distinctUntilChanged().subscribe { [weak self] state in
            guard let state = state.element else {
                return
            }
            
            switch state {
            case .none, .initializing, .ready:
                self?.showHomeScreen()
            case .settingUpPlayers:
                self?.showSetUpPlayersScreen()
            case .settingUpFactions:
                self?.showSetUpFactionsScreen()
            case .factionsDistributed:
                self?.showFactionsDistributionScreen()
            case .playing:
                self?.showGameScreen()
            case .endGame(let winner):
                self?.showEndGameScreen(withWinner: winner)
            }
        }.disposed(by: disposeBag)
    }
    
    
    // MARK: - Screen transitions
    
    fileprivate func showHomeScreen() {
        if let _ = self.childCoordinator as? HomeCoordinator {
            return
        }
        
        let coordinator = HomeCoordinator(view: self.view, viewController: self.viewController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinator = coordinator
    }
    
    fileprivate func showSetUpPlayersScreen() {
        if let _ = self.childCoordinator as? PlayersCoordinator {
            return
        }
        
        let coordinator = PlayersCoordinator(view: self.view, viewController: self.viewController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinator = coordinator
    }
    
    fileprivate func showSetUpFactionsScreen() {
        if let _ = self.childCoordinator as? FactionsCoordinator {
            return
        }
        
        let coordinator = FactionsCoordinator(view: self.view, viewController: self.viewController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinator = coordinator
    }
    
    fileprivate func showFactionsDistributionScreen() {
        if let _ = self.childCoordinator as? FactionsDistributionCoordinator {
            return
        }
        
        let coordinator = FactionsDistributionCoordinator(view: self.view, viewController: self.viewController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinator = coordinator
    }
    
    fileprivate func showGameScreen() {
        if let _ = self.childCoordinator as? GameCoordinator {
            return
        }
        
        let coordinator = GameCoordinator(view: self.view, viewController: self.viewController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinator = coordinator
    }
    
    fileprivate func showEndGameScreen(withWinner winner: Player?) {
        if let _ = self.childCoordinator as? EndGameCoordinator {
            return
        }
        
        let coordinator = EndGameCoordinator(view: self.view, viewController: self.viewController)
        coordinator.delegate = self
        coordinator.winner = winner
        coordinator.start()
        self.childCoordinator = coordinator
    }
}


// MARK: - Extension (HomeCoordinatorDelegate)

extension MainCoordinator: HomeCoordinatorDelegate {
    func nextStep(from coordinator: HomeCoordinator) {
        ApplicationState.instance.setUpPlayers()
    }
}


// MARK: - Extension (PlayersCoordinatorDelegate)

extension MainCoordinator: PlayersCoordinatorDelegate {
    func nextStep(from coordinator: PlayersCoordinator) {
        ApplicationState.instance.setUpFactions()
    }
}


// MARK: - Extension (FactionsCoordinatorDelegate)

extension MainCoordinator: FactionsCoordinatorDelegate {
    func nextStep(from coordinator: FactionsCoordinator) {
        ApplicationState.instance.distributeFactions()
    }
    
    func previousStep(from coordinator: FactionsCoordinator) {
        ApplicationState.instance.setUpPlayers()
    }
}


// MARK: - Extension (FactionsDistributionCoordinatorDelegate)

extension MainCoordinator: FactionsDistributionCoordinatorDelegate {
    func nextStep(from coordinator: FactionsDistributionCoordinator) {
        ApplicationState.instance.startGame()
    }
}


// MARK: - Extension (GameCoordinatorDelegate)

extension MainCoordinator: GameCoordinatorDelegate {
    func endGame(from coordinator: GameCoordinator) {
        ApplicationState.instance.endGame()
    }
}


// MARK: - Extension (EndGameCoordinatorDelegate)

extension MainCoordinator: EndGameCoordinatorDelegate {
    func newGame(from coordinator: EndGameCoordinator) {
        ApplicationState.instance.newGame()
    }
    
    func replay(from coordinator: EndGameCoordinator) {
        ApplicationState.instance.replayGame()
    }
    
    func reset(from coordinator: EndGameCoordinator) {
        ApplicationState.instance.resetGame()
    }
}

