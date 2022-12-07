//
//  CaveViewController.swift
//  Dromedary
//
//  Created by Mads Munk on 13/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class CaveViewController: UIViewController, UIGestureRecognizerDelegate {

    var scene: Cave!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScene()
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.

    }
    
    func setScene() {
        scene = Cave(size: CGSize(width: 2732, height: 2048))
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(scene)
                    
                    view.ignoresSiblingOrder = true
                    view.preferredFramesPerSecond = 25
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = true

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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
}
