//
//  WaterComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 24/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class WaterComponent: GKComponent {
    let waterTolerenceMax : CGFloat = 1.6
    let waterTolerenceMin : CGFloat = 0
    var dropTime : TimeInterval = 5
    var timeSinceLastDrop : TimeInterval = 0
    var scene : Melody
    
    init(scene : Melody) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
