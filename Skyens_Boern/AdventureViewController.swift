//
//  GameViewController.swift
//  Eventyr V2
//
//  Created by Mads Munk on 13/02/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class AdventureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setScene()


        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.

    }
    
    func setScene(){
        if let scene = GKScene(fileNamed: "Adventure") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! Adventure? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    view.preferredFramesPerSecond = 30
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = false
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
