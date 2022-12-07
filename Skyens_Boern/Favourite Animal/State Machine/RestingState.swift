//
//  RestingState.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 13/08/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class RestingState: GKState {
    weak var entity : Competitor?
    weak var scene : FavouriteAnimal?
    
    init(withEntity : Competitor, scene : FavouriteAnimal) {
        self.entity = withEntity
        self.scene = scene
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FightingState.Type:
            return false
        case is MovingState.Type:
            return true
        case is SeekingState.Type:
            return false
        case is GettingHitState.Type:
            return false
        case is DieState.Type:
            return false
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        self.scene?.hearthBtn!.component(ofType: SpriteComponent.self)?.sprite.name = "hearthBtn"
        entity?.component(ofType: HitingComponent.self)?.isInvunreble = true
        let scaleAction = flick()
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {return}
        hasSprite.sprite.run(.repeat(scaleAction, count: 10))
        if let _ = previousState as? MovingState {
            entity?.component(ofType: SwimmingComponent.self)?.canSwim = false
        }
        else if let _ = previousState as? SeekingState {
            entity?.removeComponent(ofType: SeekComponent.self)
        }
    }
    
    private func flick() -> SKAction{
        let printAction = SKAction.run {
            print("flickering")
        }
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let sequence = SKAction.sequence([fadeOut,fadeIn])
        return sequence
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
