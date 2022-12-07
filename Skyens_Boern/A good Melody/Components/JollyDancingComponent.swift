//
//  JollyDancingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 07/04/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class JollyDancingComponent : GKComponent {
    
    var dancingTime : TimeInterval = 5
    var scene : Melody
    var isDancing : Bool = false
    
    init(scene : Melody) {
        self.scene = scene
        super.init()
    }
    
    func dance(){
        print("Dancing")
        let danceTex = SKAction.setTexture(scene.frogAtlas.textureNamed("FrøDansende"))
        let wait = SKAction.wait(forDuration: 0.2)
        let normalTex = SKAction.setTexture(scene.frogAtlas.textureNamed("Frø-Small"))
        let animation = SKAction.sequence([danceTex, wait, normalTex, wait, danceTex, wait, normalTex, wait, danceTex, wait, normalTex, wait, danceTex, wait, normalTex, wait, danceTex, wait, normalTex])
        self.scene.childNode(withName: "Frog")?.run((animation))
    }
    
    func setTexture(texture : SKTexture, direction : String){
        let spriteComp = entity?.component(ofType: SpriteComponent.self)
        spriteComp?.setTexture(texture: texture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}
