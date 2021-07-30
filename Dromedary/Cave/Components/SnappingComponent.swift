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
class SnappingComponent : GKComponent {
    var isSetup = false
    let positionTolerance : CGFloat = 100
    
    let rotationTolerance : CGFloat = 20
    
    var hasSnapped = false

}
