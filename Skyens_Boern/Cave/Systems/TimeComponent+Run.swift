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

// Time component update method
extension TimeComponent {
    override func update(deltaTime seconds: TimeInterval) {
        // call claculate method
        self.calculateMinAndSec()
        
        // if time left is equal to stop time, time is up
        if timeLeft == stopTime {
            timeIsUp = true
        }
        // play speak at specific time units
        if timeLeft == 131 && !hasPlayedSpeak {
            self.scene.playSpeak(name: "Hulen1", length: 6)
            hasPlayedSpeak = true
        }
        if timeLeft == 122 && !hasPlayedSpeak {
            self.scene.playSpeak(name: "Hulen3", length: 5)
            hasPlayedSpeak = true
        }
        if timeLeft == 110 && !hasPlayedSpeak {
            self.scene.playSpeak(name: "Hulen4", length: 3)
            hasPlayedSpeak = true
        }
        
    }
}
