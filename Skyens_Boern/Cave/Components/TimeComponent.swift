//
//  TimeComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 03/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TimeComponent: GKComponent {
    let startTime : TimeInterval = 134
    let stopTime: TimeInterval = 0
    var timeLeft : TimeInterval
    var min : Int
    var firstSec : Int
    var lastSec : Int
    var timer : Timer!
    var timeIsUp : Bool
    
    override init() {
        self.timeIsUp = false
        self.timeLeft = startTime
        self.min = Int(startTime/60)
        self.firstSec = (Int(startTime) % 60) / 10
        self.lastSec = (Int(startTime) % 60) % 10
        super.init()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.decrement()
        })
        timer.fire()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func endTimer() {
        timer.invalidate()
    }
    
    func decrement() {
        timeLeft -= 1
    }
    
    func calculateMinAndSec(){
        min = Int(timeLeft/60)
        firstSec = (Int(timeLeft) % 60) / 10
        lastSec = (Int(timeLeft) % 60) % 10
        print("Timeleft ", min, ": ", firstSec,lastSec)
    }
}
