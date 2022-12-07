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
    var scoreBoard: GKEntity!
    lazy var componentSystems : [GKComponentSystem] = {
        let spriteCompSystem = GKComponentSystem(componentClass: SpriteComponent.self)
        let snappingSystem = GKComponentSystem(componentClass: SnappingComponent.self)
        let interactionCompSystem = GKComponentSystem(componentClass: InteractionComponent.self)
        let gravityCompSystem = GKComponentSystem(componentClass: GravityComponent.self)
        let groundContactCompSystem = GKComponentSystem(componentClass: GroundContactComponent.self)
        let timeCompSystem = GKComponentSystem(componentClass: TimeComponent.self)
        let changeCompSystem = GKComponentSystem(componentClass: ChangeComponent.self)
        return [interactionCompSystem, snappingSystem, spriteCompSystem, timeCompSystem, changeCompSystem, gravityCompSystem]
    }()
    var correctPieces: Int = 0
    var gameIsPaused = true
    
    var startSign: SKSpriteNode!
    var hasFinished = false
    let backgroundAtlas = SKTextureAtlas(named: "Background")
    let clockAtlas = SKTextureAtlas(named: "Clock")
    let branchesAtlas = SKTextureAtlas(named: "Branches")

    override func sceneDidLoad() {
        print("frameMinx", self.frame.minX)
        makeBackground()
        addGround()
        setUpPhysics()
        puzzle = Puzzle()
        pieces = puzzle.makePieces()
        makeStartSign()
        self.makeBackBtn()
    }
    
    func setUpPhysics(){
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = 1.0
    }
    
    func makeStartSign() {
        startSign = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startSign)
    }
    
    override func startGame() {
        makePuzzlePieceEntity()
        addSystems()
        playMusic()
        makeClock()
        gameIsPaused = false
        for entity in entities {
            entity.component(ofType: SnappingComponent.self)?.isSetup = true
        }
    }
    
    func playMusic(){
        self.musicPlayer.playMusic(url: "02 Hulen")
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
        let timeComponent = TimeComponent()
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
        self.addChild(clockSpriteComp.sprite)
        self.addChild(spriteComp1.sprite)
        self.addChild(spriteComp2.sprite)
        self.addChild(spriteComp3.sprite)
    }
    
    func makeScoreBoard(){
        scoreBoard = GKEntity()
        let scoreBoardSprite = SpriteComponent(atlas: clockAtlas, name: "ScoreBackground", zPos: 2)
        scoreBoard.addComponent(scoreBoardSprite)
        scoreBoard.addComponent(PositionComponent(currentPosition: CGPoint(x: 2500, y: 1895), targetPosition: CGPoint(x: 2500, y: 1895)))
        
        let pointsDigit = GKEntity()
        let pointsSpriteComp = SpriteComponent(atlas: clockAtlas, name: "0", zPos: 5)
        pointsDigit.addComponent(ChangeComponent(clock: clock, digit: "points"))
        pointsDigit.addComponent(pointsSpriteComp)
        pointsDigit.addComponent(PositionComponent(currentPosition: CGPoint(x: 2500, y: 1900), targetPosition: CGPoint(x: 2500, y: 1900)))
        self.addChild(pointsSpriteComp.sprite)
        self.addChild(scoreBoardSprite.sprite)
        self.entities.append(scoreBoard)
        self.entities.append(pointsDigit)
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
                }
            }
        }
        if correctPieces == pieces.count && !hasFinished{
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [self] timer in
                self.musicPlayer.fadeOut()
                gameIsPaused = true
                let endsign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
                addChild(endsign)
            })
            clock?.component(ofType: TimeComponent.self)?.endTimer()
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
        if clock?.component(ofType: TimeComponent.self)?.timeIsUp == true {
            self.musicPlayer.fadeOut()
            gameIsPaused = true
            let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(restartSign)
        }
    }
    
    override func restart() {
        self.viewController?.selectScene(selectedScene: Cave(size: CGSize(width: 2732, height: 2048)))
    }
    
/*    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = topNode(at: location)
            self.entityBeingInteractedWith = touchedNode?.entity
            guard let hasEntity = self.entityBeingInteractedWith else { return }
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.began, location)

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = topNode(at: location)
            self.entityBeingInteractedWith = touchedNode?.entity
            guard let hasEntity = self.entityBeingInteractedWith else { return }
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.changed, location)

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = topNode(at: location)
            self.entityBeingInteractedWith = touchedNode?.entity
            guard let hasEntity = self.entityBeingInteractedWith else { return }
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.ended, location)
            self.entityBeingInteractedWith = nil
            

        }
    } */
    
    override func willMove(from view: SKView) {
        self.clock?.component(ofType: TimeComponent.self)?.timer.invalidate()
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
        if gameIsPaused == false {
            for system in componentSystems {
                system.update(deltaTime: dt)
            }
            
            // Update entities
            for entity in self.entities {
                entity.update(deltaTime: dt)
                
            }
            checkTime()
            checkForCorrectPlacedPiece()
        }
        
        self.lastUpdateTime = currentTime
        

    }

}
