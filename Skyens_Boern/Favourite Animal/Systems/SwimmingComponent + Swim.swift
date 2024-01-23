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
        
        // only continue if the wnity has Position Component else return
        guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {
            return}
        
        // only continue if the wnity has Sprite Component else return
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {
            return}
        
        // if the entity is allowed to swim
        if canSwim {
            
            // create vector from current and target position
            let vector = hasPosition.currentPosition - hasPosition.targetPosition
            
            // calculate hypotinusis from vector
            let hyp = sqrt(( vector.x * vector.x ) + (vector.y + vector.y))
            
            // if hypotinusis is less then the tolerable distances target. Target is reached
            if hyp < self.positionTolerence {
                hasReachedTarget = true
            }
            
            // If target is reached set a new target so the competitors keep moving
            if hasReachedTarget == true {
                print("target", hasPosition.targetPosition, "currentPos:", hasPosition.currentPosition )
                    hasReachedTarget = false
                // change the direction of the competitor sprite acording to the current direction
                if self.direction == "Left" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                    self.direction = "Right"
                    hasPosition.targetPosition = CGPoint(x: rightX, y: 1000)
                    print("target", hasPosition.targetPosition, "currentPos:", hasPosition.currentPosition )
                } else if self.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                    self.direction = "Left"
                    hasPosition.targetPosition = CGPoint(x: leftX, y: 1000)
                    print("target", hasPosition.targetPosition, "currentPos:", hasPosition.currentPosition )
                }


            }
            
            // If the target has not been reached make the competitor swim by calling swim function
            if hasReachedTarget == false {
                hasPosition.currentPosition = self.swim(currentPosition: hasPosition.currentPosition, targetPosition: hasPosition.targetPosition, seconds: seconds)
            }
        }
    }
}

