//
//  SeekingState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 14/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class SeekingState : GKState {
    
    weak var entity : Competitor?
    weak var opponent : Competitor?
    
    init(withEntity : Competitor, opponent : Competitor) {
        self.entity = withEntity
        self.opponent = opponent
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RestingState.Type:
            return true
        case is MovingState.Type:
            return false
        case is FightingState.Type:
            return true
        case is GettingHitState.Type:
            return false
        case is DieState.Type:
            return false
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        if (entity?.component(ofType: SeekComponent.self)) != nil {
            entity?.removeComponent(ofType: SeekComponent.self)
        }
        if let _ = previousState as? MovingState {
            entity?.component(ofType: SwimmingComponent.self)?.canSwim = false
            entity?.addComponent(SeekComponent(opponent: opponent!, this: entity!))
        } else if let _ = previousState as? RestingState {
            entity?.component(ofType: HitingComponent.self)?.isInvunreble = false
            entity?.addComponent(SeekComponent(opponent: opponent!, this: entity!))
        } else if let _ = previousState as? GettingHitState {
            entity?.addComponent(SeekComponent(opponent: opponent!, this: entity!))
        }
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}

