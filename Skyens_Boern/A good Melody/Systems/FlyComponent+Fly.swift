//
//  FlyComponent+Fly.swift
//  Dromedary
//
//  Created by Mads Munk on 11/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension FlyComponent {
    
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if canFly {
            
            /* If entity has the following components continue */
            guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {
                return}
            
            guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {return}
            
            /* If first time in updateloop */
            if self.isFirstRun {
                print("Bee Position", hasPosition.currentPosition)
                print("Bee Target", hasPosition.targetPosition)
                print("Bee xScale", hasSprite.sprite.xScale)
                // if bee position is less than target position flip bee sprite
                if hasPosition.targetPosition.x > hasPosition.currentPosition.x {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                    self.direction = "Right"
                    print("Bee xScale from if", hasSprite.sprite.xScale)
                    print("Bee Direction", self.direction)
                }
                self.isFirstRun = false
                // Make fly animation and run it
                let flyAction01 = SKAction.setTexture(scene.beesAtlas.textureNamed("Bi-Small"))
                let flyAction02 = SKAction.setTexture(scene.beesAtlas.textureNamed("Bi-Small-vinge nede"))
                let wait = SKAction.wait(forDuration: 0.05)
                let printAction = SKAction.run {
                    print("Flying")
                }
                let sequence = SKAction.sequence([printAction, flyAction01, wait, flyAction02, wait])
                hasSprite.sprite.run(.repeatForever(sequence), withKey: "Fly")
                
            }
            
            // calculate vector and hypotinus and if hyp is less then position tolerence the bee has reached target
            
            let vector = hasPosition.currentPosition - hasPosition.targetPosition
            
            let hyp = sqrt(( vector.x * vector.x ) + (vector.y + vector.y))
            
            if hyp < self.positionTolerence {
                hasReachedTarget = true
            }
            
            // if the bee has reached it current target make a new random target and flip the bee sprite according to direction
            if hasReachedTarget == true {
                hasPosition.targetPosition = CGPoint(x: CGFloat.random(min: flyArea.minX, max: self.flyArea.maxX), y: CGFloat.random(min: self.flyArea.minY, max: self.flyArea.maxY))
                hasReachedTarget = false
                if hasPosition.targetPosition.x > hasPosition.currentPosition.x && self.direction == "Left" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                    self.direction = "Right"
                } else if hasPosition.targetPosition.x < hasPosition.currentPosition.x && self.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                    self.direction = "Left"
                }
                print("Bee xScale after reached target", hasSprite.sprite.xScale)
                
                
            }
            
            // if the bee is on the way to a target move the bee towards it
            if hasReachedTarget == false {
                let offset = CGPoint(x: hasPosition.targetPosition.x - hasPosition.currentPosition.x,
                                     y: hasPosition.targetPosition.y - hasPosition.currentPosition.y)
                let length = sqrt(
                    Double(offset.x * offset.x + offset.y * offset.y))
                
                let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
                velocity = CGPoint(x: direction.x * movePointsPerSec, y: direction.y * movePointsPerSec)
                
                print("direction: ", direction)
                
                let amountToMove = CGPoint(x: velocity.x * CGFloat(seconds), y: velocity.y * CGFloat(seconds))
                
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x + amountToMove.x, y: hasPosition.currentPosition.y + amountToMove.y)
            }
        }
    }
}
