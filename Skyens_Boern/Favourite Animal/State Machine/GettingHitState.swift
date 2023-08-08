//
//  GettingHitState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 18/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class GettingHitState: GKState {
    weak var entity : Competitor?
    
    init(withEntity : Competitor) {
        self.entity = withEntity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FightingState.Type:
            return false
        case is MovingState.Type:
            return true
        case is SeekingState.Type:
            return true
        case is RestingState.Type:
            return true
        case is DieState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        /* If entering from MovingState disable swim and after delay enter moving state */
        if let _ = previousState as? MovingState {
            entity?.component(ofType: SwimmingComponent.self)?.canSwim = false
            entity?.perform(#selector(entity?.enterMovingState), with: nil, afterDelay: 1.5)
        }
        /* If entering from restingstate turn off invunrabillity after delay enter movingstate*/
        if let _ = previousState as? RestingState {
            entity?.component(ofType: HitingComponent.self)?.isInvunreble = false
            entity?.perform(#selector(entity?.enterMovingState), with: nil, afterDelay: 1.5)
        }
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}
