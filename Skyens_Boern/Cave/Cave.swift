//
//  Cave.swift
//  Dromedary
//
//  Created by Mads Munk on 13/01/2021.
//  Copyright © 2021 Mads Munk. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class Cave: Scene, SKPhysicsContactDelegate {

    private var lastUpdateTime : TimeInterval = 0
    private var puzzle: Puzzle!
    private var pieces: Array<Piece>!
    var clock: GKEntity!
    lazy var componentSystems : [GKComponentSystem] = {
        let spriteCompSystem = GKComponentSystem(componentClass: SpriteComponent.self)
        let snappingSystem = GKComponentSystem(componentClass: SnappingComponent.self)
        let interactionCompSystem = GKComponentSystem(componentClass: InteractionComponent.self)
        let gravityCompSystem = GKComponentSystem(componentClass: GravityComponent.self)
        let groundContactCompSystem = GKComponentSystem(componentClass: GroundContactComponent.self)
        let timeCompSystem = GKComponentSystem(componentClass: TimeComponent.self)
        let changeCompSystem = GKComponentSystem(componentClass: ChangeComponent.self)
        return [interactionCompSystem, snappingSystem, spriteCompSystem, timeCompSystem, groundContactCompSystem, changeCompSystem, gravityCompSystem]
    }()
    var correctPieces: Int = 0
    var hasFinished = false
    let backgroundAtlas = SKTextureAtlas(named: "Background")
    let clockAtlas = SKTextureAtlas(named: "Clock")
    let branchesAtlas = SKTextureAtlas(named: "Branches")
    var timer1 : Timer?
    var timer2 : Timer?

    override func sceneDidLoad() {
        print("frameMinx", self.frame.minX)
        makeBackground()
        addGround()
        setUpPhysics()
        puzzle = Puzzle()
        pieces = puzzle.makePieces()
        makeStartSign()
        makeHelpBtn()
        self.makeBackBtn()
    }
    
    func setUpPhysics(){
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = 1.0
    }
    
    func makeStartSign() {
        let startSign = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startSign)
    }
    
    override func startGame() {
        gameIsRunning = true
        playMusic()
        makeClock()
        makePuzzlePieceEntity()
        addSystems()
        for entity in entities {
            entity.component(ofType: SnappingComponent.self)?.isSetup = true
            entity.component(ofType: SpriteComponent.self)?.sprite.zPosition = -1
        }
        timer2 = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { [self] timer in
            for entity in entities {
                if entity.component(ofType: InteractionComponent.self) != nil {
                    setZPosition(entity: entity, zPos: 4)
                }else{
                    setZPosition(entity: entity, zPos: 5)
                }
            }
        })
    }
    
    func setZPosition(entity: GKEntity, zPos: CGFloat){
        entity.component(ofType: SpriteComponent.self)?.sprite.zPosition = zPos
    }
    
    func playMusic(){
        self.musicPlayer.play(url: "02 Hulen")
    }
    
    func getCorrectPieces() -> Int{
        return correctPieces
    }

    func addSystems(){
        for system in componentSystems {
            for entity in entities {
                system.addComponent(foundIn: entity)
            }
        }
    }
    
    func makeBackground(){
        let background = SKSpriteNode(texture: backgroundAtlas.textureNamed("HulenBaggrund"))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    func makeClock(){
        clock = GKEntity()
        let timeComponent = TimeComponent(scene: self)
        clock.addComponent(timeComponent)
        let clockSpriteComp = SpriteComponent(atlas: clockAtlas, name: "ClockBackground", zPos: 2)
        clock.addComponent(clockSpriteComp)
        clock.addComponent(PositionComponent(currentPosition: CGPoint(x: 410, y: 1895), targetPosition: CGPoint(x: 410, y: 1895)))
        
        let minDigit = GKEntity()
        let firstSecDigit = GKEntity()
        let lastSecDigit = GKEntity()
        minDigit.addComponent(ChangeComponent(clock: clock, digit: "min"))
        let spriteComp1 = SpriteComponent(atlas: clockAtlas, name: "0", zPos: 5)
        minDigit.addComponent(spriteComp1)
        minDigit.addComponent(PositionComponent(currentPosition: CGPoint(x: 200, y: 1900), targetPosition: CGPoint(x: 200, y: 1900)))
        let spriteComp2 = SpriteComponent(atlas: clockAtlas, name: "0", zPos: 5)

        firstSecDigit.addComponent(ChangeComponent(clock: clock, digit: "firstSec"))
        firstSecDigit.addComponent(spriteComp2)
        firstSecDigit.addComponent(PositionComponent(currentPosition: CGPoint(x: 425, y: 1900), targetPosition: CGPoint(x: 425, y: 1900)))
        let spriteComp3 = SpriteComponent(atlas: clockAtlas, name: "0", zPos: 5)

        lastSecDigit.addComponent(ChangeComponent(clock: clock, digit: "lastSec"))
        lastSecDigit.addComponent(spriteComp3)
        lastSecDigit.addComponent(PositionComponent(currentPosition: CGPoint(x: 620, y: 1900), targetPosition: CGPoint(x: 620, y: 1900)))

        

        self.entities.append(clock)
        self.entities.append(minDigit)
        self.entities.append(firstSecDigit)
        self.entities.append(lastSecDigit)
        addSystems()
        self.addChild(clockSpriteComp.sprite)
        self.addChild(spriteComp1.sprite)
        self.addChild(spriteComp2.sprite)
        self.addChild(spriteComp3.sprite)
    }
    
    func makePuzzlePieceEntity(){
        for piece in pieces {
            let puzzlePiece = GKEntity()
            let spriteComponent = SpriteComponent(atlas: branchesAtlas, name: piece.name, zPos: piece.zPos)
            let positionComponent = PositionComponent(currentPosition: CGPoint(x: CGFloat.random(min: 150, max: 1000), y: 600), targetPosition: piece.targetPosition)
            let interactionComponent = InteractionComponent()
            puzzlePiece.addComponent(interactionComponent)
            let snappingComponent = SnappingComponent()
            let gravityComponent = GravityComponent()
            let groundContactComponent = GroundContactComponent()
            let rotationComponent = RotationComponent(currentRotation: 0.0, targetRotation: piece.targetRotation)
            puzzlePiece.addComponent(rotationComponent)
            puzzlePiece.addComponent(snappingComponent)
            puzzlePiece.addComponent(spriteComponent)
            puzzlePiece.addComponent(positionComponent)
            puzzlePiece.addComponent(gravityComponent)
            puzzlePiece.addComponent(groundContactComponent)
            self.addChild(spriteComponent.sprite)
            self.entities.append(puzzlePiece)
        }
    }
    
    func addGround(){
        let ground = SKSpriteNode(texture: backgroundAtlas.textureNamed("Græs"))
        ground.position = CGPoint(x: self.frame.midX, y: 250)
        ground.zPosition = 1
        addChild(ground)
    }
    
    func checkForCorrectPlacedPiece() {
        for entity in entities {
            if entity.component(ofType: SnappingComponent.self)?.hasSnapped == true {
                if (entity.component(ofType: InteractionComponent.self) != nil){
                    entity.removeComponent(ofType: InteractionComponent.self)
                    correctPieces += 1
                }
                if entity.component(ofType: GravityComponent.self) != nil {
                    entity.removeComponent(ofType: GravityComponent.self)
                    if correctPieces == 1 {
                        playSpeak(name: "Hulen5", length: 5)
                    }
                    if correctPieces == 2 {
                        playSpeak(name: "Hulen6", length: 4)
                    }
                    if correctPieces == 3 {
                        playSpeak(name: "Hulen7", length: 4)
                    }
                    if correctPieces == 5 {
                        playSpeak(name: "Hulen8", length: 4)
                    }
                }
            }
        }
        if correctPieces == pieces.count && !hasFinished{
            timer1 = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [self] timer in
                musicPlayer.fadeOut()
                gameIsRunning = false
                let endsign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
                addChild(endsign)
                playSpeakNoMusic(name: "Hulen10")
            })
            clock.component(ofType: TimeComponent.self)?.endTimer()
            hasFinished = true
            for entity in entities {
                guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {return}
                guard entity.component(ofType: RotationComponent.self) != nil else { return }
                self.Scale(sprite: spriteComponent.sprite, delay: 0)
            }
        }
    }
    
    func Scale(sprite : SKSpriteNode, delay : TimeInterval){
        let delay = SKAction.wait(forDuration: delay)
        let scaleUp = SKAction.scale(to: 2, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let sequence = SKAction.sequence([delay, scaleUp, scaleDown])
        sprite.run(sequence)
    }
    
    func checkTime() {
        if clock.component(ofType: TimeComponent.self)?.timeIsUp == true {
            self.musicPlayer.fadeOut()
            gameIsRunning = false
            let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(restartSign)
            playSpeakNoMusic(name: "Hulen11")
        }
    }
    
    func removeEntity(entity : GKEntity) {
        guard let index = entities.firstIndex(of: entity) else { return }
        entity.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        self.entities.remove(at: index)
    }
    
    override func restart() {
        self.viewController?.selectScene(selectedScene: Cave(size: CGSize(width: 2732, height: 2048)))
    }
    
    override func willMove(from view: SKView) {
        print("will move from cave")
        self.clock.component(ofType: TimeComponent.self)?.timer.invalidate()
        self.clock.component(ofType: TimeComponent.self)?.timer = nil
        self.timer1?.invalidate()
        self.timer1 = nil
        self.removeAllActions()
        self.clock = nil
        self.pieces = nil
        self.puzzle = nil
        for entity in entities {
            removeEntity(entity: entity)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "piece" && contact.bodyB.node?.name == "ground"  {
        }else if contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "piece" {
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        if gameIsRunning == true {
            for system in componentSystems {
                system.update(deltaTime: dt)
            }
            checkTime()
            checkForCorrectPlacedPiece()
        }
        
        self.lastUpdateTime = currentTime
        

    }

}
