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

extension GravityComponent{
    override func update(deltaTime seconds: TimeInterval) {
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else { return }
        
        if let interactionComponent = entity?.component(ofType: InteractionComponent.self) {
            if interactionComponent.state != .none {
                return
            }
        }
        
        var position : CGPoint = positionComponent.currentPosition
        
        position.y -= downForce
        
        positionComponent.currentPosition = position
    }
}
