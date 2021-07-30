//
//  ProgressingComponent+Progress.swift
//  Dromedary
//
//  Created by Mads Munk on 15/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit

extension ProgressingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        switch progress {
        case 0:
            name = "ProgressCircle\(progress)"
            break
        case 1:
            name = "ProgressCircle\(progress)"
            break
        case 2:
            name = "ProgressCircle\(progress)"
            break
        case 3:
            name = "ProgressCircle\(progress)"
            break
        case 4:
            name = "ProgressCircle\(progress)"
            break
        case 5:
            name = "ProgressCircle\(progress)"
            break
        case 6:
            name = "ProgressCircle\(progress)"
            break
        case 7:
            name = "ProgressCircle\(progress)"
            break
        case 8:
            name = "ProgressCircle\(progress)"
            break
        case 9:
            name = "ProgressCircle\(progress)"
            break
        case 10:
            name = "ProgressCircle\(progress)"
            break
        case 11:
            name = "ProgressCircle\(progress)"
            break
        case 12:
            name = "ProgressCircle\(progress)"
            isActive = false
            if hasSprite.sprite.name == "Piano"{
                scene.makeMelody()
            }
            if hasSprite.sprite.name == "Flower" {
                scene.makeFlower(targetPosition: self.scene.makeFlowerTargetPosition())
            }

            progress = 0
            break
        default:
            break
        }
        
        texture = SKTexture(imageNamed: name)
        hasSprite.setTexture(texture: texture)

    }
}
