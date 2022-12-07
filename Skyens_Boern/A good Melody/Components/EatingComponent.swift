//
//  EatingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 18/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class EatingComponent : GKComponent {
    let eatingTolerence : CGFloat = 50
    let scene : Melody!
    var isEating : Bool = false
    let tongueTex : SKTexture?
    let noTongueTex : SKTexture?
    var eatingCount : TimeInterval = 1
    
    init(scene : Melody) {
        self.scene = scene
        tongueTex = scene.frogAtlas.textureNamed("FrøMedTungeMørk")
        noTongueTex = scene.frogAtlas.textureNamed("FrøUdenTungeMørk")
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
