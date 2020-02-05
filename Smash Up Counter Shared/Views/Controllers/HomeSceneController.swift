//
//  HomeSceneController.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit

/*
 The class HomeSceneController manages the first screen of the application, the welcome screen.
 This screen is displayed while the initial data is initialized. Once it is, the scene displays
 a button to prepare a new game.
 
 This controller observes the ApplicationState singleton's state property to update its scene accordingly.
 */

// MARK: - Protocol (HomeSceneControllerDelegate)

protocol HomeSceneControllerDelegate: class {
    func nextStep(from controller: HomeSceneController)
}


// MARK: - Definition

class HomeSceneController: SceneController<HomeScene> {
    
    // MARK: - Properties
    
    weak var delegate: HomeSceneControllerDelegate?
    
    
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

extension HomeSceneController: HomeSceneDelegate {
    func nextStep(from scene: HomeScene) {
        scene.exit { [unowned self] in
            self.delegate?.nextStep(from: self)
        }
    }
}
