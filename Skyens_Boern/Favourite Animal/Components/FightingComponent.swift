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
    var fightingTechnic : Int = 0
    var canFight : Bool = true
    var isFighting : Bool = false
    var damageAmount : CGFloat = 0
    var biteTexName : String
    var attack2TexName : String
    var normalTexName : String
    let scene : FavouriteAnimal
    let wait2 = SKAction.wait(forDuration: 1)

    
    init(competitor: String, scene : FavouriteAnimal) {
        self.scene = scene
        /* set texture names */
        if competitor == "croco" {
            biteTexName = "Krokodille åben mund"
            normalTexName = "Krokodille lukket mund"
            attack2TexName = "Krokodille hale nede"
        } else {
            biteTexName = "Haj_Åben_mund"
            normalTexName = "Haj lukket mund"
            attack2TexName = "Haj hale ned"
        }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Attack opponent, by random fighting technic */
    func attack(opponent: GKEntity){
        print("Attacking")
        guard let hasSprite = self.entity?.component(ofType: SpriteComponent.self) else {return}
        self.fightingTechnic = Int.random(in: 0...1)
        if fightingTechnic == 0 {
            self.bite(sprite: hasSprite.sprite)
            opponent.component(ofType: HitingComponent.self)?.getHit(amount: 20)
        }
        else if fightingTechnic == 1 {
            //self.secondaryAttack(sprite: hasSprite.sprite)
            opponent.component(ofType: HitingComponent.self)?.getHit(amount: 40)
        }
    }
    
    /* The bite fighting technic animation*/
    func bite(sprite : SKSpriteNode) {
        let mouthOpenAction = SKAction.setTexture(scene.competitorAtlas.textureNamed(biteTexName))
        let mouthClosedAction = SKAction.setTexture(scene.competitorAtlas.textureNamed(normalTexName))
        let wait = SKAction.wait(forDuration: 0.2)
        let sequence = SKAction.sequence([mouthOpenAction, wait, mouthClosedAction, wait, mouthOpenAction, wait, mouthClosedAction, wait, mouthOpenAction, mouthClosedAction, wait, mouthOpenAction, wait, mouthClosedAction])
        damageAmount = 10
        sprite.run(sequence)
    }
    
    /* Secondary attack technic*/
    func secondaryAttack(sprite : SKSpriteNode) {
        let attack1 = SKAction.setTexture(scene.competitorAtlas.textureNamed(attack2TexName))
        let flip = SKAction.run {
            sprite.xScale = sprite.xScale * -1
        }
        let normalTex = SKAction.setTexture(scene.competitorAtlas.textureNamed(normalTexName))
        let wait = SKAction.wait(forDuration: 0.1)
        let sequence = SKAction.sequence([flip, wait, attack1, wait, normalTex, wait, flip])
        sprite.run(sequence)
        damageAmount = 20
    }
    
    deinit {
        print(self, "has deinitialized")

    }
}
