//
//  CollectingNectarComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 17/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CollectingNectarComponent : GKComponent {
    var doCollect : Bool = false
    var flowerPosition: CGPoint!
    var collectArea : CGRect!
    var collectTime : TimeInterval = 2
    var flowers : [GKEntity]
    
    init(flowers : [GKEntity]) {
        self.flowers = flowers
        super.init()
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { timer in
            self.doCollect = true
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


