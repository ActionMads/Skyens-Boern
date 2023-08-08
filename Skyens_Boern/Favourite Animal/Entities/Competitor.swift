//
//  Competitor.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 13/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class Competitor: GKEntity {
    var stateMachine : GKStateMachine!
    var name : String!
    var direction : String!
    var hasAttacked : Bool = false
    
    @objc func enterMovingState() {
        stateMachine.enter(MovingState.self)
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
