//
//  InteractionComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 18/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

// Possible action states
enum ActionState : Equatable {
    case began
    case changed
    case ended
}

// Possible Actions
enum Action : Equatable  {
    case none
    case move(ActionState, CGPoint?)
    case rotate(ActionState, CGFloat)
}

// Interaction component responsible for handling an entitys interaction with the player
class InteractionComponent : GKComponent {
    
    // Global varibles
    var rotationOffset : CGFloat = 0
    
    var timeSinceTouch : TimeInterval = 0
    
    var didBegin : Bool = false
    
    var hasBeenTouched : Bool = false
    
    // state varibles default action is .none. If the action is move or rotate and actionstate is .began the interaction did begin
    var state : Action = .none {
        
        didSet {
            switch state {
            case .move(let state, _), .rotate(let state, _):
                if state == .began {
                    self.didBegin = true
                    self.hasBeenTouched = true
                }
            default:
                break
            }
        }
    }
    var targetEntity : GKEntity?
    // 3.
    var offset : CGPoint = .zero
    
    deinit {
        print(self, "has deinitialized")
    }
}


