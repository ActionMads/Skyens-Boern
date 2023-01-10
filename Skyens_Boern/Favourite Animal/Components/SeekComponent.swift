//
//  SeekComponent.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 14/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit

class SeekComponent : GKComponent {
    
    let positionTolerence : CGFloat = 100
    var hasReachedTarget : Bool = false
    let opponent : Competitor
    let this : Competitor
    
    init(opponent : Competitor, this : Competitor) {
        self.opponent = opponent
        self.this = this
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self, "has deinitialized")
    }
}
