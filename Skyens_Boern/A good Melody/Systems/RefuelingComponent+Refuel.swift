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
        print("Updating refueling")
        
        guard let hasWater = entity?.component(ofType: WaterComponent.self) else {return}
          
            if refuelTime > 0 {
                if timeSinceLastBeam >= 0.5 {
                    self.run()
                    self.timeSinceLastBeam = 0
                }
            }
            if refuelTime <= 0 {
                hasWater.dropTime = 5
                hasWater.bottleIsEmpty = false
            }
                self.refuelTime -= seconds
                self.timeSinceLastBeam += seconds
            }
        
}
