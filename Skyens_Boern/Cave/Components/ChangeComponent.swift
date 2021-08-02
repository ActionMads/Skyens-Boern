//
//  ChangeComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 05/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ChangeComponent : GKComponent {
    var digit : String
    let clock: GKEntity
    var currentNumber: Int
    var currentSpriteName : String
    let scene: Cave
    
    
    init(clock: GKEntity, digit: String, scene: Cave) {
        self.digit = digit
        self.clock = clock
        self.currentNumber = 0
        self.currentSpriteName = "0"
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
