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
        while healthInBar < self.health {
            index += 1
            healthInBar += 20
        }
            if index < indicators.count{
                if self.name == "croco"{
                    removeIndicator(index: index)
                } else if self.name == "shark"{
                    removeIndicator(index: 0)
                }
            }
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
