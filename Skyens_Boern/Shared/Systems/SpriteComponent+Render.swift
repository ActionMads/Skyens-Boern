//
//  SpriteComponent+Render.swift
//  Dromedary
//
//  Created by Mads Munk on 18/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//
import SpriteKit
import GameplayKit

extension SpriteComponent {
    
    override func update(deltaTime seconds: TimeInterval) {
    // 2.
    
        guard let hasPositionComponent = entity?.component(ofType: PositionComponent.self) else {
            return
        }
        // 3.
        self.sprite.position = hasPositionComponent.currentPosition
        
        if let hasRotation = entity?.component(ofType: RotationComponent.self) {
            if hasRotation.currentRotation > .pi {
                hasRotation.currentRotation = .pi
            }else if hasRotation.currentRotation < -.pi{
                hasRotation.currentRotation = -.pi
            }
            self.sprite.zRotation = hasRotation.currentRotation
            print(self.name, hasRotation.currentRotation)
        }
        
        if let hasSnapping = entity?.component(ofType: SnappingComponent.self) {
            if hasSnapping.hasSnapped {
                self.sprite.zPosition = 2
            }
        }
    }
}
