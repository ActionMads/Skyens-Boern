//
//  RefuelingState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 12/10/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class RefuelingState : GKState {
    
    var entity : GKEntity
    var scene : Melody
    
    init(withEntity : GKEntity, scene : Melody) {
        self.scene = scene
        self.entity = withEntity
    }
    
    // switch which decides what state is allowed next
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FullState.Type:
            return true
        case is EmptyState.Type:
            return false
        default:
            return false
        }
    }
    
    /* If enter state from empty state remove the interaction and start refueling the bottle*/
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? EmptyState {
            entity.removeComponent(ofType: InteractionComponent.self)
            entity.component(ofType: RefuelingComponent.self)?.run()
            scene.updateSystems()
        }
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}

