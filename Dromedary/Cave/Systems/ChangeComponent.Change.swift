//
//  ChangeComponent.Change.swift
//  Dromedary
//
//  Created by Mads Munk on 05/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension ChangeComponent {
    override func update(deltaTime seconds: TimeInterval) {
        if digit == "min" {
            currentNumber = clock.component(ofType: TimeComponent.self)!.min
        }else if digit == "firstSec"{
            currentNumber = clock.component(ofType: TimeComponent.self)!.firstSec
        }else if digit == "lastSec"{
            currentNumber = clock.component(ofType: TimeComponent.self)!.lastSec
        }else if digit == "points"{
            currentNumber = scene.getCorrectPieces()
        }else{
            currentNumber = 0
        }
        
        switch self.currentNumber {
        case 0:
            currentSpriteName = "0"
            break
        case 1:
            currentSpriteName = "1"
            break
        case 2:
            currentSpriteName = "2"
            break
        case 3:
            currentSpriteName = "3"
            break
        case 4:
            currentSpriteName = "4"
            break
        case 5:
            currentSpriteName = "5"
            break
        case 6:
            currentSpriteName = "6"
            break
        case 7:
            currentSpriteName = "7"
            break
        case 8:
            currentSpriteName = "8"
            break
        case 9:
            currentSpriteName = "9"
            break
        default:
            break
        }
    }
    

}
