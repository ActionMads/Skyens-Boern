//
//  SpriteComponent+Render.swift
//  Dromedary
//
//  Created by Mads Munk on 18/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//
import SpriteKit
import GameplayKit

// Extension/System to the sprite component
extension SpriteComponent {
    
    override func update(deltaTime seconds: TimeInterval) {
    
    // Only continue if entity has this component
        guard let hasPositionComponent = entity?.component(ofType: PositionComponent.self) else {
            return
        }
        // set component sprite position to entity position component
        self.sprite.position = hasPositionComponent.currentPosition
        
        // if entity has rotation component
        if let hasRotation = entity?.component(ofType: RotationComponent.self) {
            // Define the limit whereby a sprite can rotate and reset rotation if it is more or less
            if hasRotation.currentRotation > .pi {
                hasRotation.currentRotation = .pi
            }else if hasRotation.currentRotation < -.pi{
                hasRotation.currentRotation = -.pi
            }
            // Set sprite zRotation to currentrotation in Rotationcomponent
            self.sprite.zRotation = hasRotation.currentRotation
            print(self.name, hasRotation.currentRotation)
        }
        
        // If a sprite has snapped set the zposition to 4
        if let hasSnapping = entity?.component(ofType: SnappingComponent.self) {
            if hasSnapping.hasSnapped {
                self.sprite.zPosition = 4
            }
        }
    }
}
