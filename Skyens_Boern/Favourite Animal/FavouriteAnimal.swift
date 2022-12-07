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

class FavouriteAnimal : Scene {
    private var lastUpdateTime : TimeInterval = 0
    lazy var componentSystems : [GKComponentSystem] = {
        let spriteCompSystem = GKComponentSystem(componentClass: SpriteComponent.self)
        let swimmingCompSystem = GKComponentSystem(componentClass: SwimmingComponent.self)
        let fightingCompSystem = GKComponentSystem(componentClass: FightingComponent.self)
        let healthCompSystem = GKComponentSystem(componentClass: HealthComponent.self)
        let seekComSystem = GKComponentSystem(componentClass: SeekComponent.self)
        let pumpingCompSystem = GKComponentSystem(componentClass: PumpingComponent.self)
        let interActionComSystem = GKComponentSystem(componentClass: InteractionComponent.self)
        return [spriteCompSystem, swimmingCompSystem, interActionComSystem, seekComSystem, fightingCompSystem, healthCompSystem, pumpingCompSystem]
    }()
    
    var hearthBtn : GKEntity!
    var shark : Competitor!
    var croco : Competitor!
    let bathroomAtlas : SKTextureAtlas = SKTextureAtlas(named: "Bathroom")
    let competitorAtlas : SKTextureAtlas = SKTextureAtlas(named: "Competitor")
    let gameBarAtlas : SKTextureAtlas = SKTextureAtlas(named: "GameBar")
    var endTimer : Timer?
    var restartTimer : Timer?
    var seekTimer : Timer?

    
    override func sceneDidLoad() {
        makeBackground()
        makeBathtop()
        makeStartSign()
        shark = Competitor()
        croco = Competitor()
        self.makeBackBtn()
    }
    
    override func startGame(){
        musicPlayer.playMusic(url: "03 Yndlingsdyr")
        makeHearthButton()
        makeHealthBar(name: "croco", position: CGPoint(x: 100, y: 1790))
        makeHealthBar(name: "shark", position: CGPoint(x: 1700, y: 1790))
        makeShark(name: "shark", texName: "Haj lukket mund", startingPoint: CGPoint(x: 500, y: 1000), targetPoint: CGPoint(x: 1750, y: 1000), direction: "Left")
        makeCroco(name: "croco", texName: "Krokodille lukket mund", startingPoint: CGPoint(x: 2200, y: 1000), targetPoint: CGPoint(x: 950, y: 1000), direction: "Right")
        makeCrocoText()
        makeSharkText()
        gameIsRunning = true
        addSystems()
        seekAndDestroyScheduler()
    }
    
    func makeStartSign() {
        let startSign = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startSign)
    }
    
    func addSystems(){
        for system in componentSystems {
            for entity in entities {
                system.addComponent(foundIn: entity)
            }
        }
    }
    
    func seekAndDestroyScheduler(){
        seekTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {timer in
            let competitorIndex = Int.random(in: 0...1)
            var competitorToAttack : Competitor!
            if competitorIndex == 0 {
                competitorToAttack = self.croco
            }
            if competitorIndex == 1 {
                competitorToAttack = self.shark
            }
            if competitorToAttack!.stateMachine.currentState is MovingState {
                if self.croco.stateMachine.currentState is RestingState || self.shark.stateMachine.currentState is RestingState {
                    return
                }else {
                    print("Enter seek state")
                    competitorToAttack!.stateMachine.enter(SeekingState.self)
                }
            }
        })
    }
    
    func makeCrocoText(){
        let text = SKSpriteNode(texture: gameBarAtlas.textureNamed("KrokodilleTekst"))
        text.position = CGPoint(x: 400, y: 1920)
        text.size = CGSize(width: 700, height: 100)
        text.zPosition = 1
        addChild(text)
    }
    
    func makeSharkText() {
        let text = SKSpriteNode(texture: gameBarAtlas.textureNamed("TekstHaj"))
        text.size = CGSize(width: 350, height: 100)
        text.position = CGPoint(x: 1850, y: 1920)
        text.zPosition = 1
        addChild(text)
    }
    
    func makeBackground(){
        let background = SKSpriteNode(texture: bathroomAtlas.textureNamed("Yndlingsdyr_Baggrund"))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    func makeBathtop() {
        let bathTop = SKSpriteNode(texture: bathroomAtlas.textureNamed("NytBadekar"))
        bathTop.position = CGPoint(x: size.width/2, y: size.height/5)
        bathTop.zPosition = 4
        addChild(bathTop)
    }
    
    func makeHealthBar(name : String, position: CGPoint) {
        let healthBar = GKEntity()
        let healthComponent = HealthComponent(scene: self, name: name)
        healthBar.addComponent(healthComponent)
        self.entities.append(healthBar)
        var healthInBar = healthComponent.health
        var position = position
        while healthInBar != 0 {
            let healthIndicatator = GKEntity()
            let spriteComp = SpriteComponent(atlas: gameBarAtlas, name: "Liv", zPos: 3)
            healthIndicatator.addComponent(spriteComp)
            healthIndicatator.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
            self.addChild(spriteComp.sprite)
            self.entities.append(healthIndicatator)
            healthComponent.indicators.append(healthIndicatator)
            healthInBar -= 20
            position.x += 100
        }

    }
    
    func makeCroco(name : String, texName : String, startingPoint : CGPoint, targetPoint : CGPoint, direction : String) {
        croco.name = name
        croco.stateMachine = GKStateMachine(states: [MovingState(withEntity: croco), FightingState(withEntity: croco, opponent: shark), RestingState(withEntity: croco, scene: self), SeekingState(withEntity: croco, opponent: shark), GettingHitState(withEntity: croco), DieState(withEntity: croco)])
        croco.stateMachine.enter(MovingState.self)
        let spriteComp = SpriteComponent(atlas: competitorAtlas, name: texName, zPos: 3)
        spriteComp.sprite.name = name
        let positionComp = PositionComponent(currentPosition: startingPoint, targetPosition: targetPoint)
        croco.addComponent(spriteComp)
        croco.addComponent(positionComp)
        croco.addComponent(SwimmingComponent(direction: direction, leftX: 600, rightX: 950))
        croco.addComponent(FightingComponent(competitor: name, scene: self))
        croco.addComponent(HitingComponent(scene: self))
        addChild(spriteComp.sprite)
        entities.append(croco)
    }
    
    func makeShark(name : String, texName : String, startingPoint : CGPoint, targetPoint : CGPoint, direction : String) {
        shark.name = name
        shark.direction = "left"
        shark.stateMachine = GKStateMachine(states: [MovingState(withEntity: shark), FightingState(withEntity: shark, opponent: croco), RestingState(withEntity: shark, scene: self), SeekingState(withEntity: shark, opponent: croco), GettingHitState(withEntity: shark), DieState(withEntity: shark)])
        shark.stateMachine.enter(MovingState.self)
        let spriteComp = SpriteComponent(atlas: competitorAtlas, name: texName, zPos: 3)
        spriteComp.sprite.name = name
        let positionComp = PositionComponent(currentPosition: startingPoint, targetPosition: targetPoint)
        shark.addComponent(spriteComp)
        shark.addComponent(positionComp)
        shark.addComponent(SwimmingComponent(direction: direction, leftX: 1850, rightX: 2200))
        shark.addComponent(FightingComponent(competitor: name, scene: self))
        shark.addComponent(HitingComponent(scene: self))
        addChild(spriteComp.sprite)
        entities.append(shark)
    }
    
    func makeHearthButton(){
        hearthBtn = GKEntity()
        let spriteComp = SpriteComponent(atlas: gameBarAtlas, name: "Hjerte2", zPos: 3)
        spriteComp.sprite.name = "hearthBtn"
        hearthBtn!.addComponent(spriteComp)
        hearthBtn!.addComponent(PositionComponent(currentPosition: CGPoint(x: self.frame.midX, y: 1850), targetPosition: CGPoint(x: self.frame.midX, y: 1750)))
        hearthBtn!.addComponent(PumpingComponent(scene: self))
        self.entities.append(hearthBtn!)
        self.addChild(spriteComp.sprite)

    }
    
    func makeHearth() {
        let hearth = GKEntity()
        let spriteComp = SpriteComponent(atlas: gameBarAtlas, name: "Hjerte2", zPos: 4)
        spriteComp.sprite.name = "hearth"
        hearth.addComponent(spriteComp)
        hearth.addComponent(PositionComponent(currentPosition: CGPoint(x: self.frame.midX + 50, y: 1800), targetPosition: CGPoint(x: self.frame.midX + 50, y: 1800)))
        hearth.addComponent(InteractionComponent())
        self.entities.append(hearth)
        self.addChild(spriteComp.sprite)
        let scaleAction = self.scaleUpAndDown(duration: 0.2, delay: 0.3)
        spriteComp.sprite.run(scaleAction)
    }
    
    func getHealthBar(name: String) -> GKEntity {
        let healthBar = self.entities.first(where: { $0.component(ofType: HealthComponent.self)?.name == name})! 
            return healthBar
    }
    
    func scaleUpAndDown(duration : TimeInterval, delay : TimeInterval) -> SKAction {
        let wait = SKAction.wait(forDuration: delay)
        let scaleUp = SKAction.scale(to: 1.5, duration: duration)
        let scaleDown = SKAction.scale(to: 1, duration: duration)
        let printAction = SKAction.run {
            print("Finished scaling up and down")
        }
        let sequence = SKAction.sequence([wait, scaleUp, scaleDown, printAction])
        return sequence
    }
    
    func lose(){
        let crocoHealthBar = getHealthBar(name: "croco")
        guard let crocoHealth = crocoHealthBar.component(ofType: HealthComponent.self)?.health else {return}
        if crocoHealth <= 0 && croco.stateMachine.currentState is GettingHitState {
            croco.stateMachine.enter(DieState.self)
            restartTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {[self] timer in
            restartGame()
            })
        }
        let sharkHealthBar = getHealthBar(name: "shark")
        guard let sharkHealth = sharkHealthBar.component(ofType: HealthComponent.self)?.health else {return}
        if sharkHealth <= 0 && shark.stateMachine.currentState is GettingHitState{
            shark.stateMachine.enter(DieState.self)
            restartTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {[self] timer in
            restartGame()
            })
        }
    }
    
    func drown(competitor: Competitor){
        guard let spriteComponent = competitor.component(ofType: SpriteComponent.self) else {return}
        var turnAction : SKAction!
        if competitor.name == "croco" {
            turnAction = SKAction.rotate(toAngle: -.pi/2, duration: 2)
        }
        if competitor.name == "shark" {
            turnAction = SKAction.rotate(toAngle: +.pi/2, duration: 2)
        }
        let drownAction = SKAction.moveTo(y: -spriteComponent.sprite.size.height, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([turnAction, drownAction, removeAction])
        spriteComponent.sprite.run(sequence)
    }
    
    func win(){
        let crocoHealthBar = getHealthBar(name: "croco")
        guard let crocoHealth = crocoHealthBar.component(ofType: HealthComponent.self)?.health else {return}
        let sharkHealthBar = getHealthBar(name: "shark")
        guard let sharkHealth = sharkHealthBar.component(ofType: HealthComponent.self)?.health else {return}
        if !musicPlayer.isPlaying() && sharkHealth > 0 && crocoHealth > 0 {
            seekTimer?.invalidate()
            victoryDance(competitor: croco)
            victoryDance(competitor: shark)
            gameIsRunning = false
            endTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { [weak self] timer in
                self?.endGame()
            })
        }
    }
    
    func endGame(){
        print("Ending Game")
        self.croco.component(ofType: SpriteComponent.self)?.sprite.removeAction(forKey: "victoryDance")
        self.shark.component(ofType: SpriteComponent.self)?.sprite.removeAction(forKey: "victoryDance")
        let endSign = self.makeEndSign(position: CGPoint(x: (self.frame.midX), y: self.frame.midY))
        self.addChild(endSign)
    }
    
    func victoryDance(competitor : Competitor){
        guard let swimmingComp = competitor.component(ofType: SwimmingComponent.self) else {return}
        guard let spriteComponent = competitor.component(ofType: SpriteComponent.self) else {return}
        var angle : CGFloat!
        if swimmingComp.direction == "Left" {
            angle = -.pi/2
        }
        if swimmingComp.direction == "Right" {
            angle = +.pi/2
        }
        let turnAction = SKAction.rotate(toAngle: angle, duration: 0.3)
        let danceUp = SKAction.moveTo(y: spriteComponent.sprite.position.y + 30, duration: 0.1)
        let danceDown = SKAction.moveTo(y: spriteComponent.sprite.position.y - 30, duration: 0.1)
        let printAction = SKAction.run {
            print("Victory")
        }
        let danceSeq = SKAction.sequence([danceUp, danceDown])
        spriteComponent.sprite.run(turnAction)
        spriteComponent.sprite.run(.repeatForever(danceSeq), withKey: "victoryDance")
    }
    
    func handleContact() {
        guard let sharkNode = self.shark.component(ofType: SpriteComponent.self)?.sprite else {return}
        guard let crocoNode = self.croco.component(ofType: SpriteComponent.self)?.sprite else {return}
        if sharkNode.frame.intersects(crocoNode.frame) {
            if shark.stateMachine.currentState is SeekingState && croco.stateMachine.currentState is MovingState {
                shark.stateMachine.enter(FightingState.self)
                croco.stateMachine.enter(GettingHitState.self)
                
            } else if shark.stateMachine.currentState is MovingState && croco.stateMachine.currentState is SeekingState {
                croco.stateMachine.enter(FightingState.self)
                shark.stateMachine.enter(GettingHitState.self)
            } else if shark.stateMachine.currentState is RestingState && croco.stateMachine.currentState is SeekingState {
                croco.enterMovingState()
            } else if croco.stateMachine.currentState is RestingState && shark.stateMachine.currentState is SeekingState {
                shark.enterMovingState()
            }

        } else if let hearthNode = self.childNode(withName: "hearth") as? SKSpriteNode
        
            {
            if sharkNode.frame.intersects(hearthNode.frame) {
                removeEntity(entity: hearthNode.entity!)
                shark.stateMachine.enter(RestingState.self)
                increaseHealth(name: "shark")
                shark.perform(#selector(croco.enterMovingState), with: nil, afterDelay: 4.0)
            } else if crocoNode.frame.intersects(hearthNode.frame) {
                removeEntity(entity: hearthNode.entity!)
                croco.stateMachine.enter(RestingState.self)
                increaseHealth(name: "croco")
                croco.perform(#selector(croco.enterMovingState), with: nil, afterDelay: 4.0)
            }
        }
    }
    
    func increaseHealth(name : String){
        let healthBar = getHealthBar(name: name)
        guard let hasHealth = healthBar.component(ofType: HealthComponent.self) else {return}
        if hasHealth.health < 200 && hasHealth.health > 0 {
            hasHealth.health += 20
        }
    }
    
    func removeEntity(entity : GKEntity) {
        guard let index = entities.firstIndex(of: entity) else { return }
        entity.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        self.entities.remove(at: index)
    }
    
    func restartGame(){
        gameIsRunning = false
        musicPlayer.fadeOut()
        let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(restartSign)
    }
    
    override func restart(){
        self.viewController.selectScene(selectedScene: FavouriteAnimal(size: self.viewController.sceneSize))
    }
    
    override func willMove(from view: SKView) {
        print("Will move from animals")
        endTimer?.invalidate()
        endTimer = nil
        restartTimer?.invalidate()
        restartTimer = nil
        seekTimer?.invalidate()
        seekTimer = nil
        self.croco.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        self.shark.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        shark.name = nil
        shark.direction = nil
        croco.name = nil
        croco.direction = nil
        shark.stateMachine = nil
        croco.stateMachine = nil
        shark = nil
        croco = nil
        hearthBtn?.component(ofType: SpriteComponent.self)?.sprite.removeAllActions()
        hearthBtn?.component(ofType: SpriteComponent.self)?.sprite.removeFromParent()
        hearthBtn = nil
        self.removeAllActions()
        for entity in entities {
            if entity.component(ofType: SpriteComponent.self)?.name == "Haj lukket mund" || entity.component(ofType: SpriteComponent.self)?.name == "Krokodille lukket mund" {
                print("Removing state machine")
                var competitor = entity as? Competitor
                print("statemachine: ", competitor!.stateMachine)
                competitor!.stateMachine = nil
                competitor!.name = nil
                competitor!.direction = nil
                competitor = nil
                
            }
            if let hasHealthComp = entity.component(ofType: HealthComponent.self) {
                print("removing indicators")
                for indicator in hasHealthComp.indicators {
                    hasHealthComp.removeIndicator(index: 0)
                }
            }
            print("Removing entity")
            removeEntity(entity: entity)
            
        }
        print(shark)
        print(croco)

        
    }
    
    override func update(_ currentTime: TimeInterval) {
        print("previus scene: ", self.viewController.previusScene)
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        if gameIsRunning {
            for system in componentSystems {
                system.update(deltaTime: dt)
            }
            
            // Update entities
            for entity in self.entities {
                
                entity.update(deltaTime: dt)
                
            }
            handleContact()
            lose()
            win()
        }
        if !gameIsRunning {
            self.seekTimer?.invalidate()
        }
        self.lastUpdateTime = currentTime

    }
    
}
