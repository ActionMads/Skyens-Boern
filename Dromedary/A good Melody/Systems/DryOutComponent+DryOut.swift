//
//  DryOutComponent+DryOut.swift
//  Dromedary
//
//  Created by Mads Munk on 12/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

extension DryOutComponent {
    override func update(deltaTime seconds: TimeInterval) {
        self.timeLeft -= seconds
        
        guard let flower = self.entity?.component(ofType: SpriteComponent.self) else {return}
        
        if timeLeft <= 20 && timeLeft > 19 {
            if self.scene.canDryOut {
                flower.setTexture(texture: dryOutTexture)
            } else {
                self.timeLeft += self.timeToDryOut
            }
        }
        
        if timeLeft <= 0 {
            hasDied = true

        }
        

        
        scene.enumerateChildNodes(withName: "drop") { [self]node, _ in
            let drop = node as! SKSpriteNode
            if drop.frame.intersects(flower.sprite.frame) {
                dropsCollected += 1
                if dropsCollected == 3 {
                    timeLeft = timeToDryOut + timeToRemove
                    flower.setTexture(texture: revivedTexture)
                    dropsCollected = 0
                    scene.removeEntity(entity: drop.entity!)
                }
            }
        }
    }
}
