//
//  Utils.swift
//  Dromedary
//
//  Created by Mads Munk on 06/04/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import Foundation
import CoreGraphics

// extension to the CGFloat
extension CGFloat {
    
    // Random CGFloat
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    
    }
    
    // Random CGFloat with minimun and max
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min

    }
}

//Extension to  CGPoint
extension CGPoint{
    
    // Subtract two CGPoints
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    // Multiply two CGPonits
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

// Extension CGFloat
extension CGFloat {

    // Convert .pi to degress
    func toDegrees() -> CGFloat {
        return ( self / CGFloat.pi ) * 180
    }

    // Convert .pi to Radians
    func toRads() -> CGFloat {
        return ( self / 180 ) * CGFloat.pi
    }
}
