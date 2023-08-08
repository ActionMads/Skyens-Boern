//
//  DieState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 25/05/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class DieState: GKState {
    weak var entity : Competitor?
    
    init(withEntity : Competitor) {
        self.entity = withEntity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FightingState.Type:
            return false
        case is MovingState.Type:
            return false
        case is SeekingState.Type:
            return false
        case is RestingState.Type:
            return false
        case is GettingHitState.Type:
            return false
        default:
            return false
        }
    }
    
    /* Activate the death animation */
    override func didEnter(from previousState: GKState?) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {return}
        guard let swimmingComponent = entity?.component(ofType: SwimmingComponent.self) else {return}
        var turnAction : SKAction!
        if swimmingComponent.direction == "Left" {
            turnAction = SKAction.rotate(toAngle: +.pi/2, duration: 2)
        }
        if swimmingComponent.direction == "Right" {
            turnAction = SKAction.rotate(toAngle: -.pi/2, duration: 2)
        }
        let drownAction = SKAction.moveTo(y: -spriteComponent.sprite.size.height, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([turnAction, drownAction, removeAction])
        spriteComponent.sprite.run(sequence)
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}

