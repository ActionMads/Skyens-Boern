//
//  FigthingComponent + Fight.swift
//  Dromedary
//
//  Created by Mads Munk on 28/07/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation

extension FightingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        if ((self.scene.childNode(withName: "shark")?.frame.intersects(hasSprite.sprite.frame)) != nil) {
        }
        
    }
}
