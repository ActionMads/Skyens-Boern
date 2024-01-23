//
//  GravityComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 22/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// Gravity component responsible for the down force of an entity
class GravityComponent: GKComponent {
    var downForce : CGFloat = 2.5
    
    deinit {
        print(self, "has deinitialized")
    }
    }
