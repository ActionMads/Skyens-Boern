//
//  RefuelingComponent+Refuel.swift
//  Dromedary
//
//  Created by Mads Munk on 25/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation

extension RefuelingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        guard let hasPosition = entity?.component(ofType: PositionComponent.self) else {return}
        
        guard let hasWater = entity?.component(ofType: WaterComponent.self) else {return}
        
        if hasPosition.currentPosition == hasPosition.targetPosition {
            if refuelTIme == 4 {
                self.tap.component(ofType: RunningWaterComponent.self)?.run()
                entity?.removeComponent(ofType: InteractionComponent.self)
            }
            if refuelTIme > 0 {
                if timeSinceLastBeam >= 0.5 {
                    self.tap.component(ofType: RunningWaterComponent.self)?.run()
                    self.timeSinceLastBeam = 0
                }
            }
            if refuelTIme <= 0 {
                hasWater.dropTime = 5
                entity?.addComponent(InteractionComponent())
            }
            self.refuelTIme -= seconds
            self.timeSinceLastBeam += seconds
        }
    }
}
