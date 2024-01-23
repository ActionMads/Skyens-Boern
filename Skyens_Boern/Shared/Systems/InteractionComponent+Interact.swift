//
//  InteractionComponent+Interact.swift
//  Dromedary
//
//  Created by Mads Munk on 18/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// Extension/System to the Interaction component
extension InteractionComponent {
    override func update(deltaTime seconds: TimeInterval) {

        // State switch with none, move or rotate cases
        switch state {
        case .none:
            break
        case .move(let state, let point):
            self.handleMove(state: state, point: point, deltaTime: seconds)
        case .rotate(let state, let float):
            self.handleRotation(state: state, rotation: float, deltaTime: seconds)
        }
    }
    
    // Handle the move interaction
    func handleMove( state : ActionState, point : CGPoint? , deltaTime: TimeInterval) {
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else {
            return
        }

        if self.didBegin {
            if let hasPoint = point {
                offset = positionComponent.currentPosition - hasPoint
            }
            self.didBegin = false
        }

        if let hasPoint = point {
            positionComponent.currentPosition = hasPoint + offset
        }
        
        // State switch with ended or changed cases
        switch state {
        case .ended:
            // 3.
            self.state = .none
            self.timeSinceTouch += deltaTime
            offset = .zero
        case .changed:
            self.state = .none
        default:
            self.state = .none
            break
        }
    }
    
    // Handle the rotation interaction
    func handleRotation( state : ActionState, rotation : CGFloat, deltaTime: TimeInterval) {

        // 1.
        guard let rotationComponent = entity?.component(ofType: RotationComponent.self) else {
            return
        }
        
        if self.didBegin {
            rotationOffset = rotationComponent.currentRotation - rotation
            self.didBegin = false
        }
        
        // state switch with ended or changed cases
        switch state {
        
        case .ended:
            self.state = .none
            self.timeSinceTouch += deltaTime
            print("current rotation", rotationComponent.currentRotation)
        case .changed:
            rotationComponent.currentRotation = rotation + rotationOffset
            self.state = .none
         default:
            self.state = .none
            break
         }
    }
}
