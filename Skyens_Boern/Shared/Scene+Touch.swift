//
//  Scene+Touch.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 24/08/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

//
//  Melody+Touch.swift
//  Dromedary
//
//  Created by Mads Munk on 12/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

extension Scene {
    func setupInteractionHandlers() {
        print("setting up")
        panRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        // 2.
        panRecogniser.maximumNumberOfTouches = 1
        self.view?.addGestureRecognizer(panRecogniser)
        rotationRecogniser = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        self.view?.addGestureRecognizer(rotationRecogniser)
        clickRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        clickRecognizer.minimumPressDuration = 0.01
        clickRecognizer.numberOfTouchesRequired = 1
        clickRecognizer.numberOfTapsRequired = 0
        clickRecognizer.allowableMovement = 100

        self.view?.addGestureRecognizer(clickRecognizer)
        
        print("all good to go")

    }
    
    @objc func handleLongPress(_ recognizer : UILongPressGestureRecognizer ) {
        print("tap")
        let point = self.scene?.convertPoint(fromView: recognizer.location(in: self.view)) ?? .zero
        
            print("touched point", point)
        
        
        let node = self.topNode(at: point)
        print("Node name: ", node?.name)
        switch recognizer.state {
        case .began:
            print(recognizer.state)
            if node?.name == "yes" || node?.name == "no" {
                self.setTextureButton(button: node as! SKSpriteNode)

            }
        case .ended:
            print("ended")
            if node?.name == "startBtn" {
                self.startGame()
                node?.removeFromParent()
            }
            if node?.name == "backBtn" {
                self.backToHome()
            }
            if node?.name == "yes" {
               self.restart()
            }
            if node?.name == "no" {
                self.backToHome()
            }
            if node?.name == "Piano" || node?.name == "Flower" {
                print("What name: ", node?.name)
                node?.entity?.component(ofType: ProgressingComponent.self)?.isActive = true
            }
            if node?.name == "hearthBtn" {
                node?.entity?.component(ofType: PumpingComponent.self)?.isActive = true
            }
            if node?.name == btnImageNames.btn1.rawValue {
                print(btnImageNames.btn1.rawValue, " Was pressed")
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst == false
                viewController.selectScene(selectedScene: Cave(size: self.viewController.sceneSize))
            }
            if node?.name == btnImageNames.btn2.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst == false
                self.viewController.selectGKScene(sceneName: "Adventure")
            }
            if node?.name == btnImageNames.btn3.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst == false
                self.viewController.selectScene(selectedScene: Melody(size: self.viewController.sceneSize))
            }
            if node?.name == btnImageNames.btn4.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst == false
                self.viewController.selectGKScene(sceneName: "ThereOnceWasAMan")
            }
            if node?.name == btnImageNames.btn5.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst == false
                self.viewController.selectScene(selectedScene: FavouriteAnimal(size: self.viewController.sceneSize))
            }
            if node?.name == btnImageNames.btn6.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst == false
                self.viewController.selectScene(selectedScene: GoodnightSong(size: self.viewController.sceneSize))
            }
        default:
            break
        }
    }
    // 3.
    @objc func handlePan(_ recogniser : UIPanGestureRecognizer ) {
        // 1.
        let point = self.scene?.convertPoint(fromView: recogniser.location(in: self.view)) ?? .zero
        // 2.
        if recogniser.state == .began {
            self.entityBeingInteractedWith = self.topNode(at: point)?.entity
        }
        // 3.
        guard let hasEntity = self.entityBeingInteractedWith else { return }
        // 4.
        guard recogniser.numberOfTouches <= 1 else {
            self.entityBeingInteractedWith = nil
            hasEntity.component(ofType: InteractionComponent.self)?.state = .none
            return
        }
        switch recogniser.state {
        case .began:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.began, point)
        case .changed:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.changed, point)
        case .ended, .cancelled, .failed:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.ended, point)
            self.entityBeingInteractedWith = nil
        default:
            break
        }

    }
     
    @objc func handleRotation(_ recogniser : UIRotationGestureRecognizer) {
        // 1.
        let point = self.scene?.convertPoint(fromView: recogniser.location(in: self.view)) ?? .zero
        if recogniser.state == .began {

            // 2.
            self.entityBeingInteractedWith = self.topNode(at: point)?.entity
        }

        // 3.
        guard let hasEntity = self.entityBeingInteractedWith else { return }

        // 4.
        let rotation = recogniser.rotation * -1

        // 5.
        switch recogniser.state {
        case .began:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .rotate(.began, rotation)
        case .changed:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .rotate(.changed, rotation)
        case .ended, .cancelled, .failed:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .rotate(.ended, rotation)
        default:
            break
        }
    }
}



