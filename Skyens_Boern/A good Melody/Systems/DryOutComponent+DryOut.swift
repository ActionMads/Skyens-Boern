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
        
        /* If entity has the following components continue */
        
        guard let flower = self.entity?.component(ofType: SpriteComponent.self) else {return}
        
        // if time is between 19 and 20 dryout the plant
        if timeLeft <= 20 && timeLeft > 19 {
            if self.scene.canDryOut {
                flower.setTexture(texture: dryOutTexture)
                self.isDry = true
            } else {
                self.timeLeft += self.timeToDryOut
            }
        }
        
        // If time is 0 or less kill the plant
        if timeLeft <= 0 {
            hasDied = true

        }
        
        // Enumerate the water drops from the bottle and check if they intersects the flower. If the flower collects 3 drops the plant is revived. Last remove the drops from the scene
        scene.enumerateChildNodes(withName: "drop") { [self]node, _ in
            let drop = node as! SKSpriteNode
            if drop.frame.intersects(flower.sprite.frame) {
                dropsCollected += 1
                if dropsCollected == 3 {
                    timeLeft = timeToDryOut + timeToRemove
                    flower.setTexture(texture: revivedTexture)
                    self.isDry = false
                    self.isRevived = true
                    dropsCollected = 0
                    for system in self.scene.componentSystems {
                        system.removeComponent(foundIn: drop.entity!)
                    }
                    scene.removeEntity(entity: drop.entity!)

                }
            }
        }
        
    }
}
