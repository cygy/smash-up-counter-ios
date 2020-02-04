//
//  HomeScene.swift
//  Smash Up Counter Shared
//
//  Created by Cyril on 08/01/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Protocol (HomeSceneDelegate)

protocol HomeSceneDelegate: class {
    func nextStep(from scene: HomeScene)
}


// MARK: - Definition

class HomeScene: Scene {
    
    // MARK: - Children nodes

    fileprivate lazy var logo: SKNode? = {
        return self.childNode(withName: "//logo")
    }()
    
    fileprivate lazy var newGameButton: Button? = {
        return self.button(withName: "//button_newGame", andSetLabel: NSLocalizedString("homeScene.button.newGame", value: "New Game", comment: "Label of the home scene button 'new game'."))
    }()
    
    
    // MARK: - Delegates
    
    weak var sceneDelegate: HomeSceneDelegate?
    
    
    // MARK: - Life cycle
    
    override class func newScene() -> Scene {
        guard let scene = SKScene(fileNamed: "HomeScene") as? HomeScene else {
            print("Failed to load HomeScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func enter(withCompletion completion: (() -> Void)?) {
        self.logo?.moveInScale(animated: true, withCompletion: completion)
    }
    
    override func exit(withCompletion completion: (() -> Void)?) {
        self.moveNodes(toTheTop: [self.logo],
                       toTheBottom: [self.newGameButton?.referentNode],
                       toTheLeft: nil,
                       toTheRight: nil,
                       animated: true,
                       withCompletion: completion)
    }
    
    
    // MARK: - Displaying
    
    func showLoading(animated: Bool) {
        self.newGameButton?.referentNode?.moveOutScale(animated: animated)
    }
    
    func hideLoading(animated: Bool) {
        self.newGameButton?.referentNode?.moveInScale(animated: animated)
    }
    
    
    // MARK: - Events
    
    fileprivate func didSelectNextStep() {
        self.sceneDelegate?.nextStep(from: self)
    }
}


// MARK: - Touch-based event handling

extension HomeScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = self.node(with: touches, and: event) else {
            return
        }
        
        if let newGameButton = self.newGameButton, newGameButton.isTouched(node: touchedNode) {
            self.didSelectNextStep()
        }
    }
}

