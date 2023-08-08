//
//  FlyComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 11/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FlyComponent : GKComponent {
    var hasReachedTarget = false
    let movePointsPerSec : CGFloat = 480.0
    var velocity = CGPoint.zero
    let positionTolerence : CGFloat = 20
    var direction : String = "Left"
    var isFirstRun : Bool = true
    var flyArea = CGRect(x: 100, y: 1000, width: 2600, height: 1000)
    let scene : Melody
    var canFly : Bool = true
    
    init(scene : Melody) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
