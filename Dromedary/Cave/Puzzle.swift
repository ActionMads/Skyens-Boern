//
//  Puzzle.swift
//  Dromedary
//
//  Created by Mads Munk on 15/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//
import CoreGraphics
import Foundation

class Puzzle {
    
    var pieces: Array<Piece>!

    
    init() {
        pieces = [Piece]()
    }
    
    
    func makePieces() -> Array<Piece> {
        let piece01: Piece = Piece(name: "Pind01", targetPosition: CGPoint(x: 1450, y: 600), targetRotation: -1.6, zPos: 6)
        pieces.append(piece01)
        
        let piece02: Piece = Piece(name: "Pind02", targetPosition: CGPoint(x: 1650, y: 600), targetRotation: -1.6, zPos: 5)
        pieces.append(piece02)
        
        let piece03: Piece = Piece(name: "Pind03", targetPosition: CGPoint(x: 1900, y: 600), targetRotation: -1.6, zPos: 4)
        pieces.append(piece03)
        
        let piece04: Piece = Piece(name: "Pind04", targetPosition: CGPoint(x: 1750, y: 800), targetRotation: 0.0, zPos: 3)
        pieces.append(piece04)
        
        let piece05: Piece = Piece(name: "Gren03", targetPosition: CGPoint(x: 1750, y: 650), targetRotation: 0.0, zPos: 7)
        pieces.append(piece05)
        
        let piece06: Piece = Piece(name: "Gren04", targetPosition: CGPoint(x: 1750, y: 500), targetRotation: 0.0, zPos: 8)
        pieces.append(piece06)
        
        return pieces
    }
}
