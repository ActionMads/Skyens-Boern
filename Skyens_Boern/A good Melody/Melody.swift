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
        let gravityCompSystem = GKComponentSystem(componentClass: GravityComponent.self)
        let jollyDancingCompSystem = GKComponentSystem(componentClass: JollyDancingComponent.self)
        let jumpingCompSystem = GKComponentSystem(componentClass: JumpingAroundComponent.self)
        let edgingCompSystem = GKComponentSystem(componentClass: EdgingComponent.self)
        return [edgingCompSystem, interactionCompSystem, snappingCompSystem, gravityCompSystem, progressingCompSystem, wateringCompSystem, jollyDancingCompSystem, collectNectarComp, dryOutCompSystem, eatingCompSystem, flyCompSystem, jumpingCompSystem, spriteCompSystem]
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
    
    var timer4 : Timer?
    
    var speakTimer1 : Timer?
    
    var speakTimer2 : Timer?
    
    var speakTimer3 : Timer?
    
    var speakTimer4 : Timer?
    
    var speakTimer5 : Timer?
    
    var speakTimer6 : Timer?
    
    var hasPlayedSpeak1 : Bool = false
    
    var hasPlayedSpeak2 : Bool = false
    
   
    
    // at did move to view setup the interaction handlers
    override func didMove(to view: SKView) {
        self.setupInteractionHandlers()
    }
    
    // when scene did load make background and info elements
    override func sceneDidLoad() {
        makeBackground()
        makeStartSign()
        self.makeBackBtn()
        self.makeHelpBtn()


    }
    
    // Start game when startBtn is pushed
    override func startGame() {
        gameIsRunning = true
        self.musicPlayer.play(url: "06 En god melodi")
        startSchedual()
        timePlayed = 0
    }
    
    // Make start sign
    func makeStartSign() {
        let startSign = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startSign)
    }
    
    // start schedual of game events/transitions
    func startSchedual(){
        // make the flowers and add components to component system
        timer4 = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [self]timer in
            makeFlowerFactory()
            addSystems()
        })
        // speak timer 1
        speakTimer1 = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {timer in
            self.playSpeak(name: "En God Melodi1", length: 5)
        })
        
        // first transition make frog and water tap and bottle
        timer1 = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { [self]timer in
            print("first timer")
            if self.gameIsRunning {
                self.makeFrog()
                self.progressCircle?.component(ofType: ProgressingComponent.self)?.timer.invalidate()
                self.progressCircle?.component(ofType: ProgressingComponent.self)?.timer = nil
                self.removeEntity(entity: self.flowerFactory!)
                self.removeEntity(entity: self.progressCircle!)
                self.progressCircle = nil
                self.flowerFactory = nil
                self.canMakeFlowers = false
                self.canDryOut = true
                self.makeWaterTap()
                updateSystems()

            }
        })
        // transition 2 remove water tap, bottle and flowers add pianoBtn
        timer2 = Timer.scheduledTimer(withTimeInterval: 106, repeats: false, block: { [self]timer in
            print("second timer")
            if self.gameIsRunning {
                for flower in self.flowers {
                    removeEntity(entity: flower)
                    removeFromFlowers(entity: flower)
                }
                self.canEat = true
                self.bottle?.stateMachine = nil
                self.removeEntity(entity: self.waterTap!)
                self.removeEntity(entity: self.bottle!)
                self.makePiano()
                updateSystems()
                self.playSpeak(name: "En God Melodi12", length: 4)
                self.speakTimer6 = Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: {timer in
                    self.playSpeak(name: "En God Melodi13", length: 3)
                })
            }

        })
        // end game when music is over
        timer3 = Timer.scheduledTimer(withTimeInterval: 153, repeats: false, block: {timer in
            print("third timer")
            self.gameIsRunning = false
            self.ending()
        })
    }
    
    // scale a sprite up and down
    func Scale(sprite : SKSpriteNode, delay : TimeInterval){
        let delay = SKAction.wait(forDuration: delay)
        let scaleUp = SKAction.scale(to: 2, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let sequence = SKAction.sequence([delay, scaleUp, scaleDown])
        sprite.run(sequence)
    }
    
    // make background
    func makeBackground(){
        let background = SKSpriteNode(texture: backgroundAtlas.textureNamed("MelodiBaggrund"))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    // make a melody entity
    func makeMelody() {
        let melody = GKEntity()
        let spriteComp = SpriteComponent(atlas: pianoAtlas, name: "Node", zPos: 5)
        spriteComp.sprite.name = "Node"
        melody.addComponent(spriteComp)
        melody.addComponent(PositionComponent(currentPosition: CGPoint(x: self.frame.midX, y: 1750), targetPosition: CGPoint(x: self.frame.midX, y: 1750)))
        melody.addComponent(InteractionComponent())
        melody.addComponent(EdgingComponent(scene: self))
        entities.append(melody)
        addChild(spriteComp.sprite)
        // scale up after creation
        self.wiggle(sprite: spriteComp.sprite)
        updateSystems()
    }
    
    // make a flower target position
    func makeFlowerTargetPosition() -> CGPoint{
        let target = CGPoint(x: flowerTargetX, y: 400)
        flowerTargetX += 240
        return target
    }
    
    // make the flower btn entity
    func makeFlowerFactory(){
        flowerFactory = GKEntity()
        let spriteComp = SpriteComponent(atlas: flowerAtlas, name: "BlomsterKnap", zPos: 3)
        flowerFactory!.addComponent(spriteComp)
        let position = CGPoint(x: self.frame.midX, y: 1800)
        flowerFactory!.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        // scale up after creation
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(flowerFactory!)
        makeProgressCircle(name: "progresscircle", id: "Flower", position: position)
        addChild(spriteComp.sprite)

    }
    
    // Make a progress circle entity to run when piano or flower btn is pushed
    func makeProgressCircle(name: String, id: String, position: CGPoint){
        progressCircle = GKEntity()
        let spriteComp = SpriteComponent(atlas: progressAtlas, name: name, zPos: 5)
        spriteComp.sprite.name = id
        progressCircle!.addComponent(spriteComp)
        
        progressCircle!.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        
        progressCircle!.addComponent(ProgressingComponent(scene: self))
        
        entities.append(progressCircle!)
        addChild(spriteComp.sprite)

    }
    
    // Make a flower placement entity where flower can be placed
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
    
    // Make the piano btn with a progresscircle
    func makePiano(){
        let piano = GKEntity()
        let spriteComp = SpriteComponent(atlas: pianoAtlas, name: "PianoButton", zPos: 2)
        piano.addComponent(spriteComp)
        let position = CGPoint(x: self.frame.midX, y: 1800)
        piano.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(piano)
        makeProgressCircle(name: "pianoProgressCircle", id: "Piano", position: position)
        
    }
    
    // Make the water tap entity and call makeWaterbottle
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
    
    // Make water bottle entity with state machine
    func makeWaterBottle(tap: GKEntity){
        bottle = Bottle()
        bottle?.stateMachine = GKStateMachine(states: [RefuelingState(withEntity: bottle!, scene: self), FullState(withEntity: bottle!, scene: self), EmptyState(withEntity: bottle!, scene: self)])
        bottle?.stateMachine.enter(FullState.self)
        let spriteComp = SpriteComponent(atlas: waterAtlas, name: "Vandkande", zPos: 4)
        bottle!.addComponent(spriteComp)
        
        bottle!.addComponent(PositionComponent(currentPosition: CGPoint(x: self.frame.minX + 270, y: 1400), targetPosition: CGPoint(x: self.frame.minX + 270, y: 1400)))
        
        bottle!.addComponent(RotationComponent(currentRotation: 0, targetRotation: 0))
                        
        bottle!.addComponent(WaterComponent(scene: self))
        
        bottle!.addComponent(SnappingComponent())
        
        bottle?.addComponent(InteractionComponent())
        
        bottle?.addComponent(EdgingComponent(scene: self))
        
        bottle?.addComponent(RefuelingComponent(scene: self))
        
        addChild(spriteComp.sprite)
        self.wiggle(sprite: spriteComp.sprite)
        self.entities.append(bottle!)
    }
    
    // Make a water drop entity
    func makeDrop(x: CGFloat, y: CGFloat) {
        let drop = GKEntity()
        let spriteComp = SpriteComponent(atlas: waterAtlas, name: "Dråbe", zPos: 3)
        spriteComp.sprite.name = "drop"
        drop.addComponent(spriteComp)
        
        drop.addComponent(PositionComponent(currentPosition: CGPoint(x: x, y: y), targetPosition: CGPoint(x: x, y: y)))
        
        drop.addComponent(GravityComponent())
        
        drop.addComponent(EdgingComponent(scene: self))
        self.entities.append(drop)
        self.addChild(spriteComp.sprite)
        updateSystems()
    }
    
    // Make a bee entity
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
        updateSystems()
    }
    
    // Make the frog entity
    func makeFrog() {
        frog = GKEntity()
        let spriteComp = SpriteComponent(atlas: frogAtlas, name: "FrøNy", zPos: 6)
        spriteComp.sprite.name = "Frog"
        frog!.addComponent(spriteComp)
        frog!.addComponent(PositionComponent(currentPosition: CGPoint(x: 2500, y: self.frame.height * 0.19), targetPosition: CGPoint(x: CGFloat.random(min: 100, max: 2500), y: self.frame.height * 0.19)))
        frog!.addComponent(JumpingAroundComponent())
        frog!.addComponent(EatingComponent(scene: self))
        frog!.addComponent(JollyDancingComponent(scene: self))
        addChild(spriteComp.sprite)
        self.entities.append(frog!)
    }
    
    // Make a flower entity with parameter next placement target.
    func makeFlower(targetPosition : CGPoint){
        let flower = GKEntity()
        let spriteComp = SpriteComponent(atlas: flowerAtlas, name: "Blomst", zPos: 6)
        spriteComp.sprite.name = "flower"
        flower.addComponent(spriteComp)
        
        flower.addComponent(PositionComponent(currentPosition: CGPoint(x: 1500, y: 1750), targetPosition: targetPosition))
        flower.addComponent(DryOutComponent(scene: self))
        flower.addComponent(RotationComponent(currentRotation: 0, targetRotation: 0))
        flower.addComponent(InteractionComponent())
        flower.addComponent(SnappingComponent())
        flower.addComponent(EdgingComponent(scene: self))
        self.addChild(spriteComp.sprite)
        self.entities.append(flower)
        self.flowers.append(flower)
        if self.flowers.count == 1 {
            self.playSpeak(name: "En God Melodi2", length: 4)
        }
        if self.flowers.count == 2 {
            self.playSpeak(name: "En God Melodi7", length: 3)
        }
        makeFlowerPlacement(position: targetPosition)
        updateSystems()
        self.wiggle(sprite: spriteComp.sprite)

    }
    
    // Add component to component systems
    func addSystems(){
        for system in componentSystems {
            for entity in entities {
                system.addComponent(foundIn: entity)
            }
        }
    }
    
    // Remove all components from component systems
    func removeSystems(){
        for system in componentSystems {
            for entity in entities {
                system.removeComponent(foundIn: entity)
            }
        }
    }
    
    // Update the component systems
    func updateSystems(){
        removeSystems()
        addSystems()
    }
    
    // Check all flowers for dried out revived or died plants.
    func checkForDiedPlants() {
        for flower in flowers {
            if flower.component(ofType: DryOutComponent.self)?.isDry == true {
                if hasPlayedSpeak1 == false {
                    self.playSpeak(name: "En God Melodi8", length: 4)
                    self.speakTimer3 = Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {timer in
                        self.playSpeak(name: "En God Melodi9", length: 4)
                    })
                    hasPlayedSpeak1 = true
                }
            }
            if flower.component(ofType: DryOutComponent.self)?.isRevived == true {
                if hasPlayedSpeak2 == false {
                    self.playSpeak(name: "En God Melodi10", length: 4)
                    self.speakTimer4 = Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {timer in
                        self.playSpeak(name: "En God Melodi11", length: 4)
                    })
                    hasPlayedSpeak2 = true
                }
            }
            if flower.component(ofType: DryOutComponent.self)?.hasDied == true {
                removeEntity(entity: flower)
                removeFromFlowers(entity: flower)
                removeBee()
            }
            
        }
        updateSystems()
    }
    
    // Remove an entity from the scene
    func removeEntity(entity : GKEntity) {
        guard let index = entities.firstIndex(of: entity) else { return }
        entity.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        self.entities.remove(at: index)
    }
    
    // Remove a flower entity from the flowers array
    func removeFromFlowers(entity : GKEntity){
        guard let index = flowers.firstIndex(of: entity) else { return }
        self.flowers.remove(at: index)
    }
    
    // Remove a bee entity from the scene
    func removeBee(){
        guard let bee = bees.first else { return }
        print("Bee", bee)
        guard let index = bees.firstIndex(of: bee) else { return }
        bee.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        bee.component(ofType: CollectingNectarComponent.self)?.timer?.invalidate()
        bees.remove(at: index)
        removeEntity(entity: bee)
    }
    
    // Check if bee intersects with flower and start collecting nectar
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
    
    // Check if a flower has been placed
    func checkPlacedPlants(){
        for flower in flowers {
            if flower.component(ofType: SnappingComponent.self)?.hasSnapped == true {
                makeBee()
                if self.flowers.count == 1 {
                    self.playSpeak(name: "En God Melodi3", length: 3)
                    self.speakTimer2 = Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: {timer in
                        self.playSpeak(name: "En God Melodi4", length: 4)
                    })
                }
                if self.flowers.count == 4 {
                    self.playSpeak(name: "En God Melodi5", length: 4)
                }
                flower.removeComponent(ofType: SnappingComponent.self)
                flower.removeComponent(ofType: InteractionComponent.self)
            }
        }
        updateSystems()
    }
    
    // Stop game and present restart menu
    func restartGame(){
        gameIsRunning = false
        musicPlayer.fadeOut()
        let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(restartSign)
        playSpeakNoMusic(name: "En God Melodi17")
    }
    
    // Check if player has lost or time is up
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
    
    // Stop game and present end menu
    func ending() {
        gameIsRunning = false
        let endSign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(endSign)
        playSpeakNoMusic(name: "En God Melodi18")
        defaults.set(true, forKey: "aGoodMelodiCompleted")

    }
    
    // Check bottle states and enter correct next state
    func checkBottleState(){
        if bottle?.stateMachine.currentState is FullState && bottle?.component(ofType: WaterComponent.self)?.bottleIsEmpty == true && bottle?.component(ofType: SnappingComponent.self)?.hasSnapped == false {
            bottle?.stateMachine?.enter(EmptyState.self)
        } else if bottle?.stateMachine.currentState is RefuelingState && bottle?.component(ofType: WaterComponent.self)?.bottleIsEmpty == false {
            bottle?.stateMachine?.enter(FullState.self)
        } else if bottle?.stateMachine.currentState is EmptyState && bottle?.component(ofType: WaterComponent.self)?.bottleIsEmpty == true &&
                    bottle?.component(ofType: SnappingComponent.self)?.hasSnapped == true {
            print("snapped and entering refuelingstate")
            bottle?.stateMachine?.enter(RefuelingState.self)
        }
        updateSystems()
    }
    
    // Restart the entire scene
    override func restart() {
        self.viewController.selectScene(selectedScene: Melody(size: self.viewController.sceneSize))
    }
    
    override func willMove(from view: SKView) {
        print("Will Move from Melody")
        self.timer1?.invalidate()
        self.timer1 = nil
        self.timer2?.invalidate()
        self.timer2 = nil
        self.timer3?.invalidate()
        self.timer3 = nil
        self.timer4?.invalidate()
        self.timer4 = nil
        self.speakTimer1?.invalidate()
        self.speakTimer1 = nil
        self.speakTimer2?.invalidate()
        self.speakTimer2 = nil
        self.speakTimer3?.invalidate()
        self.speakTimer3 = nil
        self.speakTimer4?.invalidate()
        self.speakTimer4 = nil
        self.speakTimer5?.invalidate()
        self.speakTimer5 = nil
        self.speakTimer6?.invalidate()
        self.speakTimer6 = nil
        frog?.component(ofType: JumpingAroundComponent.self)?.timer1?.invalidate()
        frog?.component(ofType: JumpingAroundComponent.self)?.timer1 = nil
        frog?.component(ofType: JumpingAroundComponent.self)?.timer2?.invalidate()
        frog?.component(ofType: JumpingAroundComponent.self)?.timer2 = nil
        self.progressCircle?.component(ofType: ProgressingComponent.self)?.timer?.invalidate()
        self.progressCircle?.component(ofType: ProgressingComponent.self)?.timer = nil
        for bee in bees {
            print("removing bees")
            bee.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
            bee.component(ofType: CollectingNectarComponent.self)?.timer?.invalidate()
            bee.component(ofType: CollectingNectarComponent.self)?.timer = nil
            guard let index = bees.firstIndex(of: bee) else { return }
            bees.remove(at: index)
        }
        for entity in entities {
            print("removing entities")
            entity.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
            removeEntity(entity: entity)
        }
        for flower in flowers {
            removeFromFlowers(entity: flower)
        }
        
        flowerFactory = nil
        progressCircle = nil
        waterTap = nil
        bottle?.stateMachine = nil
        bottle = nil
        frog = nil
        self.removeAllActions()
        removeSystems()
        
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
            print("game is running")
            if bottle?.stateMachine != nil {
                checkBottleState()
            }
            checkForDiedPlants()
            checkPlacedPlants()
            lose(timePlayed: timePlayed)
            for system in componentSystems {
                system.update(deltaTime: dt)
            }
        }
        self.lastUpdateTime = currentTime

    }
    deinit {
        print(self, "has deinitialized")
    }
}
