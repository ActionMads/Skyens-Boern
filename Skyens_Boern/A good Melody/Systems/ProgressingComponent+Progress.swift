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
        print("Progressing")
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        if hasSprite.sprite.name == "Piano" {
            name = "ProgressCircleBlack"
        }
        if hasSprite.sprite.name == "Flower" {
            name = "ProgressCircle"
        }
        
        switch progress {
        case 0:
            name = "\(name)\(progress)"
            break
        case 1:
            name = "\(name)\(progress)"
            break
        case 2:
            name = "\(name)\(progress)"
            break
        case 3:
            name = "\(name)\(progress)"
            break
        case 4:
            name = "\(name)\(progress)"
            break
        case 5:
            name = "\(name)\(progress)"
            break
        case 6:
            name = "\(name)\(progress)"
            break
        case 7:
            name = "\(name)\(progress)"
            break
        case 8:
            name = "\(name)\(progress)"
            break
        case 9:
            name = "\(name)\(progress)"
            break
        case 10:
            name = "\(name)\(progress)"
            break
        case 11:
            name = "\(name)\(progress)"
            break
        case 12:
            name = "\(name)\(progress)"
            isActive = false
            if hasSprite.sprite.name == "Piano"{
                scene.makeMelody()
            }
            if hasSprite.sprite.name == "Flower" && scene.canMakeFlowers {
                scene.makeFlower(targetPosition: self.scene.makeFlowerTargetPosition())
            }

            progress = 0
            break
        default:
            break
        }
        print("progress name:", name)
        texture = scene.progressAtlas.textureNamed(name)
        hasSprite.setTexture(texture: texture)
        hasSprite.sprite.setScale(2.0)

    }
}
