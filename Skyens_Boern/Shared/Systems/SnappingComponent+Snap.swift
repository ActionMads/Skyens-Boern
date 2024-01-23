//
//  SnappingComponent+Snap.swift
//  Dromedary
//
//  Created by Mads Munk on 20/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit

// Extension/System to the snapping component
extension SnappingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        // Only continue if entity has the following components
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else { return }

        print("current position", positionComponent.currentPosition)
    
        guard let interactionComponent = entity?.component(ofType: InteractionComponent.self), interactionComponent.state == .none else { return }

        guard let rotationComponent = entity?.component(ofType: RotationComponent.self) else { return }
        
        // If current position is not equal to target position the entity has not snapped
        if positionComponent.currentPosition != positionComponent.targetPosition {
            hasSnapped = false
        }
        
        // Calculate a vector
        let vector = positionComponent.currentPosition - positionComponent.targetPosition

        // Calculate the hypotonuse from the vector
        let hyp = sqrt(( vector.x * vector.x ) + (vector.y * vector.y))

        // Set the should snap boolean to true
        var shouldSnap = true
        
        // If the hypotunuse is bigger than the snappin position tolerance the entity shouyld not snap
        if hyp > self.positionTolerance {
            shouldSnap = false
        }
        print("hyp ", hyp, "Tolerence ", self.positionTolerance, " ", shouldSnap)

        
        print(shouldSnap)
        
        // Convert the current rotation to degress
        let inDegrees = rotationComponent.currentRotation.toDegrees()
        print("current degrees ", inDegrees)

        // Convert the target rotation to degress
        let targetInDegress = rotationComponent.targetRotation.toDegrees()
        print("target", targetInDegress)
        
        // If the current degress is less than target degress - snapping rotation tolerance or
        // the current degress is less than target in degress + snapping rotation tolerance the entity should not snap. The entity is not rotated close enoug to the target rotation
        if inDegrees < targetInDegress - rotationTolerance || inDegrees > targetInDegress + rotationTolerance {
            shouldSnap = false
        }
        
        print("shouldSnap", shouldSnap)

        // should snap is still true snap the entity to the target rotation and position
        if shouldSnap {
            // 5.
            positionComponent.currentPosition = positionComponent.targetPosition
            rotationComponent.currentRotation = rotationComponent.targetRotation
            hasSnapped = true
        }
    }
}
