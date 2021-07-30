//
//  SpriteComponent.swift
//  Dromedary
//
//  Created by Mads Munk on 23/06/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//
import GameplayKit
import SpriteKit
import Foundation

class SpriteComponent : GKComponent {
    // 2.
    let sprite : SKSpriteNode
    // 3.
    init( name : String, zPos : CGFloat ) {
        self.sprite = SKSpriteNode(imageNamed: name)
        self.sprite.zPosition = zPos
        super.init()
    }
    // 4.
    override func willRemoveFromEntity() {
        self.sprite.removeFromParent()
    }
    
    func setTexture(texture: SKTexture) {
        self.sprite.texture = texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implmented")
    }
}
