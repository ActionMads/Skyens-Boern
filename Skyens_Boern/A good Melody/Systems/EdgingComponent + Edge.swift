//
//  EdgingComponent + Edge.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 09/05/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

import Foundation

extension EdgingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else { return }
                        
        guard let spriteComponent = (entity?.component(ofType: SpriteComponent.self)) else {
            return }
        
        
        
        if positionComponent.currentPosition.x < leftWall + spriteComponent.sprite.size.width/2 {
            positionComponent.currentPosition.x = leftWall + spriteComponent.sprite.size.width/2
        }
        
        if positionComponent.currentPosition.x > rightWall - spriteComponent.sprite.size.width/2 {
            positionComponent.currentPosition.x = rightWall - spriteComponent.sprite.size.width/2
        }
        
        if positionComponent.currentPosition.y > topWall - spriteComponent.sprite.size.height/2{
            positionComponent.currentPosition.y = topWall - spriteComponent.sprite.size.height/2
        }
        
        if positionComponent.currentPosition.y <= groundHeight + spriteComponent.sprite.size.height/2{
            if spriteComponent.sprite.name == "drop"{
                print("removing drop")
                scene.removeEntity(entity: spriteComponent.entity!)
            }
            if spriteComponent.sprite.name == "flower"{
                return
            }else{
                positionComponent.currentPosition.x = groundHeight + spriteComponent.sprite.size.height/2
            }
        }
    }
}

