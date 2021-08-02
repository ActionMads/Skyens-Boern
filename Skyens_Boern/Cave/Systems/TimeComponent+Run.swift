//
//  TimeComponent+Run.swift
//  Dromedary
//
//  Created by Mads Munk on 05/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension TimeComponent {
    override func update(deltaTime seconds: TimeInterval) {
        self.calculateMinAndSec()
        
        if timeLeft == stopTime {
            timeIsUp = true
        }
    }
}
