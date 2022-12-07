//
//  GoognightSongViewController.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 14/01/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

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

class GoodnightSongViewController: UIViewController {
    
    var scene: GoodnightSong!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScene()
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.

    }
    
    func setScene() {
        scene = GoodnightSong(size: CGSize(width: 2732, height: 2048))
                
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

