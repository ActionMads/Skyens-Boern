//
//  EdgingComponent.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 09/05/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class EdgingComponent : GKComponent {
    let groundHeight: CGFloat = 450
    let rightWall: CGFloat = 2732
    let leftWall: CGFloat = 0
    let topWall: CGFloat = 2048
    let bottomWall: CGFloat = 0
    var scene : Melody
    
    init(scene : Melody) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}
