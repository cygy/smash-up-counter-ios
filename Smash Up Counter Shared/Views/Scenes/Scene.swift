//
//  Scene.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Definition

class Scene: SKScene {
    
    // MARK: - Children nodes
    
    lazy var titleNode: SKNode? = {
        return self.childNode(withName: "//title")
    }()
    
    
    // MARK: - Handlers
    
    var setUpCompletion: (() -> Void)? = nil
    var enterCompletion: (() -> Void)? = nil
    
    
    // MARK: - Life cycle
    
    class func newScene() -> Scene {
        return Scene()
    }
    
    func setUp() {
    }
    
    func enter(withCompletion completion: (() -> Void)? = nil) {
        completion?()
    }
    
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
