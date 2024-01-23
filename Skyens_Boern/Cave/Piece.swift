//
//  Piece.swift
//  Dromedary
//
//  Created by Mads Munk on 15/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//
import Foundation
import CoreGraphics

// The piece class containing info on a puzzle piece
class Piece {
    var name: String
    var targetPosition : CGPoint
    var targetRotation : CGFloat
    var zPos : CGFloat
    var id : Int
    
    // initiate with parameters
    init(name: String, targetPosition: CGPoint, targetRotation: CGFloat, zPos: CGFloat, id : Int) {
        self.name = name
        self.id = id
        self.targetPosition = targetPosition
        self.targetRotation = targetRotation
        self.zPos = zPos
    }
}
