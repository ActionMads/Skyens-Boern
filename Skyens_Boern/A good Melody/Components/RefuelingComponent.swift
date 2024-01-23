//
//  RefuelingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 25/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class RefuelingComponent : GKComponent {
    var scene : Melody
    
    init(scene : Melody) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // reset the bottle after refuling
    func setBottleParameters(){
        guard let hasWater = entity?.component(ofType: WaterComponent.self) else {return}
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self)?.sprite else {return}
        hasWater.dropTime = 5
        hasWater.bottleIsEmpty = false
        self.scene.wiggle(sprite: hasSprite)
    }
    
    // The water refueling animation
    func run() {
        guard let sprite = entity?.component(ofType: SpriteComponent.self) else {return}
                
        let codeAction = SKAction.run {
                let water = SKSpriteNode(texture: self.scene.waterAtlas.textureNamed("Vand"))
                water.size = CGSize(width: 100, height: 200)
                water.position = CGPoint(x: 95, y: 300)
                water.zPosition = -1
                sprite.sprite.addChild(water)
                let run = SKAction.move(to: CGPoint(x: 95, y: -50), duration: 0.5)
            func remove(){
                water.removeAllActions()
                water.removeFromParent()
            }
            water.run(.repeat(run, count: 5), completion: remove)
        }
        let wait = SKAction.wait(forDuration: 0.3)
        let seq = SKAction.sequence([codeAction, wait])
        sprite.sprite.run(.repeat(seq, count: 5), completion: setBottleParameters)
        

    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
