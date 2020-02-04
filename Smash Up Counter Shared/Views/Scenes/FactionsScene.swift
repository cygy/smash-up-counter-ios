//
//  FactionsScene.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit


// MARK: - Protocol (FactionsSceneDelegate)

protocol FactionsSceneDelegate: class {
    func nextStep(from scene: FactionsScene)
    func previousStep(from scene: FactionsScene)
    func selectFaction(at index: Int, from scene: FactionsScene)
    func unselectFaction(at index: Int, from scene: FactionsScene)
    func selectAddOn(at index: Int, from scene: FactionsScene)
    func unselectAddOn(at index: Int, from scene: FactionsScene)
}


// MARK: - Protocol (FactionsSceneSourceDelegate)

protocol FactionsSceneSourceDelegate: class {
    func addOn(at index: Int) -> AddOn?
    func numberOfAddOns() -> Int
    func addOnIsSelected(at index: Int)
    
    func faction(at index: Int) -> Faction?
    func numberOfFactions() -> Int
}


// MARK: - Definition

class FactionsScene: Scene {
    
    // MARK: - Children nodes
    
    fileprivate lazy var addOnNodes: [AddOnNode] = {
        if let nodes = self.scene?["//addOn"] as? [AddOnNode] {
            return nodes
        }
        
        return [AddOnNode]()
    }()
    
    fileprivate lazy var factionNodes: [FactionNode] = {
        if let nodes = self.scene?["//faction"] as? [FactionNode] {
            return nodes
        }
        
        return [FactionNode]()
    }()
    
    fileprivate var currentAddOnNode: AddOnNode?
    
    fileprivate lazy var previousAddOnsButton: SKNode? = {
        let button = self.childNode(withName: "//button_addons_previous")
        button?.applyButtonStyle()
        return button
    }()
    
    fileprivate lazy var nextAddOnsButton: SKNode? = {
        let button = self.childNode(withName: "//button_addons_next")
        button?.applyButtonStyle()
        return button
    }()
    
    fileprivate lazy var previousFactionsButton: SKNode? = {
        let button = self.childNode(withName: "//button_factions_previous")
        button?.applyButtonStyle()
        return button
    }()
    
    fileprivate lazy var nextFactionsButton: SKNode? = {
        let button = self.childNode(withName: "//button_factions_next")
        button?.applyButtonStyle()
        return button
    }()
    
    fileprivate lazy var previousButton: Button? = {
        return self.button(withName: "//button_previous", andSetLabel: NSLocalizedString("factionsScene.button.back", value: "Back", comment: "Label of the factions scene button 'back'."))
    }()
    
    fileprivate lazy var nextButton: Button? = {
        return self.button(withName: "//button_next", andSetLabel: NSLocalizedString("factionsScene.button.next", value: "Next", comment: "Label of the factions scene button 'next'."))
    }()
    
    
    // MARK: - Delegates
    
    weak var sceneDelegate: FactionsSceneDelegate?
    weak var sourceDelegate: FactionsSceneSourceDelegate?
    
    
    // MARK: - Properties
    
    fileprivate var numberOfAddOns = 0
    fileprivate var numberOfVisibleAddOns = 0
    fileprivate var firstVisibleAddOnIndex = 0
    fileprivate var lastVisibleAddOnIndex: Int {
        return firstVisibleAddOnIndex + numberOfVisibleAddOns - 1
    }
    fileprivate var minimumAddOnIndex: Int {
        return numberOfVisibleAddOns/2 * -1
    }
    fileprivate var maximumAddOnIndex: Int {
        return numberOfAddOns + numberOfVisibleAddOns/2
    }
    
    fileprivate var numberOfFactions = 0
    fileprivate var numberOfVisibleFactions = 0
    fileprivate var firstVisibleFactionIndex = 0
    fileprivate var lastVisibleFactionIndex: Int {
        return firstVisibleFactionIndex + numberOfVisibleFactions - 1
    }
    fileprivate var minimumFactionIndex = 0
    fileprivate var maximumFactionIndex: Int {
        return numberOfFactions - 1
    }
    
    
    // MARK: - Life cycle
    
    override class func newScene() -> Scene {
        guard let scene = SKScene(fileNamed: "FactionsScene") as? FactionsScene else {
            print("Failed to load FactionsScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func setUp() {
        super.setUp()
        self.setTitle(title: NSLocalizedString("factionsScene.title", value: "Factions", comment: "Title of the factions scene."))
        
        self.currentAddOnNode = self.addOnNodes[2] // TODO: temporary
        
        // Set up addOns & factions
        self.numberOfVisibleAddOns = self.addOnNodes.count
        self.numberOfVisibleFactions = self.factionNodes.count
        
        if let numberOfAddOns = self.sourceDelegate?.numberOfAddOns() {
            self.numberOfAddOns = numberOfAddOns
        }
        
        self.setUpAddOnNodes()
    }
    
    override func enter(withCompletion completion: (() -> Void)?) {
        self.moveNodes(fromTheTop: [self.titleNode, self.childNode(withName: "//addOns")],
                       fromTheBottom: [self.previousButton?.referentNode, self.nextButton?.referentNode, self.childNode(withName: "//factions")],
                       fromTheLeft: [self.previousAddOnsButton, self.previousFactionsButton],
                       fromTheRight: [self.nextAddOnsButton, self.nextFactionsButton],
                       animated: true,
                       withCompletion: completion)
    }
    
    override func exit(withCompletion completion: (() -> Void)?) {
        self.moveNodes(toTheTop: [self.titleNode, self.childNode(withName: "//addOns")],
                       toTheBottom: [self.previousButton?.referentNode, self.nextButton?.referentNode, self.childNode(withName: "//factions")],
                       toTheLeft: [self.previousAddOnsButton, self.previousFactionsButton],
                       toTheRight: [self.nextAddOnsButton, self.nextFactionsButton],
                       animated: true,
                       withCompletion: completion)
    }
    
    
    // MARK: - Displaying
    
    func updateSelectedState(forAddOn addOn: AddOn, animated: Bool) {
        for (_, node) in self.addOnNodes.enumerated() {
            if let nodeId = node.id, nodeId == addOn.id {
                node.updateSelectedState(addOn.isSelected, animated: animated)
                break
            }
        }
    }
    
    func updateSelectedState(forFaction faction: Faction, animated: Bool) {
        for (_, node) in self.factionNodes.enumerated() {
            if let nodeId = node.id, nodeId == faction.id {
                node.updateSelectedState(faction.isSelected, animated: animated)
                break
            }
        }
    }
    
    
    // MARK: - Private methods
    
    fileprivate func setUpAddOnNodes() {
        for index in self.firstVisibleAddOnIndex...self.lastVisibleAddOnIndex {
            let addOnNode = self.addOnNodes[index - self.firstVisibleAddOnIndex]
            
            if let addOn = self.sourceDelegate?.addOn(at: index) {
                addOnNode.setUp(withAddOn: addOn, andIndex: index)
                
                if addOnNode == self.currentAddOnNode {
                    addOnNode.showName()
                } else {
                    addOnNode.hideName()
                }
            } else {
                addOnNode.setDown()
            }
        }
        
        self.firstVisibleFactionIndex = 0
        
        if let index = self.currentAddOnNode?.index {
            self.sourceDelegate?.addOnIsSelected(at: index)
            
            if let numberOfFactions = self.sourceDelegate?.numberOfFactions() {
                self.numberOfFactions = numberOfFactions
            }
            
            self.setUpFactionNodes()
        }
        
        self.previousAddOnsButton?.isHidden = (self.firstVisibleAddOnIndex <= self.minimumAddOnIndex)
        self.nextAddOnsButton?.isHidden = (self.lastVisibleAddOnIndex >= self.maximumAddOnIndex-1)
    }
    
    fileprivate func setUpFactionNodes() {
        for index in self.firstVisibleFactionIndex...self.lastVisibleFactionIndex {
            let factionNode = self.factionNodes[index - self.firstVisibleFactionIndex]
            
            if let faction = self.sourceDelegate?.faction(at: index) {
                factionNode.setUp(withFaction: faction, andIndex: index)
            } else {
                factionNode.setDown()
            }
        }
        
        self.previousFactionsButton?.isHidden = (self.firstVisibleFactionIndex <= self.minimumFactionIndex)
        self.nextFactionsButton?.isHidden = (self.lastVisibleFactionIndex >= self.maximumFactionIndex)
    }
    
    
    // MARK: - Events
    
    fileprivate func didSelectNextStep() {
        self.sceneDelegate?.nextStep(from: self)
    }
    
    fileprivate func didSelectPreviousStep() {
        self.sceneDelegate?.previousStep(from: self)
    }
    
    fileprivate func didSelectFaction(at index: Int) {
        self.sceneDelegate?.selectFaction(at: index, from: self)
    }
    
    fileprivate func didUnselectFaction(at index: Int) {
        self.sceneDelegate?.unselectFaction(at: index, from: self)
    }
    
    fileprivate func didSelectAddOn(at index: Int) {
        self.sceneDelegate?.selectAddOn(at: index, from: self)
    }
    
    fileprivate func didUnselectAddOn(at index: Int) {
        self.sceneDelegate?.unselectAddOn(at: index, from: self)
    }
    
    fileprivate func didSelectPreviousAddOns() {
        guard self.firstVisibleAddOnIndex > self.minimumAddOnIndex else {
            return
        }
        
        self.firstVisibleAddOnIndex -= 1
        self.setUpAddOnNodes()
    }
    
    fileprivate func didSelectNextAddOns() {
        guard self.lastVisibleAddOnIndex < self.maximumAddOnIndex-1 else {
            return
        }
        
        self.firstVisibleAddOnIndex += 1
        self.setUpAddOnNodes()
    }
    
    fileprivate func didSelectPreviousFactions() {
        guard self.firstVisibleFactionIndex > self.minimumFactionIndex else {
            return
        }
        
        self.firstVisibleFactionIndex -= 1
        self.setUpFactionNodes()
    }
    
    fileprivate func didSelectNextFactions() {
        guard self.lastVisibleFactionIndex < self.maximumFactionIndex else {
            return
        }
        
        self.firstVisibleFactionIndex += 1
        self.setUpFactionNodes()
    }
}

// MARK: - Touch-based event handling

extension FactionsScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = self.node(with: touches, and: event) else {
            return
        }
        
        if let previousButton = self.previousButton, previousButton.isTouched(node: touchedNode) {
            self.didSelectPreviousStep()
        }
        
        if let nextButton = self.nextButton, nextButton.isTouched(node: touchedNode) {
            self.didSelectNextStep()
        }
        
        if touchedNode == self.previousAddOnsButton {
            self.didSelectPreviousAddOns()
            return
        }
        
        if touchedNode == self.nextAddOnsButton {
            self.didSelectNextAddOns()
            return
        }
        
        if touchedNode == self.previousFactionsButton {
            self.didSelectPreviousFactions()
            return
        }
        
        if touchedNode == self.nextFactionsButton {
            self.didSelectNextFactions()
            return
        }
        
        var found = false
        var searchedNode: SKNode? = touchedNode
        while !found {
            if searchedNode == nil {
                found = true
            }
            else if let _ = searchedNode as? AddOnNode {
                found = true
            }
            else if let _ = searchedNode as? FactionNode {
                found = true
            }
            else {
                searchedNode = searchedNode?.parent
            }
        }
        
        if let node = searchedNode as? AddOnNode, let index = node.index {
            if node.isSelected {
                self.didUnselectAddOn(at: index)
            } else {
                self.didSelectAddOn(at: index)
            }
            return
        }
        
        if let node = searchedNode as? FactionNode, let index = node.index {
            if node.isSelected {
                self.didUnselectFaction(at: index)
            } else {
                self.didSelectFaction(at: index)
            }
            return
        }
    }
}
