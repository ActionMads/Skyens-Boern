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

// Sprite component responsible for the entitys sprite
class SpriteComponent : GKComponent {
    // Global varibles
    let sprite : SKSpriteNode
    let name : String
    var id : Int?
    let atlas : SKTextureAtlas
    // Intialize with parameters
    init(atlas : SKTextureAtlas, name : String, zPos : CGFloat) {
        self.name = name
        self.atlas = atlas
        self.sprite = SKSpriteNode(texture: atlas.textureNamed(name))
        self.sprite.zPosition = zPos
        super.init()
    }
    // Before component is removed remove all action from SKSpriteNode and remove it from parent node
    override func willRemoveFromEntity() {
        print("removing sprite named: ", name)
        self.sprite.removeAllActions()
        self.sprite.removeFromParent()
    }
    
    // Set the SkSpriteNode entity varible to this entity
    override func didAddToEntity() {
        self.sprite.entity = self.entity
    }
    
    // set SKSpriteNode texture
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
