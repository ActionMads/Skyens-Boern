//
//  GroundContactComponent+Contact.swift
//  Dromedary
//
//  Created by Mads Munk on 26/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension GroundContactComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else { return }
        
        guard let gravityComponent = (entity?.component(ofType: GravityComponent.self)) else { return }
        
        guard let rotationComponent = (entity?.component(ofType: RotationComponent.self)) else { return }
        
        guard let spriteComponent = (entity?.component(ofType: SpriteComponent.self)) else {
            return }
        
        if positionComponent.currentPosition.y <= groundHeight + spriteComponent.sprite.size.height/2{
            rotationComponent.currentRotation = rotateToLying(currentRotation: rotationComponent.currentRotation)
        }
        if positionComponent.currentPosition.y <= groundHeight {
            gravityComponent.downForce = 0

        }else{
            gravityComponent.downForce = 5
        }
    }
    
    func rotateToLying(currentRotation: CGFloat) -> CGFloat{
        var inDegrees = abs(currentRotation.toDegrees())
        if inDegrees > 0 && inDegrees < 360 {
            return (inDegrees - 1).toRads()
        }
        if inDegrees < 0 && inDegrees > -360 {
            return (inDegrees + 1).toRads()
        }
        else {
            return inDegrees.toRads()
        }
    }
}
