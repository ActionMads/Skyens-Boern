//
//  SwimmingComponent + Swim.swift
//  Dromedary
//
//  Created by Mads Munk on 28/07/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension SwimmingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {
            return}
        
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {
            return}
        
        let vector = hasPosition.currentPosition - hasPosition.targetPosition
        
        let hyp = sqrt(( vector.x * vector.x ) + (vector.y + vector.y))
                
        if hyp < self.positionTolerence {
            hasReachedTarget = true
        }
        
        if hasReachedTarget == true {
            print("target", hasPosition.targetPosition, "currentPos:", hasPosition.currentPosition )
                hasReachedTarget = false
            if self.direction == "Left" {
                hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                self.direction = "Right"
                hasPosition.targetPosition = CGPoint(x: 2200, y: 1000)
                print("target", hasPosition.targetPosition, "currentPos:", hasPosition.currentPosition )
            } else if self.direction == "Right" {
                hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                self.direction = "Left"
                hasPosition.targetPosition = CGPoint(x: 500, y: 1000)
                print("target", hasPosition.targetPosition, "currentPos:", hasPosition.currentPosition )
            }


        }
        
        if hasReachedTarget == false {
            let offset = CGPoint(x: hasPosition.targetPosition.x - hasPosition.currentPosition.x,
                                 y: hasPosition.targetPosition.y - hasPosition.currentPosition.y)
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

