//
//  SnappingComponent+Snap.swift
//  Dromedary
//
//  Created by Mads Munk on 20/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
extension SnappingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        if isSetup {
            // 1.
            guard let positionComponent = entity?.component(ofType: PositionComponent.self) else { return }

            print("current position", positionComponent.currentPosition)
        
            // 2.
            guard let interactionComponent = entity?.component(ofType: InteractionComponent.self), interactionComponent.state == .none else { return }

            guard let rotationComponent = entity?.component(ofType: RotationComponent.self) else { return }

            // 3.
            let vector = positionComponent.currentPosition - positionComponent.targetPosition

            // 4.
            let hyp = sqrt(( vector.x * vector.x ) + (vector.y + vector.y))

            // 5.
            var shouldSnap = true
            
            if interactionComponent.timeSinceTouch < 0.1 && interactionComponent.timeSinceTouch > 2 {
                shouldSnap = false
            }

            // 2.
            if hyp > self.positionTolerance {
                shouldSnap = false
            }
            
            print(shouldSnap)
            
                // 3.
            let inDegrees = abs(rotationComponent.currentRotation.toDegrees())
            print("current degrees ", inDegrees)

            let targetInDegress = abs(rotationComponent.targetRotation.toDegrees())
            print("target", targetInDegress)
            
            
            if inDegrees < targetInDegress - rotationTolerance || inDegrees > targetInDegress + rotationTolerance {
                shouldSnap = false
                print("shouldSnap", shouldSnap)
            }
            
            if shouldSnap {
                // 5.
                positionComponent.currentPosition = positionComponent.targetPosition
                rotationComponent.currentRotation = rotationComponent.targetRotation
                hasSnapped = true
            }
        }
    }
}
