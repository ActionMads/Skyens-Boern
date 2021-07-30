//
//  JumpingAround+Jump.swift
//  Dromedary
//
//  Created by Mads Munk on 17/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension JumpingAroundComponent {
    override func update(deltaTime seconds: TimeInterval) {
        guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {
            return}
        
        
        
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {return}
        
        guard let hasEating = entity?.component(ofType: EatingComponent.self) else {
            return
        }
        
        guard let hasDancing = entity?.component(ofType: JollyDancingComponent.self) else {
            return
        }
        
        
        let vector = hasPosition.currentPosition - hasPosition.targetPosition
        
        let hyp = sqrt(( vector.x * vector.x ) + (vector.y + vector.y))
                
        if hyp < self.positionTolerence {
            hasReachedTarget = true
        }
        
        if hasReachedTarget == true {
            hasPosition.targetPosition = CGPoint(x: CGFloat.random(min: 150, max: 2500), y: 500)
                hasReachedTarget = false
            if hasPosition.targetPosition.x > hasPosition.currentPosition.x && self.direction == "Left" {
                hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                self.direction = "Right"
            } else if hasPosition.targetPosition.x < hasPosition.currentPosition.x && self.direction == "Right" {
                hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                self.direction = "Left"
            }

        }
        
        if hasReachedTarget == false {
            if canJump && hasEating.isEating == false && hasDancing.isDancing == false {
                let offset = CGPoint(x: hasPosition.targetPosition.x - hasPosition.currentPosition.x,
                                     y: 0)
                let length = sqrt(
               Double(offset.x * offset.x + offset.y * offset.y))
                
                let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
                velocity = CGPoint(x: direction.x * movePointsPerSec, y: direction.y * movePointsPerSec)
                
                print("direction: ", direction)
            
                let amountToMove = CGPoint(x: velocity.x * CGFloat(seconds), y: velocity.y * CGFloat(seconds))
                
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x + amountToMove.x, y: hasPosition.currentPosition.y + amountToMove.y)
            }
        }
    }
}
