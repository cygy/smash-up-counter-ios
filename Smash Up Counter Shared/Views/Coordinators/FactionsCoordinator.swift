//
//  FactionsCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import RxSwift


// MARK: - Protocol (FactionsCoordinatorDelegate)

protocol FactionsCoordinatorDelegate: class {
    func nextStep(from coordinator: FactionsCoordinator)
    func previousStep(from coordinator: FactionsCoordinator)
}


// MARK: - Definition

class FactionsCoordinator: SceneCoordinator<FactionsScene> {
    
    // MARK: - Properties
    
    weak var delegate: FactionsCoordinatorDelegate?
    
    fileprivate var selectedAddOnIndex: Int?
    
    
    // MARK: - Life cycle
    
    override func start() {
        self.scene.sceneDelegate = self
        self.scene.sourceDelegate = self
        
        self.scene.enterCompletion = { [unowned self] in
            for (index, _) in ApplicationState.instance.addOns.value.enumerated() {
                ApplicationState.instance.addOns.asObservable().map { $0[index] }.distinctUntilChanged{ $0.isSelected == $1.isSelected }.subscribe { [weak self] addOn in
                    guard let addOn = addOn.element else {
                        return
                    }
                    
                    self?.scene.updateSelectedState(forAddOn: addOn, animated: true)
                }.disposed(by: self.disposeBag)
            }
        }
        
        self.view.presentScene(self.scene)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func selectFaction(at index: Int, selected: Bool) {
        let addOns = ApplicationState.instance.addOns.value
        guard let addOnIndex = self.selectedAddOnIndex, addOnIndex >= 0 && addOnIndex < addOns.count else {
            return
        }
        
        let addOn = addOns[addOnIndex]
        let faction = addOn.factions[index]
        
        if selected {
            ApplicationState.instance.select(faction: faction.id, fromAddOn: addOn.id)
        } else {
            ApplicationState.instance.unselect(faction: faction.id, fromAddOn: addOn.id)
        }
    }
    
    fileprivate func selectAddOn(at index: Int, selected: Bool) {
        let addOns = ApplicationState.instance.addOns.value
        guard index >= 0 && index < addOns.count else {
            return
        }
        
        let addOn = addOns[index]
        
        if selected {
            ApplicationState.instance.select(addOn: addOn.id)
        } else {
            ApplicationState.instance.unselect(addOn: addOn.id)
        }
    }
}


// MARK: - Extension (FactionsSceneDelegate)

extension FactionsCoordinator: FactionsSceneDelegate {
    func nextStep(from scene: FactionsScene) {
        scene.exit { [unowned self] in
            self.delegate?.nextStep(from: self)
        }
    }
    
    func previousStep(from scene: FactionsScene) {
        scene.exit { [unowned self] in
            self.delegate?.previousStep(from: self)
        }
    }
    
    func selectFaction(at index: Int, from scene: FactionsScene) {
        self.selectFaction(at: index, selected: true)
    }
    
    func unselectFaction(at index: Int, from scene: FactionsScene) {
        self.selectFaction(at: index, selected: false)
    }
    
    func selectAddOn(at index: Int, from scene: FactionsScene) {
        self.selectAddOn(at: index, selected: true)
    }
    
    func unselectAddOn(at index: Int, from scene: FactionsScene) {
        self.selectAddOn(at: index, selected: false)
    }
}


// MARK: - Extension (FactionsSceneSourceDelegate)

extension FactionsCoordinator: FactionsSceneSourceDelegate {
    func addOn(at index: Int) -> AddOn? {
        let addOns = ApplicationState.instance.addOns.value
        guard index >= 0 && index < addOns.count else {
            return nil
        }
        
        return addOns[index]
    }
    
    func numberOfAddOns() -> Int {
        return ApplicationState.instance.addOns.value.count
    }
    
    func addOnIsSelected(at index: Int) {
        self.selectedAddOnIndex = index
        
        for (factionIndex, _) in ApplicationState.instance.addOns.value[index].factions.enumerated() {
            ApplicationState.instance.addOns.asObservable().map { $0[index].factions[factionIndex] }.distinctUntilChanged{ $0.isSelected == $1.isSelected }.subscribe { [weak self] faction in
                guard let faction = faction.element else {
                    return
                }
                self?.scene.updateSelectedState(forFaction: faction, animated: true)
            }.disposed(by: self.disposeBag)
        }
    }
    
    func faction(at index: Int) -> Faction? {
        let addOns = ApplicationState.instance.addOns.value
        guard let addOnIndex = self.selectedAddOnIndex, addOnIndex >= 0 && addOnIndex < addOns.count else {
            return nil
        }
        
        let factions = ApplicationState.instance.addOns.value[addOnIndex].factions
        guard index >= 0 && index < factions.count else {
            return nil
        }
        
        return factions[index]
    }
    
    func numberOfFactions() -> Int {
        guard let addOnIndex = self.selectedAddOnIndex else {
            return 0
        }
        
        return ApplicationState.instance.addOns.value[addOnIndex].factions.count
    }
}


