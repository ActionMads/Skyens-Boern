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
    var scene : Melody
    
    init(withEntity : GKEntity, scene : Melody) {
        self.entity = withEntity
        self.scene = scene
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
    
    /* If entering from Refuelingstate add the interaction*/
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? RefuelingState {
            entity.addComponent(InteractionComponent())
            scene.updateSystems()
        }
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}
