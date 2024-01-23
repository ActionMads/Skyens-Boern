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
    var scene : Cave
    var hasPlayedSpeak : Bool = false
    
    // initialize component and variables
    init(scene : Cave) {
        self.timeIsUp = false
        self.timeLeft = startTime
        // set min and sec to correct time units
        self.min = Int(startTime/60)
        self.firstSec = (Int(startTime) % 60) / 10
        self.lastSec = (Int(startTime) % 60) % 10
        self.scene = scene
        super.init()
        
        // fire timer every 1 sec to decrement timeleft
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.decrement()
            self.hasPlayedSpeak = false
            print("clock timer firing")
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func endTimer() {
        timer.invalidate()
    }
    
    // decremnt time left by 1
    func decrement() {
        timeLeft -= 1
    }
    
    // set min and sec value to corret time units according to the time left
    func calculateMinAndSec(){
        min = Int(timeLeft/60)
        firstSec = (Int(timeLeft) % 60) / 10
        lastSec = (Int(timeLeft) % 60) % 10
        print("Timeleft ", min, ": ", firstSec,lastSec)
    }
    deinit {
        print(self, "has deinitialized")
    }
}
