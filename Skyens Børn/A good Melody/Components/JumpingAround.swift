//
//  JumpingAround.swift
//  Dromedary
//
//  Created by Mads Munk on 17/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class JumpingAroundComponent : GKComponent {
    var hasReachedTarget = false
    let movePointsPerSec : CGFloat = 240.0
    var velocity = CGPoint.zero
    let positionTolerence : CGFloat = 20
    var direction : String = "Left"
    var canJump : Bool = false
    var sprite : SKSpriteNode!
    
    override init() {
        super.init()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {timer in
            self.canJump = true
            self.jump()
        })
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {timer in
            self.canJump = false
            if let spriteComp = self.entity?.component(ofType: SpriteComponent.self)?.sprite {
                spriteComp.removeAllActions()

            }

            
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jump() {
        if entity?.component(ofType: EatingComponent.self)?.isEating == false && entity?.component(ofType: JollyDancingComponent.self)?.isDancing == false {
            sprite = self.entity?.component(ofType: SpriteComponent.self)?.sprite
            let jumpUp = SKAction.run {
                let position = self.entity?.component(ofType: PositionComponent.self)
                position?.currentPosition.y += 20
            }
            
            let land = SKAction.run {
                let position = self.entity?.component(ofType: PositionComponent.self)
                position?.currentPosition.y -= 20
            }
            let wait = SKAction.wait(forDuration: 0.05)
            let sequence = SKAction.sequence([jumpUp, wait, jumpUp, wait, jumpUp, wait, jumpUp, wait, jumpUp, wait, land, wait, land, wait, land, wait, land, wait, land])
            sprite?.run(sequence)
        }

    }
}


