//
//  SwimmingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 28/07/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SwimmingComponent: GKComponent {
    let movePointsPerSec : CGFloat = 480.0
    var velocity = CGPoint.zero
    var direction : String!
    let positionTolerence : CGFloat = 20
    var hasReachedTarget : Bool = false
    
    init(direction : String) {
        self.direction = direction
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
