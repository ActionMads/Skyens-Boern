//
//  HealthBarComponent.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 04/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class HealthComponent : GKComponent {
    var health : CGFloat = 200
    var name : String
    let scene : FavouriteAnimal
    var indicators = [GKEntity]()
    var healthInBar : CGFloat = 0
    var index = 0
    
    init(scene : FavouriteAnimal, name : String) {
        self.scene = scene
        self.name = name
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reduceHealthWith(amount : CGFloat) {
        health -= amount
    }
    
    func removeIndicator(index: Int) {
        let indicator = indicators[index]
        indicator.component(ofType: SpriteComponent.self)?.sprite.removeFromParent()
        scene.removeEntity(entity: indicator)
        indicators.remove(at: index)
    }
    
    func addIndicator(position : CGPoint){
        let indicator = GKEntity()
        let spriteComp = SpriteComponent(atlas: scene.gameBarAtlas, name: "Liv", zPos: 3)
        indicator.addComponent(spriteComp)
        indicator.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        self.scene.addChild(spriteComp.sprite)
        self.scene.entities.append(indicator)
        if self.name == "croco" {
            indicators.append(indicator)
        }
        if self.name == "shark" {
            indicators.insert(indicator, at: 0)
        }
        for system in self.scene.componentSystems {
            system.addComponent(foundIn: indicator)
        }
    }
    
    deinit {
        print(self, "has deinitialized")
    }

}


