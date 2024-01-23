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

// Extension to the scene class responsible for handling the touch functionallity
extension Scene {
    
    // Setup the interaction handlers and add them to the view
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
    
    // Handle the longpress touch
    @objc func handleLongPress(_ recognizer : UILongPressGestureRecognizer ) {
        print("tap")
        let point = self.scene?.convertPoint(fromView: recognizer.location(in: self.view)) ?? .zero
        
            print("touched point", point)
        
        
        let node = self.topNode(at: point)
        print("Node name: ", node?.name as Any)
        
        // handle the different states
        switch recognizer.state {
        // When touch began
        case .began:
            print("recognizer state: ", recognizer.state)
            if node?.name == "yes" || node?.name == "no" {
                self.setTextureButton(button: node as! SKSpriteNode)

            }
        // When touch ended
        case .ended:
            
            // Game btns
            if gameIsRunning {
                if node?.name == "man" {
                    if canJump {
                        node?.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 2500))
                        jump(sprite: node as! SKSpriteNode)
                    }
                }
                if node?.name == "activeDromedary" {
                    if canJump {
                        dromedary.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 2500))
                        jump(sprite: dromedary)
                    }
                }
                if node?.name == "hero"{
                    shot()
                }
                if node?.name == "Piano" || node?.name == "Flower" {
                    node?.entity?.component(ofType: ProgressingComponent.self)?.isActive = true
                }
                if node?.name == "hearthBtn" {
                    node?.entity?.component(ofType: PumpingComponent.self)?.isActive = true
                    
                }
                // Adventure move the plane and the spaceship
                moveShipTowards(location: point)
            }
            print("ended")
            
            // Info btn
            if node?.name == "startBtn" {
                self.startGame()
                node?.removeFromParent()
            }
            if node?.name == "backBtn" {
                self.backToHome()
            }
            if node?.name == "helpBtn" {
                self.helpBtnAction()
            }
            if node?.name == "yes" {
               self.restart()
            }
            if node?.name == "no" {
                self.backToHome()
            }
            
            // Game btns

            
            // Menu btns presenting a new scene
            if node?.name == btnImageNames.btn1.rawValue {
                print(btnImageNames.btn1.rawValue, " Was pressed")
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst = false
                viewController.selectScene(selectedScene: Cave(size: self.viewController.sceneSize))
            }
            if node?.name == btnImageNames.btn2.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst = false
                self.viewController.selectGKScene(sceneName: "Adventure")
            }
            if node?.name == btnImageNames.btn3.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst = false
                self.viewController.selectScene(selectedScene: Melody(size: self.viewController.sceneSize))
            }
            if node?.name == btnImageNames.btn4.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst = false
                self.viewController.selectGKScene(sceneName: "ThereOnceWasAMan")
            }
            if node?.name == btnImageNames.btn5.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst = false
                self.viewController.selectScene(selectedScene: FavouriteAnimal(size: self.viewController.sceneSize))
            }
            if node?.name == btnImageNames.btn6.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst = false
                self.viewController.selectScene(selectedScene: GoodnightSong(size: self.viewController.sceneSize))
            }
            if node?.name == btnImageNames.btn7.rawValue {
                self.musicPlayer.fadeOut()
                self.viewController.previusScene = self
                self.viewController.isFirst = false
                self.viewController.selectScene(selectedScene: MusicScene(size: self.viewController.sceneSize))
            }
            
            // MusicBtns
            if node?.name == "play" || node?.name == "pause" || node?.name == "resumePlay"{
                node?.name = self.playPauseMusic(node: node as! SKSpriteNode, parentName: node?.parent?.name ?? "")
            }
            if node?.name == "stop" {
                self.stopMusic(parentName: node?.parent?.name ?? "")
            }
        default:
            break
        }
    }
    // Handle panning
    @objc func handlePan(_ recogniser : UIPanGestureRecognizer ) {
        // Get the touched point
        let point = self.scene?.convertPoint(fromView: recogniser.location(in: self.view)) ?? .zero
        // Set the entity being interacted with
        if recogniser.state == .began {
            self.entityBeingInteractedWith = self.topNode(at: point)?.entity
        }
        // if an entity is being interacted with
        guard let hasEntity = self.entityBeingInteractedWith else { return }
        // Only handle panning if touc is 1
        guard recogniser.numberOfTouches <= 1 else {
            self.entityBeingInteractedWith = nil
            hasEntity.component(ofType: InteractionComponent.self)?.state = .none
            return
        }
        
        // handle the different states
        switch recogniser.state {
        case .began:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.began, point)
            self.itemHasBeenTouched = true
        case .changed:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.changed, point)
        case .ended, .cancelled, .failed:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.ended, point)
            self.entityBeingInteractedWith = nil
        default:
            break
        }

    }
    
    // Handle the rotation
    @objc func handleRotation(_ recogniser : UIRotationGestureRecognizer) {
        // Get the point touched
        let point = self.scene?.convertPoint(fromView: recogniser.location(in: self.view)) ?? .zero
        // Set the entity being interacted with
        if recogniser.state == .began {
            self.entityBeingInteractedWith = self.topNode(at: point)?.entity
        }

        // Create a let if an entity is being incteracted with
        guard let hasEntity = self.entityBeingInteractedWith else { return }

        // Reverse rotation direction so that it follows the gesture
        let rotation = recogniser.rotation * -1

        // Handle the different states
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



