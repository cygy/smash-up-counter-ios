//
//  FactionsDistributionScene.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Protocol (FactionsDistributionSceneDelegate)

protocol FactionsDistributionSceneDelegate: class {
    func nextStep(from scene: FactionsDistributionScene)
}


// MARK: - Definition

class FactionsDistributionScene: Scene {
    
    // MARK: - Children nodes
    
    fileprivate lazy var playerNameLabel: SKLabelNode? = {
        return self.childNode(withName: "//player_name") as? SKLabelNode
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
    
    fileprivate lazy var nextPlayerButton: Button? = {
        return self.button(withName: "//button_next_player", andSetLabel: NSLocalizedString("factionsDistributionScene.button.nextPlayer", value: "Next Player", comment: "Label of the factions distribution scene button 'next player'."))
    }()
    
    fileprivate lazy var nextButton: Button? = {
        return self.button(withName: "//button_next", andSetLabel: NSLocalizedString("factionsDistributionScene.button.start", value: "Start", comment: "Label of the factions distribution scene button 'start'."))
    }()
    
    
    // MARK: - Delegates
    
    weak var sceneDelegate: FactionsDistributionSceneDelegate?
    
    
    // MARK: - Properties
    
    fileprivate var players: [Player]?
    fileprivate var currentPlayerIndex: Int = 0
    
    
    // MARK: - Life cycle
    
    override class func newScene() -> Scene {
        guard let scene = SKScene(fileNamed: "FactionsDistributionScene") as? FactionsDistributionScene else {
            print("Failed to load FactionsDistributionScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func enter(withCompletion completion: (() -> Void)?) {
        self.moveNodes(toTheTop: [self.playerNameLabel],
                       toTheBottom: [self.nextButton?.referentNode, self.nextPlayerButton?.referentNode],
                       toTheLeft: [self.firstFactionNode?.parent],
                       toTheRight: [self.secondFactionNode?.parent],
                       animated: false)
        
        self.setUpCurrentPlayer(animated: true) {
            completion?()
        }
    }
    
    override func exit(withCompletion completion: (() -> Void)?) {
        self.moveNodes(toTheTop: [self.playerNameLabel],
                       toTheBottom: [self.nextButton?.referentNode],
                       toTheLeft: [self.firstFactionNode?.parent],
                       toTheRight: [self.secondFactionNode?.parent],
                       animated: true,
                       withCompletion: completion)
    }
    
    
    // MARK: - Displaying
    
    func setPlayers(_ players: [Player]) {
        self.players = players
    }
    
    fileprivate func enableNextPlayerButton(_ enabled: Bool, animated: Bool, andCompletion completion: (() -> Void)? = nil) {
        guard let height = self.view?.frame.height, self.nextPlayerButton?.isEnabled != enabled else {
            return
        }
        
        self.nextPlayerButton?.isEnabled = enabled
        
        if enabled {
            self.nextPlayerButton?.referentNode?.moveInFromBottom(withViewHeight: height, animated: animated, forced: false) {
                completion?()
            }
        } else {
            self.nextPlayerButton?.referentNode?.moveOutToBottom(withViewHeight: height, animated: animated, forced: false) {
                completion?()
            }
        }
    }
    
    fileprivate func enableNextButton(_ enabled: Bool, animated: Bool, andCompletion completion: (() -> Void)? = nil) {
        guard let height = self.view?.frame.height, self.nextButton?.isEnabled != enabled else {
            return
        }
        
        self.nextButton?.isEnabled = enabled
        
        if enabled {
            self.nextButton?.referentNode?.moveInFromBottom(withViewHeight: height, animated: animated, forced: false) {
                completion?()
            }
        } else {
            self.nextButton?.referentNode?.moveOutToBottom(withViewHeight: height, animated: animated, forced: false) {
                completion?()
            }
        }
    }
    
    fileprivate func setUpCurrentPlayer(animated: Bool, withCompletion completion: (() -> Void)? = nil) {
        guard let players = self.players, self.currentPlayerIndex >= 0 && self.currentPlayerIndex < players.count else {
            return
        }
        
        let player = players[currentPlayerIndex]
        let firstFaction = player.factions[0]
        let secondFaction = player.factions[1]
        
        let setUpViews = {
            self.playerNameLabel?.text = player.name
            self.playerNameLabel?.applyTitleStyle()
            
            self.firstFactionNode?.setUp(withFaction: firstFaction)
            self.secondFactionNode?.setUp(withFaction: secondFaction)
        }
        
        let showButton = {
            if self.currentPlayerIndex == players.count-1 {
                self.enableNextButton(true, animated: animated)
            } else {
                self.enableNextPlayerButton(true, animated: animated)
            }
        }
        
        self.firstFactionNode?.parent?.removeAction(forKey: "stale")
        self.secondFactionNode?.parent?.removeAction(forKey: "stale")
        
        self.enableNextButton(false, animated: false)
        self.enableNextPlayerButton(false, animated: animated) {
            if animated {
                let action = SKAction.slowlyMoveAction(amplitudeX: 10, amplitudeY: 10)
                
                self.moveNodes(toTheTop: [self.playerNameLabel],
                               toTheBottom: nil,
                               toTheLeft: [self.firstFactionNode?.parent],
                               toTheRight: [self.secondFactionNode?.parent],
                               animated: (animated && self.currentPlayerIndex > 0),
                               withCompletion: {
                                setUpViews()
                                
                                self.firstFactionNode?.hideFaction()
                                self.secondFactionNode?.hideFaction()
                                
                                self.moveNodes(fromTheTop: [self.playerNameLabel],
                                               fromTheBottom: nil,
                                               fromTheLeft: [self.firstFactionNode?.parent],
                                               fromTheRight: [self.secondFactionNode?.parent],
                                               animated: animated,
                                               withCompletion: {
                                                self.firstFactionNode?.runDiscoverAction(withCompletion: {
                                                    self.firstFactionNode?.parent?.run(action, withKey: "stale")
                                                    self.secondFactionNode?.runDiscoverAction(withCompletion: {
                                                        self.secondFactionNode?.parent?.run(action, withKey: "stale")
                                                        showButton()
                                                    })
                                                })
                                })
                })
            } else {
                setUpViews()
                showButton()
            }
        }
    }
    
    
    // MARK: - Events
    
    fileprivate func didSelectNextPlayer() {
        self.currentPlayerIndex += 1
        self.setUpCurrentPlayer(animated: true)
    }
    
    fileprivate func didSelectNextStep() {
        self.sceneDelegate?.nextStep(from: self)
    }
}


// MARK: - Touch-based event handling

extension FactionsDistributionScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = self.node(with: touches, and: event) else {
            return
        }
        
        if let nextPlayerButton = self.nextPlayerButton, nextPlayerButton.isTouched(node: touchedNode) {
            self.didSelectNextPlayer()
        }
        
        if let nextButton = self.nextButton, nextButton.isTouched(node: touchedNode) {
            self.didSelectNextStep()
        }
    }
}
