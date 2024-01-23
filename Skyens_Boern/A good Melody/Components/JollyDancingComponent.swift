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
    var isFirstDance : Bool = true
    
    // initalize component with parameter Melody scene
    init(scene : Melody) {
        self.scene = scene
        super.init()
    }
    
    // set testure of sprite
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
