//
//  Melody.swift
//  Dromedary
//
//  Created by Mads Munk on 11/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import SpriteKit
import GameplayKit

class Melody: Scene {
    private var lastUpdateTime : TimeInterval = 0
    lazy var componentSystems : [GKComponentSystem] = {
        let spriteCompSystem = GKComponentSystem(componentClass: SpriteComponent.self)
        let flyCompSystem = GKComponentSystem(componentClass: FlyComponent.self)
        let interactionCompSystem = GKComponentSystem(componentClass: InteractionComponent.self)
        let snappingCompSystem = GKComponentSystem(componentClass: SnappingComponent.self)
        let dryOutCompSystem = GKComponentSystem(componentClass: DryOutComponent.self)
        let progressingCompSystem = GKComponentSystem(componentClass: ProgressingComponent.self)
        let collectNectarComp = GKComponentSystem(componentClass: CollectingNectarComponent.self)
        let eatingCompSystem = GKComponentSystem(componentClass: EatingComponent.self)
        let wateringCompSystem = GKComponentSystem(componentClass: WaterComponent.self)
        let refuelingCompSystem = GKComponentSystem(componentClass: RefuelingComponent.self)
        return [progressingCompSystem, interactionCompSystem, collectNectarComp, dryOutCompSystem, eatingCompSystem, snappingCompSystem, flyCompSystem, refuelingCompSystem, spriteCompSystem]
    }()

    var progressCircle: GKEntity?
    
    var bees = [GKEntity]()
    
    var flowers = [GKEntity]()
    
    var frog : GKEntity?
    
    var waterTap : GKEntity?
    
    var bottle : Bottle?
    
    var canEat : Bool = false
        
    var flowerTargetX = 120
    
    var flowerFactory : GKEntity?
    
    var canDryOut : Bool = false
    
    var beeHasBeenCreated : Bool = false
    
    var timePlayed : TimeInterval = 0
        
    var canMakeFlowers : Bool = true
    
    let backgroundAtlas : SKTextureAtlas = SKTextureAtlas(named: "MelodyBackground")
    
    let beesAtlas : SKTextureAtlas = SKTextureAtlas(named: "Bees")
    
    let frogAtlas : SKTextureAtlas = SKTextureAtlas(named: "Frog")
    
    let flowerAtlas : SKTextureAtlas = SKTextureAtlas(named: "Flowers")
    
    let pianoAtlas : SKTextureAtlas = SKTextureAtlas(named: "Piano")
    
    let waterAtlas : SKTextureAtlas = SKTextureAtlas(named: "Water")
    
    let progressAtlas : SKTextureAtlas = SKTextureAtlas(named: "Progress")
    
    var timer1 : Timer?
    
    var timer2 : Timer?
    
    var timer3 : Timer?
    
    
    override func didMove(to view: SKView) {
        self.setupInteractionHandlers()
        addSystems()
    }
    
    override func sceneDidLoad() {
        makeBackground()
        makeStartSign()
        self.makeBackBtn()
    }
    
    override func startGame() {
        gameIsRunning = true
        self.musicPlayer.playMusic(url: "06 En god melodi")
        startSchedual()
        makeFlowerFactory()
        timePlayed = 0
    }
    
    func makeStartSign() {
        let startSign = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startSign)
    }
    
    func startSchedual(){
        timer1 = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: {timer in
            print("first timer")
            if self.gameIsRunning {
                self.makeFrog()
                self.progressCircle?.component(ofType: ProgressingComponent.self)?.timer.invalidate()
                self.removeEntity(entity: self.flowerFactory!)
                self.removeEntity(entity: self.progressCircle!)
                self.canMakeFlowers = false
                self.canDryOut = true
                self.makeWaterTap()
            }
        })
        timer2 = Timer.scheduledTimer(withTimeInterval: 106, repeats: false, block: { [self]timer in
            print("second timer")
            if self.gameIsRunning {
                for flower in self.flowers {
                    removeEntity(entity: flower)
                    removeFromFlowers(entity: flower)
                }
                self.canEat = true
                self.removeEntity(entity: self.waterTap!)
                self.removeEntity(entity: self.bottle!)
                self.makePiano()
            }

        })
        timer3 = Timer.scheduledTimer(withTimeInterval: 153, repeats: false, block: {timer in
            print("third timer")
            self.gameIsRunning = false
            self.ending()
        })
    }
    
    func Scale(sprite : SKSpriteNode, delay : TimeInterval){
        let delay = SKAction.wait(forDuration: delay)
        let scaleUp = SKAction.scale(to: 2, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let sequence = SKAction.sequence([delay, scaleUp, scaleDown])
        sprite.run(sequence)
    }
    
    func makeBackground(){
        let background = SKSpriteNode(texture: backgroundAtlas.textureNamed("MelodiBaggrund"))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    func makeMelody() {
        let melody = GKEntity()
        let spriteComp = SpriteComponent(atlas: pianoAtlas, name: "Node", zPos: 5)
        spriteComp.sprite.name = "Node"
        melody.addComponent(spriteComp)
        melody.addComponent(PositionComponent(currentPosition: CGPoint(x: self.frame.midX, y: 1750), targetPosition: CGPoint(x: self.frame.midX, y: 1750)))
        melody.addComponent(InteractionComponent())
        melody.addComponent(EdgingComponent(scene: self))
        Scale(sprite: spriteComp.sprite, delay: 0)
        entities.append(melody)
        addChild(spriteComp.sprite)

    }
/*
    func makeFlowers(){
        for _ in 1...5 {
            makeFlower(targetPosition: CGPoint(x: CGFloat.random(min: 100, max: 2500), y: 500))
        }
    }*/
    
    func makeFlowerTargetPosition() -> CGPoint{
        let target = CGPoint(x: flowerTargetX, y: 400)
        flowerTargetX += 240
        return target
    }
    
    func makeFlowerFactory(){
        flowerFactory = GKEntity()
        let spriteComp = SpriteComponent(atlas: flowerAtlas, name: "BlomsterKnap", zPos: 2)
        flowerFactory!.addComponent(spriteComp)
        let position = CGPoint(x: self.frame.midX, y: 1800)
        flowerFactory!.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(flowerFactory!)
        makeProgressCircle(name: "progresscircle", id: "Flower", position: position)
    }
    
    func makeProgressCircle(name: String, id: String, position: CGPoint){
        progressCircle = GKEntity()
        let spriteComp = SpriteComponent(atlas: progressAtlas, name: name, zPos: 4)
        spriteComp.sprite.name = id
        progressCircle!.addComponent(spriteComp)
        
        progressCircle!.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        
        progressCircle!.addComponent(ProgressingComponent(scene: self))
        
        addChild(spriteComp.sprite)
        entities.append(progressCircle!)
    }
    
    func makeFlowerPlacement(position : CGPoint){
        let place = GKEntity()
        let pos = CGPoint(x: position.x, y: position.y - 130)
        let spriteComp = SpriteComponent(atlas: flowerAtlas, name: "BlomstPlacering", zPos: 6)
        place.addComponent(spriteComp)
        place.addComponent(PositionComponent(currentPosition: pos, targetPosition: pos))
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(place)
    }
    
    func makePiano(){
        let piano = GKEntity()
        let spriteComp = SpriteComponent(atlas: pianoAtlas, name: "PianoButton", zPos: 2)
        piano.addComponent(spriteComp)
        let position = CGPoint(x: self.frame.midX, y: 1800)
        piano.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(piano)
        makeProgressCircle(name: "", id: "Piano", position: position)
    }
    
    func makeWaterTap(){
        waterTap = GKEntity()
        let spriteComp = SpriteComponent(atlas: waterAtlas, name: "Vandhane", zPos: 4)
        spriteComp.sprite.size = CGSize(width: 500, height: 500)
        waterTap!.addComponent(spriteComp)
        waterTap!.addComponent(PositionComponent(currentPosition: CGPoint(x: self.frame.minX + 240, y: self.frame.maxY - 250), targetPosition: CGPoint(x: self.frame.minX + 240, y: self.frame.maxY - 250)))
        self.addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        self.entities.append(waterTap!)
        makeWaterBottle(tap: waterTap!)
    }
    
    func makeWaterBottle(tap: GKEntity){
        bottle = Bottle()
        bottle?.stateMachine = GKStateMachine(states: [RefuelingState(withEntity: bottle!, scene: self), FullState(withEntity: bottle!), EmptyState(withEntity: bottle!)])
        bottle?.stateMachine.enter(FullState.self)
        let spriteComp = SpriteComponent(atlas: waterAtlas, name: "Vandkande", zPos: 4)
        bottle!.addComponent(spriteComp)
        
        bottle!.addComponent(PositionComponent(currentPosition: CGPoint(x: self.frame.minX + 270, y: 1400), targetPosition: CGPoint(x: self.frame.minX + 270, y: 1400)))
        
        bottle!.addComponent(RotationComponent(currentRotation: 0, targetRotation: 0))
                        
        bottle!.addComponent(WaterComponent(scene: self))
        
        bottle!.addComponent(SnappingComponent())
        
        bottle?.addComponent(InteractionComponent())
        
        bottle?.addComponent(EdgingComponent(scene: self))
        
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        self.entities.append(bottle!)
    }
    
    func makeDrop(x: CGFloat, y: CGFloat) {
        let drop = GKEntity()
        let spriteComp = SpriteComponent(atlas: waterAtlas, name: "Dråbe", zPos: 3)
        spriteComp.sprite.name = "drop"
        drop.addComponent(spriteComp)
        
        drop.addComponent(PositionComponent(currentPosition: CGPoint(x: x, y: y), targetPosition: CGPoint(x: x, y: y)))
        
        drop.addComponent(GravityComponent())
        
        drop.addComponent(EdgingComponent(scene: self))
        
        self.addChild(spriteComp.sprite)
        self.entities.append(drop)
    }
    
    func makeBee() {
        let bee = GKEntity()
        let spriteComp = SpriteComponent(atlas: beesAtlas, name: "Bi-Small", zPos: 2)
        spriteComp.sprite.name = "Bi-Small"
        bee.addComponent(spriteComp)
        
        bee.addComponent(PositionComponent(currentPosition: CGPoint(x: CGFloat.random(min: 150, max: 2500), y: CGFloat.random(min: 1500, max: 1900)), targetPosition: CGPoint(x: CGFloat.random(min: 150, max: 2500), y: CGFloat.random(min: 1500, max: 1900))))
        
        bee.addComponent(FlyComponent(scene: self))
        bee.addComponent(CollectingNectarComponent(flowers: self.flowers))
                
        self.addChild(spriteComp.sprite)
        self.entities.append(bee)
        self.bees.append(bee)
        beeHasBeenCreated = true
    }
    
    func makeFrog() {
        frog = GKEntity()
        let spriteComp = SpriteComponent(atlas: frogAtlas, name: "FrøNy", zPos: 6)
        spriteComp.sprite.name = "Frog"
        frog!.addComponent(spriteComp)
        frog!.addComponent(PositionComponent(currentPosition: CGPoint(x: 2500, y: 400), targetPosition: CGPoint(x: CGFloat.random(min: 100, max: 2500), y: 400)))
        frog!.addComponent(JumpingAroundComponent())
        frog!.addComponent(EatingComponent(scene: self))
        frog!.addComponent(JollyDancingComponent(scene: self))
        addChild(spriteComp.sprite)
        self.entities.append(frog!)
    }
    
    func makeFlower(targetPosition : CGPoint){
        let flower = GKEntity()
        let spriteComp = SpriteComponent(atlas: flowerAtlas, name: "Blomst", zPos: 5)
        spriteComp.sprite.name = "flower"
        flower.addComponent(spriteComp)
        
        flower.addComponent(PositionComponent(currentPosition: CGPoint(x: 1500, y: 1750), targetPosition: targetPosition))
        flower.addComponent(DryOutComponent(scene: self))
        flower.addComponent(RotationComponent(currentRotation: 0, targetRotation: 0))
        flower.addComponent(InteractionComponent())
        flower.addComponent(SnappingComponent())
        flower.addComponent(EdgingComponent(scene: self))
        self.addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 0)
        self.entities.append(flower)
        self.flowers.append(flower)
        makeFlowerPlacement(position: targetPosition)
    }
    
    func addSystems(){
        for system in componentSystems {
            for entity in entities {
                system.addComponent(foundIn: entity)
            }
        }
    }
    
    func checkForDiedPlants() {
        for flower in flowers {
                if flower.component(ofType: DryOutComponent.self)?.hasDied == true {
                    removeEntity(entity: flower)
                    removeFromFlowers(entity: flower)
                    removeBee()
                }
        }
    }
    
    func removeEntity(entity : GKEntity) {
        guard let index = entities.firstIndex(of: entity) else { return }
        entity.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        self.entities.remove(at: index)
    }
    
    func removeFromFlowers(entity : GKEntity){
        guard let index = flowers.firstIndex(of: entity) else { return }
        self.flowers.remove(at: index)
    }
    
    func removeBee(){
        guard let bee = bees.first else { return }
        print("Bee", bee)
        guard let index = bees.firstIndex(of: bee) else { return }
        bee.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        bee.component(ofType: CollectingNectarComponent.self)?.timer?.invalidate()
        bees.remove(at: index)
        removeEntity(entity: bee)
    }
    
    func checkBeeStatus(){
        self.enumerateChildNodes(withName: "Bi-Small") {node, _ in
            let bee = node as! SKSpriteNode
            print("enumerating")
            if let flower = self.childNode(withName: "Blomst") as? SKSpriteNode {
                if flower.frame.intersects(bee.frame) {
                    let collectComp = bee.entity?.component(ofType: CollectingNectarComponent.self)
                    if collectComp?.doCollect == false {
                        collectComp?.flowerPosition = flower.position
                        collectComp?.doCollect = true
                    }
                }
            }
        }
    }
    
    func checkPlacedPlants(){
        for flower in flowers {
            if flower.component(ofType: SnappingComponent.self)?.hasSnapped == true {
                makeBee()
                flower.removeComponent(ofType: SnappingComponent.self)
                flower.removeComponent(ofType: InteractionComponent.self)
            }
        }
    }
    
    func restartGame(){
        gameIsRunning = false
        musicPlayer.fadeOut()
        self.isPaused = true
        let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(restartSign)
    }
    
    func lose(timePlayed : TimeInterval) {
        if beeHasBeenCreated {
            if bees.count == 0{
               restartGame()
            }
        }else {
            print("updateTime: ", timePlayed)
            if timePlayed >= 30 {
                restartGame()
            }
        }
    }
    
    func ending() {
        let endSign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(endSign)
    }
    
    func checkBottleState(){
        print("state", bottle?.stateMachine.currentState)
        if bottle?.component(ofType: WaterComponent.self)?.bottleIsEmpty == true && bottle?.component(ofType: SnappingComponent.self)?.hasSnapped == false {
            bottle?.stateMachine.enter(EmptyState.self)
        } else if bottle?.component(ofType: WaterComponent.self)?.bottleIsEmpty == false {
            bottle?.stateMachine.enter(FullState.self)
        } else if bottle?.component(ofType: WaterComponent.self)?.bottleIsEmpty == true &&
                    bottle?.component(ofType: SnappingComponent.self)?.hasSnapped == true {
            print("snapped")
            bottle?.stateMachine.enter(RefuelingState.self)
        }
    }
    
    override func restart() {
        self.viewController.selectScene(selectedScene: Melody(size: self.viewController.sceneSize))
    }
    
    override func willMove(from view: SKView) {
        print("Will Move from Melody")
        timer1?.invalidate()
        timer1 = nil
        timer2?.invalidate()
        timer2 = nil
        timer3?.invalidate()
        timer3 = nil
        for bee in bees {
            print("removing bees")
            bee.component(ofType: CollectingNectarComponent.self)?.timer?.invalidate()
            bee.component(ofType: SpriteComponent.self)?.sprite.removeAllActions()
            guard let index = bees.firstIndex(of: bee) else { return }
            bees.remove(at: index)
        }
        for entity in entities {
            print("removing entities")
            entity.component(ofType: ProgressingComponent.self)?.timer.invalidate()
            removeEntity(entity: entity)
        }
        for flower in flowers {
            print("Removing flowers")
            flower.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
            removeFromFlowers(entity: flower)
        }
        frog?.component(ofType: JumpingAroundComponent.self)?.timer1?.invalidate()
        frog?.component(ofType: JumpingAroundComponent.self)?.timer2?.invalidate()
        self.progressCircle?.component(ofType: ProgressingComponent.self)?.timer.invalidate()
        flowerFactory = nil
        progressCircle = nil
        waterTap = nil
        bottle?.stateMachine = nil
        bottle = nil
        frog = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        print("gameloop running", currentTime)
        timePlayed += dt
        if gameIsRunning {
            checkBottleState()
            checkForDiedPlants()
            checkPlacedPlants()
            lose(timePlayed: timePlayed)

            for system in componentSystems {
                system.update(deltaTime: dt)
            }

            // Update entities
            for entity in self.entities {
                entity.update(deltaTime: dt)
            }


        }
        self.lastUpdateTime = currentTime

    }
}
