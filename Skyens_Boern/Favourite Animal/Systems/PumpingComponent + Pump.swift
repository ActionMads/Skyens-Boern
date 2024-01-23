//
//  ProgressingComponent + Progress.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 20/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

extension PumpingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        // if the hearthBtn is active/has been activated first run scale animation and when time is up create a new hearth
        if isActive {
            print("Time Left: ", timeLeft)
            guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {
                return}
            if isFirst {
                let action = self.scene.scaleUpAndDown(duration: 0.5, delay: 0)
                hasSprite.sprite.run(.repeatForever(action))
                isFirst = false
                hasBeenPushed = true
            }
            
            // reduce time left until hearth should be created
            self.timeLeft -= seconds
            if timeLeft <= 0 {
                hasSprite.sprite.removeAllActions()
                hasSprite.sprite.name = "hearthBtnWait"
                self.scene.makeHearth()
                self.isActive = false
                isFirst = true
                // reset the time left
                timeLeft = progressTime
            }
        }
    }

}
