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
        
        print("current rotation at all times", rotationComponent.currentRotation.toDegrees())

        
        if positionComponent.currentPosition.x <= leftWall + spriteComponent.sprite.size.width/2 {
            positionComponent.currentPosition.x = leftWall + spriteComponent.sprite.size.width/2
        }
        
        if positionComponent.currentPosition.x >= rightWall - spriteComponent.sprite.size.width/2{
            positionComponent.currentPosition.x = rightWall - spriteComponent.sprite.size.width/2
        }
        
        if positionComponent.currentPosition.y > topWall  - spriteComponent.sprite.size.height/2{
            positionComponent.currentPosition.y = topWall - spriteComponent.sprite.size.height/2
        }
        
        if positionComponent.currentPosition.y <= groundHeight + spriteComponent.sprite.size.height/2{
            rotationComponent.currentRotation = rotateToLying(currentRotation: rotationComponent.currentRotation)
            
        }
        if positionComponent.currentPosition.y < groundHeight - 100 {
            positionComponent.currentPosition.y = groundHeight + spriteComponent.sprite.size.height/2
        }
    }
    
    func rotateToLying(currentRotation: CGFloat) -> CGFloat{
        let inDegrees = currentRotation.toDegrees()
        print("current rotation in degress at ground contact", inDegrees)
        print("Rotating: ", isRotating)
        if inDegrees == 0 {
            isRotating = false
            return inDegrees.toRads()
        }
        if inDegrees > 90 && inDegrees <= 180 {
            if inDegrees >= 178 {
                isRotating = false
                return inDegrees.toRads()
            }else if inDegrees < 178 {
                isRotating = true
                return (inDegrees + 2).toRads()
            }
            else {
                return inDegrees.toRads()
            }
        }
        
        if inDegrees >= 0 && inDegrees < 90 {
            if inDegrees <= 2 {
                isRotating = false
                return inDegrees.toRads()
            }else if inDegrees > 2{
                isRotating = true
                return (inDegrees - 2).toRads()
            }
            else {
                return inDegrees.toRads()
            }
        }
        
        if inDegrees < 0 && inDegrees > -90 {
            if inDegrees >= -2 {
                isRotating = false
                return inDegrees.toRads()
            }else if inDegrees < -2 {
                isRotating = true
                return (inDegrees + 2).toRads()
            }
            else {
                return inDegrees.toRads()
            }
        }
        if inDegrees < -90 && inDegrees > -180 {
            if inDegrees <= -178 {
                isRotating = false
                return inDegrees.toRads()
            }
            else if inDegrees > -178{
                isRotating = true
                return (inDegrees - 2).toRads()
            }
            else {
                return inDegrees.toRads()
            }

        }

        else {
            isRotating = false
            return inDegrees.toRads()
        }
    }
}
