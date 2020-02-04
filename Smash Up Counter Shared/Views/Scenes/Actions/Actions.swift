//
//  Actions.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 04/04/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import Foundation
import SpriteKit


// MARK: - Extension (new actions)

extension SKAction {
    
    // MARK: - Constants
    
    fileprivate static let moveInDuration: TimeInterval = 0.4
    fileprivate static let moveOutDuration: TimeInterval = 0.2
    fileprivate static let moveOutDelta: CGFloat = 10.0
    fileprivate static let moveOutScaleFactor: CGFloat = 1.2
    
    fileprivate static let shakeDuration: TimeInterval = 0.02
    fileprivate static let slowlyMoveDuration: TimeInterval = 1.0
    
    
    // MARK: - Actions
    
    static func shakeAction(amplitudeX: CGFloat, amplitudeY: CGFloat, duration: TimeInterval)  -> SKAction {
        let numberOfShakes = Int(duration / (SKAction.shakeDuration * 2.0))
        var actions = [SKAction]()
        
        for i in 1...numberOfShakes {
            let maxAmplitudeX = CGFloat(i) * amplitudeX/CGFloat(numberOfShakes)
            let maxAmplitudeY = CGFloat(i) * amplitudeY/CGFloat(numberOfShakes)
            let moveX = CGFloat(arc4random_uniform(UInt32(maxAmplitudeX))) - (maxAmplitudeX/2.0)
            let moveY = CGFloat(arc4random_uniform(UInt32(maxAmplitudeY))) - (maxAmplitudeY/2.0)
            let shakeAction = SKAction.moveBy(x: moveX, y: moveY, duration: SKAction.shakeDuration)
            shakeAction.timingMode = .easeOut
            actions.append(shakeAction)
            actions.append(shakeAction.reversed())
        }
        
        return SKAction.sequence(actions)
    }
    
    static func slowlyMoveAction(amplitudeX: CGFloat, amplitudeY: CGFloat)  -> SKAction {
        var actions = [SKAction]()
        
        for _ in 1...10 {
            let moveX = CGFloat(arc4random_uniform(UInt32(amplitudeX)))
            let moveY = CGFloat(arc4random_uniform(UInt32(amplitudeY)))
            let moveAction = SKAction.moveBy(x: moveX, y: moveY, duration: SKAction.slowlyMoveDuration)
            moveAction.timingMode = .easeInEaseOut
            actions.append(moveAction)
            actions.append(moveAction.reversed())
        }
        
        let sequence = SKAction.sequence(actions)
        
        return SKAction.repeatForever(sequence)
    }
    
    static func moveOut(from initialPosition: CGPoint, toTop finalPosition: CGPoint) -> SKAction {
        let delta = abs(finalPosition.y - initialPosition.y)
        
        let moveInAction = SKAction.moveBy(x: 0.0, y: -SKAction.moveOutDelta, duration: SKAction.moveInDuration)
        moveInAction.timingMode = .easeOut
        
        let moveOutAction = SKAction.moveBy(x: 0.0, y: (delta + SKAction.moveOutDelta), duration: SKAction.moveOutDuration)
        moveOutAction.timingMode = .easeIn
        
        return SKAction.sequence([moveInAction, moveOutAction])
    }
    
    static func moveOut(from initialPosition: CGPoint, toBottom finalPosition: CGPoint) -> SKAction {
        let delta = abs(finalPosition.y - initialPosition.y)
        
        let moveInAction = SKAction.moveBy(x: 0.0, y: SKAction.moveOutDelta, duration: SKAction.moveInDuration)
        moveInAction.timingMode = .easeOut
        
        let moveOutAction = SKAction.moveBy(x: 0.0, y: -(delta + SKAction.moveOutDelta), duration: SKAction.moveOutDuration)
        moveOutAction.timingMode = .easeIn
        
        return SKAction.sequence([moveInAction, moveOutAction])
    }
    
    static func moveOut(from initialPosition: CGPoint, toLeft finalPosition: CGPoint) -> SKAction {
        let delta = abs(finalPosition.x - initialPosition.x)
        
        let moveInAction = SKAction.moveBy(x: SKAction.moveOutDelta, y: 0.0, duration: SKAction.moveInDuration)
        moveInAction.timingMode = .easeOut
        
        let moveOutAction = SKAction.moveBy(x: -(delta + SKAction.moveOutDelta), y: 0.0, duration: SKAction.moveOutDuration)
        moveOutAction.timingMode = .easeIn
        
        return SKAction.sequence([moveInAction, moveOutAction])
    }
    
    static func moveOut(from initialPosition: CGPoint, toRight finalPosition: CGPoint) -> SKAction {
        let delta = abs(finalPosition.x - initialPosition.x)
        
        let moveInAction = SKAction.moveBy(x: -SKAction.moveOutDelta, y: 0.0, duration: SKAction.moveInDuration)
        moveInAction.timingMode = .easeOut
        
        let moveOutAction = SKAction.moveBy(x: (delta + SKAction.moveOutDelta), y: 0.0, duration: SKAction.moveOutDuration)
        moveOutAction.timingMode = .easeIn
        
        return SKAction.sequence([moveInAction, moveOutAction])
    }
    
    static func moveOut(fromScale scale: CGFloat) -> SKAction {
        let scaleUpAction = SKAction.scale(to: (scale * SKAction.moveOutScaleFactor), duration: SKAction.moveInDuration)
        scaleUpAction.timingMode = .easeOut
        
        let scaleDownAction = SKAction.scale(to: 0.0, duration: SKAction.moveOutDuration)
        scaleDownAction.timingMode = .easeIn
        
        return SKAction.sequence([scaleUpAction, scaleDownAction])
    }
    
    static func moveIn(toScale scale: CGFloat) -> SKAction {
        let scaleUpAction = SKAction.scale(to: (scale * SKAction.moveOutScaleFactor), duration: SKAction.moveInDuration)
        scaleUpAction.timingMode = .easeIn
        
        let scaleDownAction = SKAction.scale(to: scale, duration: SKAction.moveOutDuration)
        scaleDownAction.timingMode = .easeOut
        
        return SKAction.sequence([scaleUpAction, scaleDownAction])
    }
}


// MARK: - Extension (new actions)

extension SKNode {
    
    // MARK: - Constants
    
    fileprivate static let moveOutToTopActionKey = "_moveOutToTopAction"
    fileprivate static let moveOutToBottomActionKey = "_moveOutToBottomAction"
    fileprivate static let moveOutToLeftActionKey = "_moveOutToLeftAction"
    fileprivate static let moveOutToRightActionKey = "_moveOutToRightAction"
    fileprivate static let moveOutScaleActionKey = "_moveOutScaleAction"
    
    
    // MARK: - Move Top actions
    
    func moveInFromTop(withViewHeight viewHeight: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.moveTop(out: false, withViewHeight: viewHeight, animated: animated, forced: forced, andCompletion: completion)
    }
    
    func moveOutToTop(withViewHeight viewHeight: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.moveTop(out: true, withViewHeight: viewHeight, animated: animated, forced: forced, andCompletion: completion)
    }
    
    fileprivate func moveTop(out: Bool, withViewHeight viewHeight: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.move(out: out, animated: animated, forced: forced, withKey: SKNode.moveOutToTopActionKey, actionHandler: { () -> (CGPoint, CGPoint, SKAction) in
            self.moveOutToTopAction(withViewHeight: viewHeight)
        }, andCompletion: completion)
    }
    
    
    // MARK: - Move Bottom actions
    
    func moveInFromBottom(withViewHeight viewHeight: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.moveBottom(out: false, withViewHeight: viewHeight, animated: animated, forced: forced, andCompletion: completion)
    }
    
    func moveOutToBottom(withViewHeight viewHeight: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.moveBottom(out: true, withViewHeight: viewHeight, animated: animated, forced: forced, andCompletion: completion)
    }
    
    fileprivate func moveBottom(out: Bool, withViewHeight viewHeight: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.move(out: out, animated: animated, forced: forced, withKey: SKNode.moveOutToBottomActionKey, actionHandler: { () -> (CGPoint, CGPoint, SKAction) in
            self.moveOutToBottomAction(withViewHeight: viewHeight)
        }, andCompletion: completion)
    }
    
    
    // MARK: - Move Left actions
    
    func moveInFromLeft(withViewWidth viewWidth: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.moveLeft(out: false, withViewWidth: viewWidth, animated: animated, forced: forced, andCompletion: completion)
    }
    
    func moveOutToLeft(withViewWidth viewWidth: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.moveLeft(out: true, withViewWidth: viewWidth, animated: animated, forced: forced, andCompletion: completion)
    }
    
    fileprivate func moveLeft(out: Bool, withViewWidth viewWidth: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.move(out: out, animated: animated, forced: forced, withKey: SKNode.moveOutToLeftActionKey, actionHandler: { () -> (CGPoint, CGPoint, SKAction) in
            self.moveOutToLeftAction(withViewWidth: viewWidth)
        }, andCompletion: completion)
    }
    
    
    // MARK: - Move Right actions
    
    func moveInFromRight(withViewWidth viewWidth: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.moveRight(out: false, withViewWidth: viewWidth, animated: animated, forced: forced, andCompletion: completion)
    }
    
    func moveOutToRight(withViewWidth viewWidth: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.moveRight(out: true, withViewWidth: viewWidth, animated: animated, forced: forced, andCompletion: completion)
    }
    
    fileprivate func moveRight(out: Bool, withViewWidth viewWidth: CGFloat, animated: Bool, forced: Bool, andCompletion completion: (() -> Void)? = nil) {
        self.move(out: out, animated: animated, forced: forced, withKey: SKNode.moveOutToRightActionKey, actionHandler: { () -> (CGPoint, CGPoint, SKAction) in
            self.moveOutToRightAction(withViewWidth: viewWidth)
        }, andCompletion: completion)
    }
    
    
    // MARK: - Move Scale actions
    
    func moveInScale(animated: Bool, withCompletion completion: (() -> Void)? = nil) {
        guard animated else {
            self.setScale(1.0)
            return
        }
        
        let action = SKAction.moveIn(toScale: 1.0)
        
        self.setScale(0.0)
        self.run(action) {
            completion?()
        }
    }
    
    func moveOutScale(animated: Bool, withCompletion completion: (() -> Void)? = nil) {
        guard animated else {
            self.setScale(0.0)
            return
        }
        
        let action = SKAction.moveOut(fromScale: self.xScale)
        
        self.run(action) {
            completion?()
        }
    }
    
    
    // MARK: - Actions
    
    fileprivate func moveOutToTopAction(withViewHeight viewHeight: CGFloat) -> (CGPoint, CGPoint, SKAction) {
        let initialPosition = self.position
        let finalPosition = CGPoint(x: initialPosition.x, y: (initialPosition.y + (viewHeight*2/3)))
        let action = SKAction.moveOut(from: initialPosition, toTop: finalPosition)
        
        self.save(action: action, initialValue: self.position, andFinalValue: finalPosition, withKey: SKNode.moveOutToTopActionKey)
        
        return (initialPosition, finalPosition, action)
    }
    
    fileprivate func moveOutToBottomAction(withViewHeight viewHeight: CGFloat) -> (CGPoint, CGPoint, SKAction) {
        let initialPosition = self.position
        let finalPosition = CGPoint(x: initialPosition.x, y: (initialPosition.y - (viewHeight*2/3)))
        let action = SKAction.moveOut(from: initialPosition, toBottom: finalPosition)
        
        self.save(action: action, initialValue: self.position, andFinalValue: finalPosition, withKey: SKNode.moveOutToBottomActionKey)
        
        return (initialPosition, finalPosition, action)
    }
    
    fileprivate func moveOutToLeftAction(withViewWidth viewWidth: CGFloat) -> (CGPoint, CGPoint, SKAction) {
        let initialPosition = self.position
        let finalPosition = CGPoint(x: (initialPosition.x - (viewWidth*2/3)), y: initialPosition.y)
        let action = SKAction.moveOut(from: initialPosition, toLeft: finalPosition)
        
        self.save(action: action, initialValue: self.position, andFinalValue: finalPosition, withKey: SKNode.moveOutToLeftActionKey)
        
        return (initialPosition, finalPosition, action)
    }
    
    fileprivate func moveOutToRightAction(withViewWidth viewWidth: CGFloat) -> (CGPoint, CGPoint, SKAction) {
        let initialPosition = self.position
        let finalPosition = CGPoint(x: (initialPosition.x + (viewWidth*2/3)), y: initialPosition.y)
        let action = SKAction.moveOut(from: initialPosition, toRight: finalPosition)
        
        self.save(action: action, initialValue: self.position, andFinalValue: finalPosition, withKey: SKNode.moveOutToRightActionKey)
        
        return (initialPosition, finalPosition, action)
    }
    
    fileprivate func move(out: Bool, animated: Bool, forced: Bool, withKey key: String, actionHandler: (() -> (CGPoint, CGPoint, SKAction)), andCompletion completion: (() -> Void)? = nil) {
        var savedInitialPosition: CGPoint?
        var savedFinalPosition: CGPoint?
        var savedAction: SKAction?
        
        if let (initialValue, finalValue, action) = self.savedAction(forKey: key) as? (CGPoint, CGPoint, SKAction) {
            savedInitialPosition = initialValue
            savedFinalPosition = finalValue
            savedAction = action
        } else {
            let (initialValue, finalValue, action) = actionHandler()
            savedInitialPosition = initialValue
            savedFinalPosition = finalValue
            savedAction = action
        }
        
        guard let action = savedAction, let initialPosition = savedInitialPosition, let finalPosition = savedFinalPosition else {
            return
        }
        
        if out {
            guard animated && (forced || self.position != finalPosition) else {
                self.position = finalPosition
                completion?()
                return
            }
            
            self.position = initialPosition
            self.run(action) {
                completion?()
            }
        } else {
            guard animated && (forced || self.position != initialPosition) else {
                self.position = initialPosition
                completion?()
                return
            }
            
            self.position = finalPosition
            self.run(action.reversed()) {
                completion?()
            }
        }
    }
    
    
    // MARK: - Actions management
    
    fileprivate func save(action: SKAction, initialValue: Any, andFinalValue finalValue: Any, withKey key: String) {
        if self.userData == nil {
            self.userData = NSMutableDictionary()
        }
        self.userData?[key] = (initialValue, finalValue, action)
    }
    
    fileprivate func savedAction(forKey key: String) -> (Any, Any, SKAction)? {
        return self.userData?[key] as? (Any, Any, SKAction)
    }
    
    func clearSavedMoveActions() {
        self.userData?.removeObjects(forKeys: [SKNode.moveOutToTopActionKey, SKNode.moveOutToBottomActionKey, SKNode.moveOutToLeftActionKey, SKNode.moveOutToRightActionKey])
    }
}
