//
//  ProgressingComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 15/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ProgressingComponent : GKComponent {
    var progress : Int = 0
    var name : String = ""
    var isActive : Bool = false
    var texture : SKTexture!
    var timer : Timer!
    let scene : Melody!
    
    // initialize component with scene object and start timer that increment progresscircle every 0.25 sec.
    init(scene : Melody) {
        self.scene = scene
        super.init()
        // Timer that every 0.25 seconds increments the progress
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
            self.increment()
            print("timer has fired")
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // incement the progress circle if active/pushed
    func increment() {
        if isActive {
            progress += 1
        }
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
