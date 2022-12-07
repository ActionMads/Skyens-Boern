//
//  IsFullState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 12/10/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class FullState : GKState {
    
    var entity : GKEntity
    
    init(withEntity : GKEntity) {
        self.entity = withEntity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RefuelingState.Type:
            return false
        case is EmptyState.Type:
            return true
        default:
            return false
        }
    }
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? RefuelingState {
            entity.addComponent(InteractionComponent())
            entity.removeComponent(ofType: RefuelingComponent.self)
        }
    }
}
