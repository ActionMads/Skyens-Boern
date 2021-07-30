//
//  PositionComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 18/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class PositionComponent : GKComponent {
    
    var currentPosition : CGPoint
    var targetPosition : CGPoint

    init( currentPosition : CGPoint, targetPosition : CGPoint ) {
        self.currentPosition = currentPosition
        self.targetPosition = targetPosition
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implmented")
    }
}
