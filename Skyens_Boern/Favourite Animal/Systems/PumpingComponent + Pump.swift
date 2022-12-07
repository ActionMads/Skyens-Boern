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
        if isActive {
            print("Time Left: ", timeLeft)
            guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {
                return}
            if isFirst {
                let action = self.scene.scaleUpAndDown(duration: 0.5, delay: 0)
                hasSprite.sprite.run(.repeatForever(action))
                isFirst = false
            }

            self.timeLeft -= seconds
            if timeLeft <= 0 {
                hasSprite.sprite.removeAllActions()
                hasSprite.sprite.name = "hearthBtnWait"
                self.scene.makeHearth()
                self.isActive = false
                isFirst = true
                timeLeft = progressTime
            }
        }
    }

}
