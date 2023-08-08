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
    var scene : FavouriteAnimal
    var isFirstSpeak : Bool = true
    
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
        /* Play Speak once*/
        if isFirstSpeak {
            self.scene.playSpeak(name: "Yndlingsdyr8", length: 3)
            isFirstSpeak = false
        }
        /* Activate rest animation and make competitor invunreble*/
        self.scene.hearthBtn!.component(ofType: SpriteComponent.self)?.sprite.name = "hearthBtn"
        entity?.component(ofType: HitingComponent.self)?.isInvunreble = true
        let scaleAction = flick()
        guard let hasSprite = entity?.component(ofType: SpriteComponent.self) else {return}
        hasSprite.sprite.run(.repeat(scaleAction, count: 10))
        /* If entering from MovingState disable swim*/
        if let _ = previousState as? MovingState {
            entity?.component(ofType: SwimmingComponent.self)?.canSwim = false
        }
        /* Entering from SeekingState remove SeekComponent*/
        else if let _ = previousState as? SeekingState {
            entity?.removeComponent(ofType: SeekComponent.self)
        }
    }
    
    /* Flicker animation */
    private func flick() -> SKAction{
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let sequence = SKAction.sequence([fadeOut,fadeIn])
        return sequence
    }
    
    deinit {
        print(self, "has deinitialized")
    }
    
}
