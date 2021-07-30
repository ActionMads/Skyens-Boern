//
//  Piece.swift
//  Dromedary
//
//  Created by Mads Munk on 15/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//
import Foundation
import CoreGraphics

class Piece {
    var name: String
    var targetPosition : CGPoint
    var targetRotation : CGFloat
    var zPos : CGFloat
    
    init(name: String, targetPosition: CGPoint, targetRotation: CGFloat, zPos: CGFloat) {
        self.name = name
        self.targetPosition = targetPosition
        self.targetRotation = targetRotation
        self.zPos = zPos
    }
}
