//
//  RunningWaterComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 25/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class RunningWaterComponent: GKComponent {
    
    var scene : Melody!
    
    init(scene : Melody) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run() {
        guard let sprite = entity?.component(ofType: SpriteComponent.self) else {return}
        
        print("sprite name", sprite.sprite.name)
        
        let water = SKSpriteNode(texture: scene.waterAtlas.textureNamed("VandStråle"))
        water.position = CGPoint(x: 110, y: 0)
        water.zPosition = -1
        sprite.sprite.addChild(water)
        
        let run = SKAction.move(to: CGPoint(x: 110, y: -400), duration: 0.5)
        let remove = SKAction.run {
            water.removeAllActions()
            water.removeFromParent()
        }
        let seq = SKAction.sequence([run, remove])
        water.run(seq)
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
