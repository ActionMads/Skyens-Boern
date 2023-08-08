//
//  WaterCompoent+Watering.swift
//  Dromedary
//
//  Created by Mads Munk on 24/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

extension WaterComponent {
    override func update(deltaTime seconds: TimeInterval) {
                    
        self.timeSinceLastDrop += seconds
         
        /* If entity has the following components continue */
        
        guard let hasRotation = entity?.component(ofType: RotationComponent.self) else {return}
        
        guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {return}
        
        print("bottle degress", hasRotation.currentRotation)
        print("bottle is empty", bottleIsEmpty)
        
        // if the bottle is rotatet within min and max of tolerence start watering
        if hasRotation.currentRotation <= self.waterTolerenceMax && hasRotation.currentRotation > self.waterTolerenceMin {
            
            // as long as drop time is bigger than 0 make a drop every 0.5 sec
            if dropTime > 0 {
                if timeSinceLastDrop >= 0.5 {
                    self.scene.makeDrop(x: CGFloat.random(min: hasPosition.currentPosition.x - 200, max: hasPosition.currentPosition.x + 50) , y: hasPosition.currentPosition.y - 150)
                    print("make drop at:", timeSinceLastDrop)
                    self.timeSinceLastDrop = 0
                }
                dropTime -= seconds
                print("drop time ", dropTime)
                // if drop time is less than or equal to 0 the bottle is empty and must be refueled
                if dropTime <= 0 {
                    bottleIsEmpty = true
                }
            }
        }

        
    }
}
