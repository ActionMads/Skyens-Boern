//
//  RotationComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 26/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
class RotationComponent : GKComponent {

    // 1.
    var currentRotation : CGFloat
    var targetRotation : CGFloat

    // 2.
    init( currentRotation : CGFloat, targetRotation : CGFloat ) {
        self.currentRotation = currentRotation
        self.targetRotation = targetRotation
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implmented")
    }
}
