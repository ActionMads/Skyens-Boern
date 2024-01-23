//
//  Puzzle.swift
//  Dromedary
//
//  Created by Mads Munk on 15/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//
import CoreGraphics
import Foundation

// puzzle class
class Puzzle {
    
    // Global varibles
    var pieces: Array<Piece>!

    var greyPieces: Array<Piece>!
    
    // initiate by setting the grey and normal pices to and Array of pieces
    init() {
        pieces = [Piece]()
        greyPieces = [Piece]()
    }
    
    // make the normal puzzle pieces
    func makePieces() -> Array<Piece> {
        let piece01: Piece = Piece(name: "Pind01", targetPosition: CGPoint(x: 1450, y: 600), targetRotation: -1.6, zPos: 6, id: 1)
        pieces.append(piece01)
        
        let piece02: Piece = Piece(name: "Pind02", targetPosition: CGPoint(x: 1650, y: 600), targetRotation: -1.6, zPos: 5, id: 2)
        pieces.append(piece02)
        
        let piece03: Piece = Piece(name: "Pind03", targetPosition: CGPoint(x: 1900, y: 600), targetRotation: -1.6, zPos: 4, id: 3)
        pieces.append(piece03)
        
        let piece04: Piece = Piece(name: "Pind04", targetPosition: CGPoint(x: 1750, y: 800), targetRotation: 0.0, zPos: 3, id: 4)
        pieces.append(piece04)
        
        let piece05: Piece = Piece(name: "Gren03", targetPosition: CGPoint(x: 1750, y: 650), targetRotation: 0.0, zPos: 7, id: 5)
        pieces.append(piece05)
        
        let piece06: Piece = Piece(name: "Gren04", targetPosition: CGPoint(x: 1750, y: 500), targetRotation: 0.0, zPos: 8, id: 6)
        pieces.append(piece06)
        
        return pieces
    }
    
    // make the grey pieces for guiding
    func makeGreyPieces() -> Array<Piece> {
        let greyPiece01: Piece = Piece(name: "Pind01 Grey", targetPosition: CGPoint(x: 1450, y: 600), targetRotation: -1.6, zPos: 1, id: 1)
        greyPieces.append(greyPiece01)
        
        let greyPiece02: Piece = Piece(name: "Pind02 Grey", targetPosition: CGPoint(x: 1650, y: 600), targetRotation: -1.6, zPos: 1, id: 2)
        greyPieces.append(greyPiece02)
        
        let greyPiece03: Piece = Piece(name: "Pind03 Grey", targetPosition: CGPoint(x: 1900, y: 600), targetRotation: -1.6, zPos: 1, id: 3)
        greyPieces.append(greyPiece03)
        
        let greyPiece04: Piece = Piece(name: "Pind04 Grey", targetPosition: CGPoint(x: 1750, y: 800), targetRotation: 0.0, zPos: 1, id: 4)
        greyPieces.append(greyPiece04)
        
        let greyPiece05: Piece = Piece(name: "Gren03 Grey", targetPosition: CGPoint(x: 1750, y: 650), targetRotation: 0.0, zPos: 1, id: 5)
        greyPieces.append(greyPiece05)
        
        let greyPiece06: Piece = Piece(name: "Gren04 Grey", targetPosition: CGPoint(x: 1750, y: 500), targetRotation: 0.0, zPos: 1, id: 6)
        greyPieces.append(greyPiece06)
        
        return greyPieces
    }
}
