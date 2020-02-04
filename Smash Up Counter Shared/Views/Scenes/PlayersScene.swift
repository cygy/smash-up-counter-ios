//
//  PlayersScene.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Protocol (PlayersSceneDelegate)

protocol PlayersSceneDelegate: class {
    func nextStep(from scene: PlayersScene)
    func addPlayer(from scene: PlayersScene)
    func removePlayer(with name: String, from scene: PlayersScene)
}


// MARK: - Definition

class PlayersScene: Scene {
    
    // MARK: - Children nodes
    
    fileprivate lazy var playerNodes: [PlayerNameNode] = {
        if let nodes = self.scene?["//playerName"] as? [PlayerNameNode] {
            return nodes
        }
        
        return [PlayerNameNode]()
    }()
    
    fileprivate lazy var addPlayerButton: Button? = {
        return self.button(withName: "//button_addPlayer", andSetLabel: NSLocalizedString("playersScene.button.addPlayer", value: "Add Player", comment: "Label of the players scene button 'add player'."))
    }()
    
    fileprivate lazy var nextButton: Button? = {
        return self.button(withName: "//button_next", andSetLabel: NSLocalizedString("playersScene.button.next", value: "Next", comment: "Label of the players scene button 'next'."))
    }()
    
    
    // MARK: - Delegates
    
    weak var sceneDelegate: PlayersSceneDelegate?
    
    
    // MARK: - Life cycle
    
    override class func newScene() -> Scene {
        guard let scene = SKScene(fileNamed: "PlayersScene") as? PlayersScene else {
            print("Failed to load PlayersScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func setUp() {
        super.setUp()
        self.setTitle(title: NSLocalizedString("playersScene.title", value: "Players", comment: "Title of the players scene."))
        
        if let frame = self.addPlayerButton?.backgroundNode?.frame {
            let centerRect = CGRect(x: Button.margin/Button.size, y: Button.margin/Button.size, width: (Button.size - 2*Button.margin)/Button.size, height: (Button.size - 2*Button.margin)/Button.size)
            let nodeSize = frame.size
            
            for (_, playerNode) in self.playerNodes.enumerated() {
                playerNode.update(size: nodeSize, andCenter: centerRect)
            }
        }
    }
    
    override func enter(withCompletion completion: (() -> Void)?) {
        let (leftNodes, rightNodes) = self.getLeftAndRightPlayerNodes()
        
        var bottomNodes = [SKNode?]()
        if let button = self.nextButton, button.isEnabled {
            bottomNodes.append(self.nextButton?.referentNode)
        }
        
        self.moveNodes(fromTheTop: [self.titleNode],
                       fromTheBottom: bottomNodes,
                       fromTheLeft: leftNodes,
                       fromTheRight: rightNodes,
                       animated: true,
                       withCompletion: completion)
    }
    
    override func exit(withCompletion completion: (() -> Void)?) {
        let (leftNodes, rightNodes) = self.getLeftAndRightPlayerNodes()
        
        self.moveNodes(toTheTop: [self.titleNode],
                       toTheBottom: [self.nextButton?.referentNode],
                       toTheLeft: leftNodes,
                       toTheRight: rightNodes,
                       animated: true,
                       withCompletion: completion)
    }
    
    
    // MARK: - Displaying
    
    func setPlayers(_ players: [Player]) {
        for (index, node) in self.playerNodes.enumerated() {
            if index >= players.count {
                node.setDown()
                continue
            }
            
            node.setUp(withPlayer: players[index])
        }
    }
    
    func updateAddPlayerButtonPosition() {
        for (_, node) in self.playerNodes.enumerated() {
            if node.isDisabled, let position = node.positionInScene {
                self.addPlayerButton?.referentNode?.position = position
                break
            }
        }
    }
    
    func enableAddPlayerButton(_ enabled: Bool) {
        self.addPlayerButton?.isHidden = !enabled
    }
    
    func enableNextButton(_ enabled: Bool, animated: Bool) {
        guard let height = self.view?.frame.height, self.nextButton?.isEnabled != enabled else {
            return
        }
        
        self.nextButton?.isEnabled = enabled
        
        if enabled {
            self.nextButton?.referentNode?.moveInFromBottom(withViewHeight: height, animated: animated, forced: false)
        } else {
            self.nextButton?.referentNode?.moveOutToBottom(withViewHeight: height, animated: animated, forced: false)
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
        
        guard let sceneWidth = self.scene?.size.width, let anchorPoint = self.scene?.anchorPoint, let node = self.addPlayerButton?.referentNode else {
            return (leftNodes, rightNodes)
        }
        
        node.clearSavedMoveActions()
        
        let leftSpace = abs((sceneWidth * -anchorPoint.x) - node.position.x)
        let rightSpace = abs((sceneWidth * anchorPoint.x) - node.position.x)
        
        if leftSpace < rightSpace {
            leftNodes.append(node)
        } else {
            rightNodes.append(node)
        }
        
        return (leftNodes, rightNodes)
    }
    
    
    // MARK: - Events
    
    fileprivate func didSelectNextStep() {
        self.sceneDelegate?.nextStep(from: self)
    }
    
    fileprivate func didSelectAddPlayer() {
        self.sceneDelegate?.addPlayer(from: self)
    }
    
    fileprivate func didSelectRemovePlayer(with name: String) {
        self.sceneDelegate?.removePlayer(with: name, from: self)
    }
}


// MARK: - Touch-based event handling

extension PlayersScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = self.node(with: touches, and: event) else {
            return
        }
        
        if let nextButton = self.nextButton, nextButton.isTouched(node: touchedNode) {
            self.didSelectNextStep()
        }
        
        if let addPlayerButton = self.addPlayerButton, addPlayerButton.isTouched(node: touchedNode) {
            self.didSelectAddPlayer()
        }
        
        if touchedNode.name == "remove", let playerNode = touchedNode.parent as? PlayerNameNode, let playerName = playerNode.playerName {
            self.didSelectRemovePlayer(with: playerName)
            return
        }
    }
}
