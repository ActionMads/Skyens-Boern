//
//  EdgingComponent + Edge.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 09/05/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

import Foundation

// extension to Edging component
extension EdgingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        // Only continue if entity has these components
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else { return }
                        
        guard let spriteComponent = (entity?.component(ofType: SpriteComponent.self)) else {
            return }
        
        
        // Make the edge by comparing entity position with the different walls and set the entity position
        // to the wall position + sprite width or height
        if positionComponent.currentPosition.x < leftWall + spriteComponent.sprite.size.width/2 {
            positionComponent.currentPosition.x = leftWall + spriteComponent.sprite.size.width/2
        }
        
        if positionComponent.currentPosition.x > rightWall - spriteComponent.sprite.size.width/2 {
            positionComponent.currentPosition.x = rightWall - spriteComponent.sprite.size.width/2
        }
        
        if positionComponent.currentPosition.y > topWall - spriteComponent.sprite.size.height/2{
            positionComponent.currentPosition.y = topWall - spriteComponent.sprite.size.height/2
        }
        
        if positionComponent.currentPosition.y < bottomWall + spriteComponent.sprite.size.height/2 {
            positionComponent.currentPosition.y = bottomWall + spriteComponent.sprite.size.height/2
        }
        
        // If sprite reaching groundheight is a drop remove it
        // If sprite reaching groundheight is a flower do nothing/return
        if positionComponent.currentPosition.y < groundHeight + spriteComponent.sprite.size.height/2{
            if spriteComponent.sprite.name == "drop"{
                print("removing drop")
                scene.removeEntity(entity: spriteComponent.entity!)
            }else if spriteComponent.sprite.name == "flower"{
                return
            }
        }
    }
}

