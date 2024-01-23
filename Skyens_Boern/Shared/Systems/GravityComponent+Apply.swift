//
//  GravityComponent+Apply.swift
//  Dromedary
//
//  Created by Mads Munk on 22/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit

// Extension/System to the gravity component
extension GravityComponent{
    override func update(deltaTime seconds: TimeInterval) {
        
        // Only continue if entity has this component
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else { return }
                
        if let interactionComponent = entity?.component(ofType: InteractionComponent.self) {
            print("interaction state ", interactionComponent.state)
            if interactionComponent.state != .none {
                return
            }
        }
        
        // Define entity position
        var position : CGPoint = positionComponent.currentPosition
        
        // If position is less than 400 set the downforce to zero else set it to 2.5
        if position.y < 400 {
            downForce = 0
        }
        else {
            downForce = 2.5
        }
        
        // Reduce the position y by the down force
        position.y -= downForce
        
        // Move the entity down by updating the current position
        positionComponent.currentPosition = position
    }
}
