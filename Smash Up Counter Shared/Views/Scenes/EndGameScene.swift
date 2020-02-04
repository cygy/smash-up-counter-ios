//
//  EndGameScene.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 03/04/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Protocol (EndGameSceneDelegate)

protocol EndGameSceneDelegate: class {
    func replay(from scene: EndGameScene)
    func reset(from scene: EndGameScene)
    func newGame(from scene: EndGameScene)
}


// MARK: - Definition

class EndGameScene: Scene {
    
    // MARK: - Children nodes
    
    fileprivate lazy var winnerNameLabel: SKLabelNode? = {
        return self.childNode(withName: "//winner_name") as? SKLabelNode
    }()
    
    fileprivate lazy var firstFactionNode: BigFactionNode? = {
        if let factionNodes = self.scene?["//faction"] as? [BigFactionNode], factionNodes.count > 0 {
            return factionNodes[0]
        }
        
        return nil
    }()
    
    fileprivate lazy var secondFactionNode: BigFactionNode? = {
        if let factionNodes = self.scene?["//faction"] as? [BigFactionNode], factionNodes.count > 1 {
            return factionNodes[1]
        }
        
        return nil
    }()
    
    fileprivate lazy var replayButton: Button? = {
        return self.button(withName: "//replay_button", andSetLabel: NSLocalizedString("endGameScene.button.replay", value: "Replay", comment: "Label of the end game scene button 'replay'."))
    }()
    
    fileprivate lazy var resetButton: Button? = {
        return self.button(withName: "//reset_button", andSetLabel: NSLocalizedString("endGameScene.button.reset", value: "Reset", comment: "Label of the end game scene button 'reset'."))
    }()
    
    fileprivate lazy var newGameButton: Button? = {
        return self.button(withName: "//new_game_button", andSetLabel: NSLocalizedString("endGameScene.button.newGame", value: "New Game", comment: "Label of the end game scene button 'new game'."))
    }()
    
    
    // MARK: - Delegates
    
    weak var sceneDelegate: EndGameSceneDelegate?
    
    
    // MARK: - Life cycle
    
    override class func newScene() -> Scene {
        guard let scene = SKScene(fileNamed: "EndGameScene") as? EndGameScene else {
            print("Failed to load EndGameScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func enter(withCompletion completion: (() -> Void)?) {
        self.moveNodes(fromTheTop: [self.winnerNameLabel],
                       fromTheBottom: [self.replayButton?.referentNode, self.resetButton?.referentNode, self.newGameButton?.referentNode],
                       fromTheLeft: [self.firstFactionNode?.parent],
                       fromTheRight: [self.secondFactionNode?.parent],
                       animated: true,
                       withCompletion: {
                        self.firstFactionNode?.parent?.run(SKAction.slowlyMoveAction(amplitudeX: 10, amplitudeY: 10))
                        self.secondFactionNode?.parent?.run(SKAction.slowlyMoveAction(amplitudeX: 10, amplitudeY: 10))
                        
                        completion?()
        })
    }
    
    override func exit(withCompletion completion: (() -> Void)?) {
        self.moveNodes(toTheTop: [self.winnerNameLabel],
                       toTheBottom: [self.replayButton?.referentNode, self.resetButton?.referentNode, self.newGameButton?.referentNode],
                       toTheLeft: [self.firstFactionNode?.parent],
                       toTheRight: [self.secondFactionNode?.parent],
                       animated: true,
                       withCompletion: completion)
    }
    
    
    // MARK: - Displaying
    
    func setWinner(_ winner: Player?) {
        self.winnerNameLabel?.text = winner?.name
        self.winnerNameLabel?.applyTextStyle()
        
        if let factions = winner?.factions, factions.count == 2 {
            self.firstFactionNode?.isHidden = false
            self.firstFactionNode?.isHidden = false
            self.firstFactionNode?.setUp(withFaction: factions[0])
            self.secondFactionNode?.setUp(withFaction: factions[1])
            self.firstFactionNode?.showFaction()
            self.secondFactionNode?.showFaction()
        } else {
            self.firstFactionNode?.isHidden = true
            self.firstFactionNode?.isHidden = true
        }
    }
    
    
    // MARK: - Events
    
    fileprivate func didSelectReplay() {
        self.sceneDelegate?.replay(from: self)
    }
    
    fileprivate func didSelectReset() {
        self.sceneDelegate?.reset(from: self)
    }
    
    fileprivate func didSelectNewGame() {
        self.sceneDelegate?.newGame(from: self)
    }
}


// MARK: - Touch-based event handling

extension EndGameScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = self.node(with: touches, and: event) else {
            return
        }
        
        if let resetButton = self.resetButton, resetButton.isTouched(node: touchedNode) {
            self.didSelectReset()
            return
        }
        
        if let replayButton = self.replayButton, replayButton.isTouched(node: touchedNode) {
            self.didSelectReplay()
            return
        }
        
        if let newGameButton = self.newGameButton, newGameButton.isTouched(node: touchedNode) {
            self.didSelectNewGame()
            return
        }
    }
}


