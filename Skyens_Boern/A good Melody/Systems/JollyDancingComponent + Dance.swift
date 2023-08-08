//
//  JollyDancingComponent + Dance.swift
//  Dromedary
//
//  Created by Mads Munk on 07/04/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit

extension JollyDancingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        /* If entity has the following components continue */
        
        guard let hasEating = self.entity?.component(ofType: EatingComponent.self) else {return}
        
        guard let hasJumping = self.entity?.component(ofType: JumpingAroundComponent.self) else {return}
        
        guard let hasPosition = self.entity?.component(ofType: PositionComponent.self) else {return}
        
        // eating do nothing
        if hasEating.isEating {
            return
        }
        
        // If the frog is dancing reduce dancing time left
        if self.isDancing {
            self.dancingTime -= seconds
        }
        
        guard let hasSprite = self.entity?.component(ofType: SpriteComponent.self) else {return}
        
        // enumarate the melody nodes and if they intersect with frog activate the dancing animation
        if let melody = self.scene.childNode(withName: "Node") {
            if melody.frame.intersects(hasSprite.sprite.frame){
                self.isDancing = true
                for system in self.scene.componentSystems {
                    system.removeComponent(foundIn: melody.entity!)
                }
                self.scene.removeEntity(entity: melody.entity!)

            }
        }
        
        // dancing animation steps
        if self.isDancing {
            if self.dancingTime <= 5 && self.dancingTime > 4.9{
                if isFirstDance {
                    self.scene.playSpeak(name: "En God Melodi15", length: 4)
                }
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y + 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }
                
            }
            if self.dancingTime <= 4.5 && self.dancingTime > 4.4{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y - 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 4 && self.dancingTime > 3.9{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y + 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 3.5 && self.dancingTime > 3.4{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y - 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }


            }
            if self.dancingTime <= 3 && self.dancingTime > 2.9{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y + 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 2.5 && self.dancingTime > 2.4{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y - 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 2 && self.dancingTime > 1.9{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y + 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 1.5 && self.dancingTime > 1.4{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y - 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 1 && self.dancingTime > 0.9{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøDansende"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 395))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y + 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 0.5 && self.dancingTime > 0.4{
                self.setTexture(texture: scene.frogAtlas.textureNamed("FrøNy"), direction: hasJumping.direction)
                hasSprite.sprite.scale(to: CGSize(width: 500, height: 277))
                hasPosition.currentPosition = CGPoint(x: hasPosition.currentPosition.x, y: hasPosition.currentPosition.y - 15)
                if hasJumping.direction == "Right" {
                    hasSprite.sprite.xScale = hasSprite.sprite.xScale * -1
                }

            }
            if self.dancingTime <= 0{
                if isFirstDance {
                    self.scene.playSpeak(name: "En God Melodi16", length: 4)
                    isFirstDance = false
                }
                self.isDancing = false
                self.dancingTime = 5
            }
        }
    }
}
