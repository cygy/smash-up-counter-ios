//
//  SceneController.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 06/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

import SpriteKit
import RxSwift

/*
 The class SceneController defines the common properties for the scenes of the application.
 Each SceneController object manages a Scene object.
 
 A controller object knows the SKView object in which the SKScene are drawn, and its viewController.
 */

// MARK: - Definition

class Controller {}


// MARK: - Definition

class SceneController<T: Scene>: Controller {
    
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
