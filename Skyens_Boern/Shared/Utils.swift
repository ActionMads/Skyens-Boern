//
//  Utils.swift
//  Dromedary
//
//  Created by Mads Munk on 06/04/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import Foundation
import CoreGraphics
    
extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    
    }
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min

    }
}

extension CGPoint{
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension CGFloat {

    // 1.
    func toDegrees() -> CGFloat {
        return ( self / CGFloat.pi ) * 180
    }

    // 2.
    func toRads() -> CGFloat {
        return ( self / 180 ) * CGFloat.pi
    }
}
