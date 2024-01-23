//
//  SeekComponent + Seek.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 14/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

extension SeekComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        // if the entity has the following components continue else return
        guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {
            return}
        
        guard let opponentHasPosition = opponent.component(ofType: PositionComponent.self) else {return}
        
        guard let hasSwimming = entity?.component(ofType: SwimmingComponent.self) else {return}
        
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {return}
        
        // set target position to opponents current position
        hasPosition.targetPosition = opponentHasPosition.currentPosition
        
        // if seeking entitys current position is bigger or less than target position and smimming direction does not match change smimming direction
        // change smimming direction of sprite
        if hasPosition.targetPosition.x < hasPosition.currentPosition.x && hasSwimming.direction == "Right" {
            hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
            hasSwimming.direction = "Left"
        }else if hasPosition.targetPosition.x > hasPosition.currentPosition.x && hasSwimming.direction == "Left" {
            hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
            hasSwimming.direction = "Right"
        }
        
        // create vector
        let vector = hasPosition.currentPosition - hasPosition.targetPosition
        
        // create hypotenuse from vedtor
        let hyp = sqrt(( vector.x * vector.x ) + (vector.y + vector.y))
        
        // if hypotenuse is less than the tolerance competitor has reached target
        if hyp < self.positionTolerence {
            hasReachedTarget = true
        }
        
        // if competitor has reached target enter fighting state
        if hasReachedTarget == true {
            this.stateMachine.enter(FightingState.self)
        }
        
        // if the competitor has not reached target keep smming towards target
        if hasReachedTarget == false {
            hasPosition.currentPosition = hasSwimming.swim(currentPosition: hasPosition.currentPosition, targetPosition: hasPosition.targetPosition, seconds: seconds)
        }
    }
}
