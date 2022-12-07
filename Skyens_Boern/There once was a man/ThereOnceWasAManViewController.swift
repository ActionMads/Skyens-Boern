//
//  GameViewController.swift
//  Dromedary
//
//  Created by Mads Munk on 21/01/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ThereOnceWasAManViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setScene()


        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        
    }
    
    func setScene() {
        if let scene = GKScene(fileNamed: "ThereOnceWasAMan") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! ThereOnceWasAMan?{
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                            


                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.preferredFramesPerSecond = 30
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
