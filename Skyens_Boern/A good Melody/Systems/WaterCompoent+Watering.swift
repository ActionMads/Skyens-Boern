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
                
        guard let hasRotation = entity?.component(ofType: RotationComponent.self) else {return}
        
        guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {return}
        
        print("bottle degress", hasRotation.currentRotation)
        print("bottle is empty", bottleIsEmpty)
        
        if hasRotation.currentRotation <= self.waterTolerenceMax && hasRotation.currentRotation > self.waterTolerenceMin {
            
            if dropTime > 0 {
                if timeSinceLastDrop >= 0.5 {
                    self.scene.makeDrop(x: CGFloat.random(min: hasPosition.currentPosition.x - 200, max: hasPosition.currentPosition.x + 50) , y: hasPosition.currentPosition.y - 150)
                    print("make drop at:", timeSinceLastDrop)
                    self.timeSinceLastDrop = 0
                }
                dropTime -= seconds
                print("drop time ", dropTime)
                if dropTime <= 0 {
                    bottleIsEmpty = true
                }
            }
        }

        
    }
}
