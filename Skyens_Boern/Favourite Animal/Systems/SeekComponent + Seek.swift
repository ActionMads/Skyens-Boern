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
        
        guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {
            return}
        
        guard let opponentHasPosition = opponent.component(ofType: PositionComponent.self) else {return}
        
        guard let hasSwimming = entity?.component(ofType: SwimmingComponent.self) else {return}
        
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {return}
        
        hasPosition.targetPosition = opponentHasPosition.currentPosition
        
        if hasPosition.targetPosition.x < hasPosition.currentPosition.x && hasSwimming.direction == "Right" {
            hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
            hasSwimming.direction = "Left"
        }else if hasPosition.targetPosition.x > hasPosition.currentPosition.x && hasSwimming.direction == "Left" {
            hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
            hasSwimming.direction = "Right"
        }
        
        let vector = hasPosition.currentPosition - hasPosition.targetPosition
        
        let hyp = sqrt(( vector.x * vector.x ) + (vector.y + vector.y))
                
        if hyp < self.positionTolerence {
            hasReachedTarget = true
        }
        
        if hasReachedTarget == true {
            this.stateMachine.enter(FightingState.self)
        }
        
        if hasReachedTarget == false {
            hasPosition.currentPosition = hasSwimming.swim(currentPosition: hasPosition.currentPosition, targetPosition: hasPosition.targetPosition, seconds: seconds)
        }
    }
}
