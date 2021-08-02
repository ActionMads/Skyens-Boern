//
//  FavouriteAnimal.swift
//  Dromedary
//
//  Created by Mads Munk on 09/06/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FavouriteAnimal : SKScene {
    weak var viewController: UIViewController?
    private var lastUpdateTime : TimeInterval = 0
    var entities = [GKEntity]()
    var panRecogniser: UIPanGestureRecognizer!
    var clickRecognizer : UILongPressGestureRecognizer!
    var rotationRecogniser : UIRotationGestureRecognizer!
    var entityBeingInteractedWith : GKEntity?
    lazy var componentSystems : [GKComponentSystem] = {
        let spriteCompSystem = GKComponentSystem(componentClass: SpriteComponent.self)
        let swimmingCompSystem = GKComponentSystem(componentClass: SwimmingComponent.self)
        return [spriteCompSystem, swimmingCompSystem]
    }()

    
    override func didMove(to view: SKView) {
        setupInteractionHandlers()
    }
    
    override func sceneDidLoad() {
        makeBackground()
        makeBathtop()
        makeCompetitor(name: "shark", texName: "Haj lukket mund", startingPoint: CGPoint(x: 2200, y: 1000), targetPoint: CGPoint(x: 500, y: 1000), direction: "Left")
        makeCompetitor(name: "croco", texName: "Krokodille_Lukket_Mund", startingPoint: CGPoint(x: 500, y: 1000), targetPoint: CGPoint(x: 2200, y: 1000), direction: "Right")
    }
    
    func makeBackground(){
        let background = SKSpriteNode(imageNamed: "Yndlingsdyr_Baggrund")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    func makeBathtop() {
        let bathTop = SKSpriteNode(imageNamed: "Badekar")
        bathTop.position = CGPoint(x: size.width/2, y: size.height/5)
        bathTop.zPosition = 4
        addChild(bathTop)
    }
    
    func makeCompetitor(name : String, texName : String, startingPoint : CGPoint, targetPoint : CGPoint, direction : String) {
        let competitor = GKEntity()
        let spriteComp = SpriteComponent(name: texName, zPos: 3)
        spriteComp.sprite.name = name
        let positionComp = PositionComponent(currentPosition: startingPoint, targetPosition: targetPoint)
        competitor.addComponent(spriteComp)
        competitor.addComponent(positionComp)
        competitor.addComponent(SwimmingComponent(direction: direction))
        addChild(spriteComp.sprite)
        entities.append(competitor)
    }
    
    func topNode(  at point : CGPoint ) -> SKNode? {
        // 2.
        var topMostNode : SKNode? = nil
        // 3.
        let nodes = self.nodes(at: point)
        for node in nodes {
            // 4.
            if topMostNode == nil {
                topMostNode = node
                continue
            }
            // 5.
            if topMostNode!.zPosition < node.zPosition {
                topMostNode = node
            }
        }
        return topMostNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        for system in componentSystems {
            system.update(deltaTime: dt)
        }
        
        // Update entities
        for entity in self.entities {
            
            entity.update(deltaTime: dt)
            
        }
        self.lastUpdateTime = currentTime

    }
    
}
