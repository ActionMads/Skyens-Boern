//
//  SnappingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 20/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

// Snappingcomponent responsible for snapping an entity into target position or rotation
class SnappingComponent : GKComponent {
    var isSetup = false
    let positionTolerance : CGFloat = 250
    
    let rotationTolerance : CGFloat = 10
    
    var hasSnapped = false
    
    deinit {
        print(self, "has deinitialized")
    }
}
