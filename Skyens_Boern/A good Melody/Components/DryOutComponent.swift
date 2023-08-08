//
//  DryOutComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 12/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DryOutComponent : GKComponent {
    let timeToDryOut : TimeInterval = 15
    let timeToRemove : TimeInterval = 20
    var timeLeft : TimeInterval!
    let dryOutTexture : SKTexture
    let revivedTexture : SKTexture
    var hasDied : Bool = false
    var scene : Melody
    var dropsCollected : Int = 0
    var canDry : Bool = false
    var isDry : Bool = false
    var isRevived : Bool = false
    
    init(scene : Melody) {
        self.scene = scene
        timeLeft = timeToDryOut + timeToRemove
        dryOutTexture = scene.flowerAtlas.textureNamed("VisenBlomst")
        revivedTexture = scene.flowerAtlas.textureNamed("Blomst")
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTexture(texture : SKTexture) {
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {return}

        hasSprite.setTexture(texture: texture)
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
