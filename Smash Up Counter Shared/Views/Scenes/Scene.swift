//
//  Scene.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit

/*
 The class Scene defines common behaviours for the SKScene objects of the application.
 Each scene has a title (containing in a node).
 
 When a scene enters or exits, its nodes are animated (moved in or moved out from the edges of the screen). These animations are defined
 by overriding the methods enter(withCompletion completion: (() -> Void)? = nil) and exit(withCompletion completion: (() -> Void)? = nil).

 The method setUp() can be overriden in order to update the nodes of the scene before it enters.
 
 The closure setUpCompletion can be defined by the controller to update the nodes once the setup is done.
 The closure enterCompletion can be defined by the controller to update the nodes once the scene is entered (after the enter animations).
 */

// MARK: - Definition

class Scene: SKScene {
    
    // MARK: - Children nodes
    
    lazy var titleNode: SKNode? = {
        return self.childNode(withName: "//title")
    }()
    
    
    // MARK: - Handlers
    
    // To be defined by the controller to update the nodes once the setup is done.
    var setUpCompletion: (() -> Void)? = nil
    
    // To be defined by the controller to update the nodes once the scene is entered (after the enter animations).
    var enterCompletion: (() -> Void)? = nil
    
    
    // MARK: - Life cycle
    
    class func newScene() -> Scene {
        return Scene()
    }
    
    // To override in order to update the nodes of the scene before it enters.
    // i.e. update the title of the scene accordingly the data passed by the controller.
    func setUp() {
    }
    
    // To override in order to define the animations of the nodes when this scene enters.
    // i.e. use the method moveNodes(fromTheTop topNodes: [SKNode?]?, fromTheBottom bottomNodes: [SKNode?]?, fromTheLeft leftNodes: [SKNode?]?, fromTheRight rightNodes: [SKNode?]?, animated: Bool, withCompletion completion: (() -> Void)? = nil)
    func enter(withCompletion completion: (() -> Void)? = nil) {
        completion?()
    }
    
    // To override in order to define the animations of the nodes when this scene exits.
    // i.e. use the method moveNodes(toTheTop topNodes: [SKNode?]?, toTheBottom bottomNodes: [SKNode?]?, toTheLeft leftNodes: [SKNode?]?, toTheRight rightNodes: [SKNode?]?, animated: Bool, withCompletion completion: (() -> Void)? = nil)
    func exit(withCompletion completion: (() -> Void)? = nil) {
        completion?()
    }
    
    
    // MARK: - Displaying
    
    func setTitle(title: String) {
        if let label = self.titleNode as? SKLabelNode {
            label.text = title
            label.applyTitleStyle()
        }
    }
    
    
    // MARK: - Touch handling
    
    func node(with touches: Set<UITouch>, and event: UIEvent?) -> SKNode? {
        guard let touch = touches.first else {
            return nil
        }
        
        let positionInScene = touch.location(in: self)
        return self.atPoint(positionInScene)
    }
    
    
    // MARK: - Node animation
    
    func moveNodes(toTheTop topNodes: [SKNode?]?, toTheBottom bottomNodes: [SKNode?]?, toTheLeft leftNodes: [SKNode?]?, toTheRight rightNodes: [SKNode?]?, animated: Bool, withCompletion completion: (() -> Void)? = nil) {
        guard let height = self.view?.frame.size.height, let width = self.view?.frame.size.width else {
            completion?()
            return
        }
        
        var completionCalled = false
        
        if let nodes = topNodes {
            for (i, node) in nodes.enumerated() {
                if i == 0 && !completionCalled {
                    node?.moveOutToTop(withViewHeight: height, animated: animated, forced: true, andCompletion: completion)
                    completionCalled = true
                } else {
                    node?.moveOutToTop(withViewHeight: height, animated: animated, forced: true)
                }
            }
        }
        
        if let nodes = bottomNodes {
            for (i, node) in nodes.enumerated() {
                if i == 0 && !completionCalled {
                    node?.moveOutToBottom(withViewHeight: height, animated: animated, forced: true, andCompletion: completion)
                    completionCalled = true
                } else {
                    node?.moveOutToBottom(withViewHeight: height, animated: animated, forced: true)
                }
            }
        }
        
        if let nodes = leftNodes {
            for (i, node) in nodes.enumerated() {
                if i == 0 && !completionCalled {
                    node?.moveOutToLeft(withViewWidth: width, animated: animated, forced: true, andCompletion: completion)
                    completionCalled = true
                } else {
                    node?.moveOutToLeft(withViewWidth: width, animated: animated, forced: true)
                }
            }
        }
        
        if let nodes = rightNodes {
            for (i, node) in nodes.enumerated() {
                if i == 0 && !completionCalled {
                    node?.moveOutToRight(withViewWidth: width, animated: animated, forced: true, andCompletion: completion)
                    completionCalled = true
                } else {
                    node?.moveOutToRight(withViewWidth: width, animated: animated, forced: true)
                }
            }
        }
    }
    
    func moveNodes(fromTheTop topNodes: [SKNode?]?, fromTheBottom bottomNodes: [SKNode?]?, fromTheLeft leftNodes: [SKNode?]?, fromTheRight rightNodes: [SKNode?]?, animated: Bool, withCompletion completion: (() -> Void)? = nil) {
        guard let height = self.view?.frame.size.height, let width = self.view?.frame.size.width else {
            completion?()
            return
        }
        
        var completionCalled = false
        
        if let nodes = topNodes {
            for (i, node) in nodes.enumerated() {
                if i == 0 && !completionCalled {
                    node?.moveInFromTop(withViewHeight: height, animated: animated, forced: true, andCompletion: completion)
                    completionCalled = true
                } else {
                    node?.moveInFromTop(withViewHeight: height, animated: animated, forced: true)
                }
            }
        }
        
        if let nodes = bottomNodes {
            for (i, node) in nodes.enumerated() {
                if i == 0 && !completionCalled {
                    node?.moveInFromBottom(withViewHeight: height, animated: animated, forced: true, andCompletion: completion)
                    completionCalled = true
                } else {
                    node?.moveInFromBottom(withViewHeight: height, animated: animated, forced: true)
                }
            }
        }
        
        if let nodes = leftNodes {
            for (i, node) in nodes.enumerated() {
                if i == 0 && !completionCalled {
                    node?.moveInFromLeft(withViewWidth: width, animated: animated, forced: true, andCompletion: completion)
                    completionCalled = true
                } else {
                    node?.moveInFromLeft(withViewWidth: width, animated: animated, forced: true)
                }
            }
        }
        
        if let nodes = rightNodes {
            for (i, node) in nodes.enumerated() {
                if i == 0 && !completionCalled {
                    node?.moveInFromRight(withViewWidth: width, animated: animated, forced: true, andCompletion: completion)
                    completionCalled = true
                } else {
                    node?.moveInFromRight(withViewWidth: width, animated: animated, forced: true)
                }
            }
        }
    }
    
    
    // MARK: - Overrides
    
    #if os(watchOS)
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.setUp()
        self.setUpCompletion?()
        self.enter(withCompletion: self.enterCompletion)
    }
    #else
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.setUp()
        self.setUpCompletion?()
        self.enter(withCompletion: self.enterCompletion)
    }
    #endif
}
