//
//  ColletingNectarComponent+Collect.swift
//  Dromedary
//
//  Created by Mads Munk on 17/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit

extension CollectingNectarComponent {
    override func update(deltaTime seconds: TimeInterval) {
        if doCollect {
            print("Collect Time: ", collectTime)
            let index = Int.random(in: 0..<self.flowers.count)
            let flower = self.flowers[index]
            flowerPosition = flower.component(ofType: PositionComponent.self)?.currentPosition
            
            guard let isFlying = entity?.component(ofType: FlyComponent.self) else {return}
                        
            collectArea = CGRect(x: flowerPosition.x - 100, y: flowerPosition.y - 100, width: 200, height: 200)
                        
            isFlying.flyArea = collectArea
            collectTime -= seconds
            if collectTime <= 0 {
                doCollect = false
                collectTime = 2
                Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { timer in
                    self.doCollect = true
                })
                isFlying.flyArea = CGRect(x: 100, y: 1000, width: 2600, height: 1000)
            }
        }
        

        
        
    }
}
