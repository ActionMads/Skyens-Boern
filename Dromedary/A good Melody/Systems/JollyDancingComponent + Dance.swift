//
//  JollyDancingComponent + Dance.swift
//  Dromedary
//
//  Created by Mads Munk on 07/04/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit

extension JollyDancingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        guard let hasEating = self.entity?.component(ofType: EatingComponent.self) else {return}
        
        guard let hasJumping = self.entity?.component(ofType: JumpingAroundComponent.self) else {return}
                
        if hasEating.isEating {
            return
        }
        
        if self.isDancing {
            self.dancingTime -= seconds
        }
        
        guard let hasSprite = self.entity?.component(ofType: SpriteComponent.self) else {return}
        
        if let melody = self.scene.childNode(withName: "Node") {
            if melody.frame.intersects(hasSprite.sprite.frame){
                self.isDancing = true
                self.scene.removeEntity(entity: melody.entity!)
            }
        }
        if self.isDancing {
            if self.dancingTime <= 5 && self.dancingTime > 4.9{
                self.setTexture(texture: SKTexture(imageNamed: "FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }
                
            }
            if self.dancingTime <= 4.5 && self.dancingTime > 4.4{
                self.setTexture(texture: SKTexture(imageNamed: "FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 4 && self.dancingTime > 3.9{
                self.setTexture(texture: SKTexture(imageNamed: "FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 3.5 && self.dancingTime > 3.4{
                self.setTexture(texture: SKTexture(imageNamed: "FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }


            }
            if self.dancingTime <= 3 && self.dancingTime > 2.9{
                self.setTexture(texture: SKTexture(imageNamed: "FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 2.5 && self.dancingTime > 2.4{
                self.setTexture(texture: SKTexture(imageNamed: "FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 2 && self.dancingTime > 1.9{
                self.setTexture(texture: SKTexture(imageNamed: "FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 1.5 && self.dancingTime > 1.4{
                self.setTexture(texture: SKTexture(imageNamed: "FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 1 && self.dancingTime > 0.9{
                self.setTexture(texture: SKTexture(imageNamed: "FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 0.5 && self.dancingTime > 0.4{
                self.setTexture(texture: SKTexture(imageNamed: "FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 0{
                self.isDancing = false
                self.dancingTime = 5
            }
        }
    }
}
