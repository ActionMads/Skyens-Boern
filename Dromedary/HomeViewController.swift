//
//  HomeViewController.swift
//  Dromedary
//
//  Created by Mads Munk on 21/02/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class HomeViewController: UIViewController {
    
    var player: MusicPlayer!
    @IBOutlet weak var DerVarEngangButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        player = MusicPlayer()
        player.playMusic(url: "01 Stille morgen")
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.stopMusic()
    }
    
    override var shouldAutorotate: Bool {
            return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
