//
//  RefuelingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 25/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class RefuelingComponent : GKComponent {
    var timeSinceLastBeam : TimeInterval = 0
    var refuelTIme : TimeInterval = 4
    let tap : GKEntity
    
    init(tap : GKEntity) {
        self.tap = tap
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
