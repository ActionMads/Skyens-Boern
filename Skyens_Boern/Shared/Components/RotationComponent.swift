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

// Rotaion Component responsible for rotating an entity
class RotationComponent : GKComponent {

    // Global varibles
    var currentRotation : CGFloat
    var targetRotation : CGFloat

    // Initalize the component with parameters
    init( currentRotation : CGFloat, targetRotation : CGFloat ) {
        self.currentRotation = currentRotation
        self.targetRotation = targetRotation
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implmented")
    }
    deinit {
        print(self, "has deinitialized")
    }
}
