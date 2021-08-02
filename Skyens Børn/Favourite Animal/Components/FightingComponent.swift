//
//  FightingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 28/07/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FightingComponent : GKComponent {
    var fightingTechnic : Int = 1
    var canFight : Bool = true
    var damageAmount : CGFloat = 0
    let biteTexName : String
    let attack2TexName : String
    let normalTexName : String
    let scene : FavouriteAnimal
    
    init(biteTexName : String, attack2TexName : String, normalTexName : String, scene : FavouriteAnimal) {
        self.biteTexName = biteTexName
        self.attack2TexName = attack2TexName
        self.normalTexName = normalTexName
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bite(sprite : SKSpriteNode) {
        let mouthOpenAction = SKAction.setTexture(SKTexture(imageNamed: biteTexName))
        let mouthClosedAction = SKAction.setTexture(SKTexture(imageNamed: normalTexName))
        let wait = SKAction.wait(forDuration: 0.2)
        let sequence = SKAction.sequence([mouthOpenAction, wait, mouthClosedAction])
        sprite.run(.repeat(sequence, count: 4))
    }
}
