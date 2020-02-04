//
//  GameScene.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Protocol (GameSceneDelegate)

protocol GameSceneDelegate: class {
    func incrementScoreBy(points: Int, ofPlayer name: String)
    func decrementScoreBy(points: Int, ofPlayer name: String)
    func endGame(from scene: GameScene)
}


// MARK: - Definition

class GameScene: Scene {
    
    // MARK: - Children nodes
    
    fileprivate lazy var playerNodes: [PlayerNode] = {
        if let nodes = self.scene?["//player"] as? [PlayerNode] {
            return nodes
        }
        
        return [PlayerNode]()
    }()
    
    fileprivate lazy var endGameButton: Button? = {
        return self.button(withName: "//end_game_button", andSetLabel: NSLocalizedString("gameScene.button.endGame", value: "End Game", comment: "Label of the game scene button 'end game'."))
    }()
    
    
    // MARK: - Delegates
    
    weak var sceneDelegate: GameSceneDelegate?
    
    
    // MARK: - Life cycle
    
    override class func newScene() -> Scene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func setUp() {
        super.setUp()
        self.setTitle(title: NSLocalizedString("gameScene.title", value: "Game", comment: "Title of the game scene."))
    }
    
    override func enter(withCompletion completion: (() -> Void)?) {
        let (leftNodes, rightNodes) = self.getLeftAndRightPlayerNodes()
        
        self.moveNodes(fromTheTop: [self.titleNode],
                       fromTheBottom: [self.endGameButton?.referentNode],
                       fromTheLeft: leftNodes,
                       fromTheRight: rightNodes,
                       animated: true,
                       withCompletion: completion)
    }
    
    override func exit(withCompletion completion: (() -> Void)?) {
        let (leftNodes, rightNodes) = self.getLeftAndRightPlayerNodes()
        
        self.moveNodes(toTheTop: [self.titleNode],
                       toTheBottom: [self.endGameButton?.referentNode],
                       toTheLeft: leftNodes,
                       toTheRight: rightNodes,
                       animated: true,
                       withCompletion: completion)
    }
    
    
    // MARK: - Displaying
    
    func setPlayers(_ players: [Player]) {
        for (index, node) in self.playerNodes.enumerated() {
            if index >= players.count {
                node.isHidden = true
                continue
            }
            
            let player = players[index]
            node.setUp(withPlayer: player, animated: false)
            node.isHidden = false
        }
    }
    
    func updatePlayerNode(withPlayer player: Player) {
        for (_, node) in self.playerNodes.enumerated() {
            if let nodeName = node.playerName, nodeName == player.name {
                node.setUp(withPlayer: player, animated: true)
                break
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func getLeftAndRightPlayerNodes() -> ([SKNode?], [SKNode?]) {
        var leftNodes = [SKNode?]()
        var rightNodes = [SKNode?]()
        
        for (i, node) in self.playerNodes.enumerated() {
            if i%2 == 0 {
                leftNodes.append(node.parent)
            } else {
                rightNodes.append(node.parent)
            }
        }
        
        return (leftNodes, rightNodes)
    }
    
    
    // MARK: - Events
    
    fileprivate func didSelectIncrementScoreBy(points: Int, ofPlayer name: String) {
        self.sceneDelegate?.incrementScoreBy(points: points, ofPlayer: name)
    }
    
    fileprivate func didSelectDecrementScoreBy(points: Int, ofPlayer name: String) {
        self.sceneDelegate?.decrementScoreBy(points: points, ofPlayer: name)
    }
    
    fileprivate func didSelectEndGame() {
        self.sceneDelegate?.endGame(from: self)
    }
}


// MARK: - Touch-based event handling

extension GameScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = self.node(with: touches, and: event) else {
            return
        }
        
        if let endGameButton = self.endGameButton, endGameButton.isTouched(node: touchedNode) {
            self.didSelectEndGame()
            return
        }
        
        if let nodeName = touchedNode.name, (nodeName.starts(with: "increment_points") || nodeName.starts(with: "decrement_points")),
            let playerNode = touchedNode.parent as? PlayerNode, let playerName = playerNode.playerName {
            if nodeName.starts(with: "increment_points") {
                self.didSelectIncrementScoreBy(points: 1, ofPlayer: playerName)
            } else {
                self.didSelectDecrementScoreBy(points: 1, ofPlayer: playerName)
            }
            return
        }
    }
}

