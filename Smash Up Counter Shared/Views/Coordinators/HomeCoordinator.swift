//
//  HomeCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import ReactiveReSwift


// MARK: - Protocol (HomeCoordinatorDelegate)

protocol HomeCoordinatorDelegate: class {
    func nextStep(from coordinator: HomeCoordinator)
}


// MARK: - Definition

class HomeCoordinator: SceneCoordinator<HomeScene> {
    
    // MARK: - Properties
    
    weak var delegate: HomeCoordinatorDelegate?
    
    
    // MARK: - Life cycle
    
    override func start() {
        self.scene.sceneDelegate = self
        
        self.scene.setUpCompletion = { [unowned self] in
            self.updateLoadingView(withState: ApplicationState.instance.state.value, animated: false)
        }
        
        self.scene.enterCompletion = { [unowned self] in
            ApplicationState.instance.state.asObservable().distinctUntilChanged().subscribe { [weak self] state in
                guard let state = state.element else {
                    return
                }
                self?.updateLoadingView(withState: state, animated: true)
            }.disposed(by: self.disposeBag)
        }
        
        self.view.presentScene(self.scene)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func updateLoadingView(withState state: State, animated: Bool) {
        switch state {
        case .initializing, .none:
            self.scene.showLoading(animated: animated)
        default:
            self.scene.hideLoading(animated: animated)
        }
    }
}


// MARK: - Extension (HomeSceneDelegate)

extension HomeCoordinator: HomeSceneDelegate {
    func nextStep(from scene: HomeScene) {
        scene.exit { [unowned self] in
            self.delegate?.nextStep(from: self)
        }
    }
}
