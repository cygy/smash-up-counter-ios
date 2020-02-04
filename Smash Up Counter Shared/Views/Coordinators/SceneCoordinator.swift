//
//  SceneCoordinator.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import RxSwift


// MARK: - Definition

class Coordinator {}


// MARK: - Definition

class SceneCoordinator<T: Scene>: Coordinator {
    
    // MARK: - Properties
    
    let view: SKView
    let viewController: UIViewController
    let scene: T
    let disposeBag: DisposeBag
    
    
    // MARK: - Life cycle
    
    init(view: SKView, viewController: UIViewController) {
        self.view = view
        self.viewController = viewController
        self.scene = T.newScene() as! T
        self.disposeBag = DisposeBag()
    }
    
    func start() {
    }
}
