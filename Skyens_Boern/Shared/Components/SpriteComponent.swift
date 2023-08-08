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
    let name : String
    let atlas : SKTextureAtlas
    // 3.
    init(atlas : SKTextureAtlas, name : String, zPos : CGFloat ) {
        self.name = name
        self.atlas = atlas
        self.sprite = SKSpriteNode(texture: atlas.textureNamed(name))
        self.sprite.zPosition = zPos
        super.init()
    }
    // 4.
    override func willRemoveFromEntity() {
        print("removing sprite named: ", name)
        self.sprite.removeAllActions()
        self.sprite.removeFromParent()
    }
    
    override func didAddToEntity() {
        self.sprite.entity = self.entity
    }
    
    func setTexture(texture: SKTexture) {
        self.sprite.texture = texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implmented")
    }
    
    deinit {
        print(self, self.name, " has deinitialized")
    }
}
