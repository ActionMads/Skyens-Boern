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


extension InteractionComponent {
    override func update(deltaTime seconds: TimeInterval) {
        // 1.
        
        switch state {
        case .none:
            break
        case .move(let state, let point):
            self.handleMove(state: state, point: point, deltaTime: seconds)
        case .rotate(let state, let float):
            self.handleRotation(state: state, rotation: float, deltaTime: seconds)
        }
    }
    func handleMove( state : ActionState, point : CGPoint? , deltaTime: TimeInterval) {
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else {
            return
        }

        // 1.
        if self.didBegin {
            if let hasPoint = point {
                offset = positionComponent.currentPosition - hasPoint
            }
            self.didBegin = false
        }

        if let hasPoint = point {
            // 2.
            positionComponent.currentPosition = hasPoint + offset
        }

        switch state {
        case .ended:
            // 3.
            self.state = .none
            self.timeSinceTouch += deltaTime
            offset = .zero
        default:
            break
        }
    }
    
    func handleRotation( state : ActionState, rotation : CGFloat, deltaTime: TimeInterval) {

        // 1.
        guard let rotationComponent = entity?.component(ofType: RotationComponent.self) else {
            return
        }
        
        if self.didBegin {
            rotationOffset = rotationComponent.currentRotation - rotation
            self.didBegin = false
        }
        
         switch state {
        
            // 2.
         case .ended:
                self.state = .none
            self.timeSinceTouch += deltaTime
            print("current rotation", rotationComponent.currentRotation)

        // 3.
         default:
            if rotationComponent.currentRotation > 1.5 {
                rotationComponent.currentRotation = 1.5
            }else if rotationComponent.currentRotation < -1.5 {
                rotationComponent.currentRotation = -1.5
            }else{
            rotationComponent.currentRotation = rotation + rotationOffset
            }
         }
    }
}
