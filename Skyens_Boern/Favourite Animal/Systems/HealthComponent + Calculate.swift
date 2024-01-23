//
//  HealthComponent + Calculate.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 04/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

extension HealthComponent {
    override func update(deltaTime seconds: TimeInterval) {
        healthInBar = 0
        index = 0
        
        // As long as the healt shown in the health bar is less than competitors actual health
        // add health indicatior to the healthbar by incrementing the health bar indicator index
        while healthInBar < self.health {
            index += 1
            healthInBar += 20
        }
        // Remove indicators for either crocodile or shark health bar if the index is less than the number of indicators in the health bar
            if index < indicators.count{
                // if Croco health bar from the rear of the healthbar
                if self.name == "croco"{
                    removeIndicator(index: index)
                    // if shark health bar from the beginning
                } else if self.name == "shark"{
                    removeIndicator(index: 0)
                }
            }
        // if the index is bigger than the number indicators in the health bar add an indictor
        if index > indicators.count {
            if self.name == "croco"{
                let lastIndicator = indicators.last
                guard var position = lastIndicator?.component(ofType: PositionComponent.self)?.currentPosition else {return}
                position.x += 100
                addIndicator(position: position)
            }else if self.name == "shark" {
                let firstIndicator = indicators.first
                guard var position = firstIndicator?.component(ofType: PositionComponent.self)?.currentPosition else {return}
                position.x -= 100
                addIndicator(position: position)

            }
        }
                


    }
}
