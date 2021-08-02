//
//  Melody.swift
//  Dromedary
//
//  Created by Mads Munk on 11/02/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import SpriteKit
import GameplayKit

class Melody: SKScene {
    weak var viewController: UIViewController?
    var entities = [GKEntity]()
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
        let refuelingCompSystem = GKComponentSystem(componentClass: RefuelingComponent.self)
        return [interactionCompSystem, progressingCompSystem, collectNectarComp, dryOutCompSystem, eatingCompSystem, gravityCompSystem, spriteCompSystem, flyCompSystem]
    }()
    
    
    var panRecogniser: UIPanGestureRecognizer!
    var clickRecognizer : UILongPressGestureRecognizer!
    var rotationRecogniser : UIRotationGestureRecognizer!
    
    var entityBeingInteractedWith : GKEntity?

    var progressCircle: GKEntity!
    
    var bees = [GKEntity]()
    
    var flowers = [GKEntity]()
    
    var frog : GKEntity?
    
    var waterTap : GKEntity?
    
    var bottle : GKEntity?
    
    var canEat : Bool = false
    
    let musicPlayer : MusicPlayer = MusicPlayer()
    
    var flowerTargetX = 100
    
    var flowerFactory : GKEntity?
    
    var canDryOut : Bool = false
    
    var beeHasBeenCreated : Bool = false
    
    let info : Info = Info()
    
    var timePlayed : TimeInterval = 0
    
    var gameIsRunning : Bool = false
    
    override func didMove(to view: SKView) {
        self.setupInteractionHandlers()
    }
    
    override func sceneDidLoad() {
        makeBackground()
        makeGround()
        addSystems()
        startGame()
    }
    
    func startGame() {
        gameIsRunning = true
        musicPlayer.playMusic(url: "06 En god melodi")
        startSchedual()
        makeFlowerFactory()
        timePlayed = 0
    }
    
    func startSchedual(){
        Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: {timer in
            if self.gameIsRunning {
                self.makeFrog()
                self.removeEntity(entity: self.flowerFactory!)
                self.canDryOut = true
                self.makeWaterTap()
            }
        })
        Timer.scheduledTimer(withTimeInterval: 100, repeats: false, block: {timer in
            if self.gameIsRunning {
                for flower in self.flowers {
                    flower.removeComponent(ofType: DryOutComponent.self)
                }
                self.canEat = true
                self.removeEntity(entity: self.waterTap!)
                self.removeEntity(entity: self.bottle!)
                self.makePiano()
            }

        })
        Timer.scheduledTimer(withTimeInterval: 153, repeats: false, block: {timer in
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
    
    func makeBackground(){
        let background = SKSpriteNode(imageNamed: "En god melodi (Baggrund)")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    func makeGround() {
        let ground = SKSpriteNode(imageNamed: "Græs")
        ground.position = CGPoint(x: size.width/2, y: 225)
        ground.zPosition = 5
        addChild(ground)
    }
    
    func makeMelody() {
        let melody = GKEntity()
        let spriteComp = SpriteComponent(name: "Node", zPos: 5)
        melody.addComponent(spriteComp)
        melody.addComponent(PositionComponent(currentPosition: CGPoint(x: 2500, y: 1900), targetPosition: CGPoint(x: 2500, y: 1900)))
        melody.addComponent(InteractionComponent())
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 0)
        entities.append(melody)
    }
    
    func makeFlowers(){
        for _ in 1...5 {
            makeFlower(targetPosition: CGPoint(x: CGFloat.random(min: 100, max: 2500), y: 500))
        }
    }
    
    func makeFlowerTargetPosition() -> CGPoint{
        let target = CGPoint(x: flowerTargetX, y: 500)
        flowerTargetX += 300
        return target
    }
    
    func makeFlowerFactory(){
        flowerFactory = GKEntity()
        let spriteComp = SpriteComponent(name: "BlomsterKnap", zPos: 2)
        flowerFactory!.addComponent(spriteComp)
        let position = CGPoint(x: 1500, y: 1800)
        flowerFactory!.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(flowerFactory!)
        makeProgressCircle(name: "", id: "Flower", position: position)
    }
    
    func makeProgressCircle(name: String, id: String, position: CGPoint){
        let progressCircle = GKEntity()
        let spriteComp = SpriteComponent(name: name, zPos: 4)
        spriteComp.sprite.name = id
        progressCircle.addComponent(spriteComp)
        
        progressCircle.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        
        progressCircle.addComponent(ProgressingComponent(scene: self))
        
        addChild(spriteComp.sprite)
        entities.append(progressCircle)
    }
    
    func makeFlowerPlacement(position : CGPoint){
        let place = GKEntity()
        let pos = CGPoint(x: position.x, y: position.y - 130)
        let spriteComp = SpriteComponent(name: "BlomstPlacering", zPos: 6)
        place.addComponent(spriteComp)
        place.addComponent(PositionComponent(currentPosition: pos, targetPosition: pos))
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(place)
    }
    
    func makePiano(){
        let piano = GKEntity()
        let spriteComp = SpriteComponent(name: "PianoButton", zPos: 2)
        piano.addComponent(spriteComp)
        let position = CGPoint(x: 2500, y: 1900)
        piano.addComponent(PositionComponent(currentPosition: position, targetPosition: position))
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(piano)
        makeProgressCircle(name: "", id: "Piano", position: position)
    }
    
    func makeWaterTap(){
        waterTap = GKEntity()
        let spriteComp = SpriteComponent(name: "Vandhane", zPos: 1)
        waterTap!.addComponent(spriteComp)
        waterTap!.addComponent(PositionComponent(currentPosition: CGPoint(x: 200, y: 1800), targetPosition: CGPoint(x: 200, y: 1800)))
        waterTap!.addComponent(RunningWaterComponent())
        self.addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        self.entities.append(waterTap!)
        makeWaterBottle(tap: waterTap!)
    }
    
    func makeWaterBottle(tap: GKEntity){
        bottle = GKEntity()
        let spriteComp = SpriteComponent(name: "Vandkande", zPos: 4)
        bottle!.addComponent(spriteComp)
        
        bottle!.addComponent(PositionComponent(currentPosition: CGPoint(x: 200, y: 1450), targetPosition: CGPoint(x: 200, y: 1450)))
        
        bottle!.addComponent(InteractionComponent())
        
        bottle!.addComponent(RotationComponent(currentRotation: 0, targetRotation: 0))
        
        bottle!.addComponent(WaterComponent(scene: self))
        
        bottle!.addComponent(SnappingComponent())
        
        bottle!.addComponent(RefuelingComponent(tap: tap))
        
        addChild(spriteComp.sprite)
        Scale(sprite: spriteComp.sprite, delay: 1)
        entities.append(bottle!)
    }
    
    func makeDrop(x: CGFloat, y: CGFloat) {
        let drop = GKEntity()
        let spriteComp = SpriteComponent(name: "Dråbe", zPos: 3)
        spriteComp.sprite.name = "drop"
        drop.addComponent(spriteComp)
        
        drop.addComponent(PositionComponent(currentPosition: CGPoint(x: x, y: y), targetPosition: CGPoint(x: x, y: y)))
        
        drop.addComponent(GravityComponent())
        
        self.addChild(spriteComp.sprite)
        self.entities.append(drop)
    }
    
    func makeBee() {
        let bee = GKEntity()
        let spriteComp = SpriteComponent(name: "Bi-Small", zPos: 2)
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
        let spriteComp = SpriteComponent(name: "FrøNy", zPos: 2)
        spriteComp.sprite.name = "Frog"
        frog!.addComponent(spriteComp)
        frog!.addComponent(PositionComponent(currentPosition: CGPoint(x: 2500, y: 500), targetPosition: CGPoint(x: CGFloat.random(min: 100, max: 2500), y: 500)))
        frog!.addComponent(JumpingAroundComponent())
        frog!.addComponent(EatingComponent(scene: self))
        frog!.addComponent(JollyDancingComponent(scene: self))
        addChild(spriteComp.sprite)
        self.entities.append(frog!)
    }
    
    func makeFlower(targetPosition : CGPoint){
        let flower = GKEntity()
        let spriteComp = SpriteComponent(name: "Blomst", zPos: 5)
        spriteComp.sprite.name = "flower"
        flower.addComponent(spriteComp)
        
        flower.addComponent(PositionComponent(currentPosition: CGPoint(x: 1500, y: 1900), targetPosition: targetPosition))
        flower.addComponent(DryOutComponent(scene: self))
        flower.addComponent(InteractionComponent())
        flower.addComponent(SnappingComponent())
        flower.addComponent(RotationComponent(currentRotation: 0, targetRotation: 0))
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
        bees.remove(at: index)
        removeEntity(entity: bee)
    }
    
    func checkBeeStatus(){
        self.enumerateChildNodes(withName: "Bi-Small") {node, _ in
            let bee = node as! SKSpriteNode
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
        musicPlayer.stopMusic()
        self.isPaused = true
        let restartSign = info.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY), Size: CGSize(width: 1500, height: 1000))
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
        let endSign = info.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(endSign)
    }
    
    func restart(){
        self.viewController?.viewDidLoad()
        self.viewController?.removeFromParent()
        self.removeFromParent()
    }
    
    func backToHome() {
        self.viewController?.performSegue(withIdentifier: "Home", sender: nil)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        timePlayed += dt
        if gameIsRunning {
            for system in componentSystems {
                system.update(deltaTime: dt)
            }
            
            // Update entities
            for entity in self.entities {
                
                entity.update(deltaTime: dt)
                entity.component(ofType: SnappingComponent.self)?.isSetup = true
            }
        }
        lose(timePlayed: timePlayed)
        checkPlacedPlants()
        checkForDiedPlants()
        self.lastUpdateTime = currentTime

    }
}
