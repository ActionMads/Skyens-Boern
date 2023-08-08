//
//  EmptyState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 12/10/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class EmptyState : GKState {
    
    var entity : GKEntity
    var scene : Melody
    
    init(withEntity : GKEntity, scene : Melody) {
        self.scene = scene
        self.entity = withEntity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RefuelingState.Type:
            return true
        case is FullState.Type:
            return false
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.updateSystems()
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}
