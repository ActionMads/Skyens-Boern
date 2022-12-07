//
//  SwimmingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 28/07/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SwimmingComponent: GKComponent {
    let movePointsPerSec : CGFloat = 480.0
    var velocity = CGPoint.zero
    var direction : String!
    let positionTolerence : CGFloat = 20
    var hasReachedTarget : Bool = false
    var canSwim : Bool = true
    var leftX : CGFloat
    var rightX : CGFloat
    
    init(direction : String, leftX : CGFloat, rightX : CGFloat) {
        self.direction = direction
        self.leftX = leftX
        self.rightX = rightX
        super.init()
    }
    
    func swim(currentPosition: CGPoint, targetPosition : CGPoint, seconds: TimeInterval) -> CGPoint {
        let offset = CGPoint(x: targetPosition.x - currentPosition.x,
                             y: targetPosition.y - currentPosition.y)
        let length = sqrt(
       Double(offset.x * offset.x + offset.y * offset.y))
        
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * movePointsPerSec, y: direction.y * movePointsPerSec)
        
        print("direction: ", direction)
    
        let amountToMove = CGPoint(x: velocity.x * CGFloat(seconds), y: velocity.y * CGFloat(seconds))
        
        return CGPoint(x: currentPosition.x + amountToMove.x, y: currentPosition.y + amountToMove.y)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print(self, "has deinitialized")
    }
}
