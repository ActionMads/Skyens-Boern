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

enum ActionState : Equatable {
    case began
    case changed
    case ended
}
// 1.
enum Action : Equatable  {
    case none
    case move(ActionState, CGPoint?)
    case rotate(ActionState, CGFloat)
}
class InteractionComponent : GKComponent {
    // 1.
    var rotationOffset : CGFloat = 0
    
    var timeSinceTouch : TimeInterval = 0
    
    var didBegin : Bool = false
    var state : Action = .none {
        // 2.
        didSet {
            switch state {
            case .move(let state, _), .rotate(let state, _):
                if state == .began {
                    self.didBegin = true
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


