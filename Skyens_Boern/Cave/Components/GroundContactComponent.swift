//
//  GroundContactComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 26/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GroundContactComponent: GKComponent {
    let groundHeight: CGFloat = 400
    let rightWall: CGFloat = 2732
    let leftWall: CGFloat = 0
    let topWall: CGFloat = 2048
    var isRotating: Bool = false
    var hasRotated: Bool = false
    
    deinit {
        print(self, "has deinitialized")
    }
}
