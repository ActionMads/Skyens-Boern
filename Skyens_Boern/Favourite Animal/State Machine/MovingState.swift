//
//  MovementState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 13/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class MovingState: GKState {
    weak var entity : Competitor?
    
    init(withEntity : Competitor) {
        self.entity = withEntity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FightingState.Type:
            return false
        case is RestingState.Type:
            return true
        case is SeekingState.Type:
            return true
        case is GettingHitState.Type:
            return true
        case is DieState.Type:
            return false
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? FightingState {
            entity?.component(ofType: SwimmingComponent.self)?.canSwim = true
            var targetPosition : CGPoint!
            if entity?.name == "croco" {
                targetPosition = CGPoint(x: CGFloat.random(min: 500, max: 950), y: 1000)
            } else if entity?.name == "shark" {
                targetPosition = CGPoint(x: CGFloat.random(min: 1750, max: 2200), y: 1000)
            }
            entity?.component(ofType: PositionComponent.self)?.targetPosition = targetPosition
        } else if let _ = previousState as? RestingState {
            entity?.component(ofType: SwimmingComponent.self)?.canSwim = true
            entity?.component(ofType: HitingComponent.self)?.isInvunreble = false
            var targetPosition : CGPoint!
            if entity?.name == "croco" {
                targetPosition = CGPoint(x: CGFloat.random(min: 500, max: 950), y: 1000)
            } else if entity?.name == "shark" {
                targetPosition = CGPoint(x: CGFloat.random(min: 1750, max: 2200), y: 1000)
            }
            entity?.component(ofType: PositionComponent.self)?.targetPosition = targetPosition
        } else if let _ = previousState as? GettingHitState {
            entity?.component(ofType: SwimmingComponent.self)?.canSwim = true
            var targetPosition : CGPoint!
            if entity?.name == "croco" {
                targetPosition = CGPoint(x: CGFloat.random(min: 500, max: 950), y: 1000)
            } else if entity?.name == "shark" {
                targetPosition = CGPoint(x: CGFloat.random(min: 1750, max: 2200), y: 1000)
            }
            entity?.component(ofType: PositionComponent.self)?.targetPosition = targetPosition
        }
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
