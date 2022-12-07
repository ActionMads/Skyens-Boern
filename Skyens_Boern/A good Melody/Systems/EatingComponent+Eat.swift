//
//  EatingComponent+Eat.swift
//  Dromedary
//
//  Created by Mads Munk on 18/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension EatingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        if scene.canEat {
            print("Able to eat")
            guard let hasDancing = entity?.component(ofType: JollyDancingComponent.self) else {return}
            if hasDancing.isDancing == false {
                print("not dancing")
                guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {return}
                
                guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {return}
                
                print("Has components")
                if self.isEating == true {
                    self.eatingCount -= seconds
                }
                
                scene.enumerateChildNodes(withName: "Bi-Small") { node, _ in
                    let bee = node as! SKSpriteNode
                    print("bee name", bee.name)
                    if bee.frame.intersects(hasSprite.sprite.frame) {
                        self.isEating = true
                        print("EatingCount:", self.eatingCount)
                        if self.eatingCount <= 1 && self.eatingCount > 0.99 {
                            hasSprite.setTexture(texture: self.tongueTex!)
                            bee.entity?.component(ofType: SpriteComponent.self)?.sprite.removeAllActions()
                            bee.entity?.removeComponent(ofType: FlyComponent.self)
                            let tonguePoint = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y + hasSprite.sprite.size.height/2)
                            bee.entity?.component(ofType: PositionComponent.self)?.currentPosition = tonguePoint
                        }
                        if self.eatingCount <= 0.5 && self.eatingCount > 0.49 {
                            hasSprite.setTexture(texture: self.noTongueTex!)
                            let eatingPoint = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y)
                            bee.entity?.component(ofType: PositionComponent.self)?.currentPosition = eatingPoint
                        }
                        if self.eatingCount <= 0.0 && self.eatingCount > -0.99 {
                            hasSprite.setTexture(texture: self.scene.frogAtlas.textureNamed("FrøNy"))
                            bee.entity?.component(ofType: SpriteComponent.self)?.sprite.removeAllActions()
                            bee.entity?.component(ofType: CollectingNectarComponent.self)?.timer?.invalidate()
                            let index = self.scene.bees.firstIndex(of: bee.entity!)
                            self.scene.bees.remove(at: index!)
                            self.scene.removeEntity(entity: bee.entity!)
                            self.isEating = false
                            self.eatingCount = 1
                        }
                    }
                }
            }
        }
    }
}
