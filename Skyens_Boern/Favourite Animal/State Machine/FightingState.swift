//
//  FightingState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 13/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class FightingState : GKState {
    
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
            return true
        case is SeekingState.Type:
            return false
        case is GettingHitState.Type:
            return false
        case is DieState.Type:
            return false
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? SeekingState {
            entity?.component(ofType: SwimmingComponent.self)?.canSwim = false
            entity?.removeComponent(ofType: SeekComponent.self)
            entity?.component(ofType: FightingComponent.self)?.attack(opponent: opponent!)
            entity?.perform(#selector(entity?.enterMovingState), with: nil, afterDelay: 1.5)
        }
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
