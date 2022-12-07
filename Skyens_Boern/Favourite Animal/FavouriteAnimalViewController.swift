//
//  FavouriteAnimalViewCOntroller.swift
//  Dromedary
//
//  Created by Mads Munk on 09/06/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class FavouriteAnimalViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var scene: FavouriteAnimal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScene()
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.

    }
    
    func setScene() {
        scene = FavouriteAnimal(size: CGSize(width: 2732, height: 2048))
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit

                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(scene)
                    
                    view.ignoresSiblingOrder = true
                    view.preferredFramesPerSecond = 25
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = false

        }
        scene.panRecogniser.delegate = self
        scene.clickRecognizer.delegate = self
        scene.rotationRecogniser.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if (gestureRecognizer == scene.panRecogniser || gestureRecognizer == scene.rotationRecogniser) && otherGestureRecognizer == scene.clickRecognizer {
            return true
        }
        return false
    }



    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
