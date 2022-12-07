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
        
        if canSwim {
            
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
                    hasPosition.targetPosition = CGPoint(x: rightX, y: 1000)
                    print("target", hasPosition.targetPosition, "currentPos:", hasPosition.currentPosition )
                } else if self.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                    self.direction = "Left"
                    hasPosition.targetPosition = CGPoint(x: leftX, y: 1000)
                    print("target", hasPosition.targetPosition, "currentPos:", hasPosition.currentPosition )
                }


            }
            
            if hasReachedTarget == false {
                hasPosition.currentPosition = self.swim(currentPosition: hasPosition.currentPosition, targetPosition: hasPosition.targetPosition, seconds: seconds)
            }
        }
    }
}

