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

    // variables
    private var lastUpdateTime : TimeInterval = 0
    private var puzzle: Puzzle!
    private var pieces: Array<Piece>!
    private var greyPieces: Array<Piece>!
    private var pieceEntities : Array<GKEntity>! = []
    var clock: GKEntity!
    // array of component systems
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
    var timer3 : Timer?
    var timer4 : Timer?
    

    // when scene loads setup scene
    override func sceneDidLoad() {
        makeBackground()
        addGround()
        puzzle = Puzzle()
        pieces = puzzle.makePieces()
        greyPieces = puzzle.makeGreyPieces()
        makeStartSign()
        makeHelpBtn()
        self.makeBackBtn()
    }
    
    // make start sign
    func makeStartSign() {
        let startSign = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startSign)
    }
    
    // start the game
    override func startGame() {
        gameIsRunning = true
        playMusic()
        makeClock()
        makePuzzlePieceEntities()
        makeGreyPuzzlePieceEntities()
        addSystems()
        // first set all sprite components to -1 zPosition so they are not visible
        for entity in entities {
            entity.component(ofType: SnappingComponent.self)?.isSetup = true
            entity.component(ofType: SpriteComponent.self)?.sprite.zPosition = -1
        }
        // timer fires after 1.2 sec and set sprite components with interaction comp to zPos 5 and all other to zPos 3
        timer2 = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { [self] timer in
            for entity in entities {
                if entity.component(ofType: InteractionComponent.self) != nil {
                    setZPosition(entity: entity, zPos: 5)
                }else{
                    setZPosition(entity: entity, zPos: 3)
                }
                print("Name: ", entity.component(ofType: SpriteComponent.self)?.name, "zPos: ", entity.component(ofType: SpriteComponent.self)?.sprite.zPosition)
            }
        })
        timer3 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [self] timer in
            let index = Int.random(in: 0...5)
            let entity = pieceEntities[index]
            guard let sprite = entity.component(ofType: SpriteComponent.self)?.sprite else {return}
            if entity.component(ofType: InteractionComponent.self)?.hasBeenTouched == false{
                self.wiggle(sprite: sprite)
            }
        })
        timer4 = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [self] timer in
            for piece in pieceEntities {
                piece.removeComponent(ofType: GravityComponent.self)
            }
        })

    }
    
    // set ZPosition of entitys sprite component
    func setZPosition(entity: GKEntity, zPos: CGFloat){
        entity.component(ofType: SpriteComponent.self)?.sprite.zPosition = zPos
    }
    
    // playmusic (possibly obsolete)
    func playMusic(){
        self.musicPlayer.play(url: "02 Hulen")
    }
    
    // get correct placed pieces of the puzzle
    func getCorrectPieces() -> Int{
        return correctPieces
    }

    // add entity components to componentsystems array
    func addSystems(){
        for system in componentSystems {
            for entity in entities {
                system.addComponent(foundIn: entity)
            }
        }
    }
    
    // make the background
    func makeBackground(){
        let background = SKSpriteNode(texture: backgroundAtlas.textureNamed("HulenBaggrund"))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    // make the clock entity
    func makeClock(){
        clock = GKEntity()
        let timeComponent = TimeComponent(scene: self)
        clock.addComponent(timeComponent)
        let clockSpriteComp = SpriteComponent(atlas: clockAtlas, name: "ClockBackground", zPos: 2)
        clock.addComponent(clockSpriteComp)
        clock.addComponent(PositionComponent(currentPosition: CGPoint(x: 410, y: 1895), targetPosition: CGPoint(x: 410, y: 1895)))
        
        // make min and seconds digits entities
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
    
    // make the grey puzzle pieces for guiding the player
    func makeGreyPuzzlePieceEntities(){
        for greyPiece in greyPieces {
            let greyPiecesEntity = GKEntity()
            let spriteComponent = SpriteComponent(atlas: branchesAtlas, name: greyPiece.name, zPos: greyPiece.zPos)
            spriteComponent.id = greyPiece.id
            let positionComponent = PositionComponent(currentPosition: greyPiece.targetPosition, targetPosition: greyPiece.targetPosition)
            greyPiecesEntity.addComponent(spriteComponent)
            greyPiecesEntity.addComponent(positionComponent)
            self.addChild(spriteComponent.sprite)
            self.entities.append(greyPiecesEntity)
        }
    }
    
    // make the puzzle pieces
    func makePuzzlePieceEntities(){
        for piece in pieces {
            let puzzlePiece = GKEntity()
            let spriteComponent = SpriteComponent(atlas: branchesAtlas, name: piece.name, zPos: piece.zPos)
            spriteComponent.id = piece.id
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
            self.pieceEntities.append(puzzlePiece)
        }
    }
    
    // add the ground
    func addGround(){
        let ground = SKSpriteNode(texture: backgroundAtlas.textureNamed("Græs"))
        ground.position = CGPoint(x: self.frame.midX, y: 240)
        ground.zPosition = 1
        addChild(ground)
    }
    
    // check entities for correct placed pieces
    // if entity has snapped and still has interaction component pieces is correct placed. Remove interactioncomp
    func checkForCorrectPlacedPiece() {
        for entity in entities {
            if entity.component(ofType: SnappingComponent.self)?.hasSnapped == true {
                if (entity.component(ofType: InteractionComponent.self) != nil){
                    entity.removeComponent(ofType: InteractionComponent.self)
                    correctPieces += 1
                }
                // if the entity has gravity comp remove it and play speak according to the correct placed pieces
                if entity.component(ofType: GroundContactComponent.self) != nil {
                    entity.removeComponent(ofType: GroundContactComponent.self)
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
        // if all pieces are correct placed win and end game
        if correctPieces == pieces.count && !hasFinished{
            timer1 = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [self] timer in
                musicPlayer.fadeOut()
                gameIsRunning = false
                let endsign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
                addChild(endsign)
                playSpeakNoMusic(name: "Hulen10")
                defaults.set(true, forKey: "caveCompleted")
            })
            clock.component(ofType: TimeComponent.self)?.endTimer()
            hasFinished = true
            // scale up pieces when finished
            for entity in entities {
                print("looping entities")
                if entity.component(ofType: RotationComponent.self) != nil {
                    guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {return}
                    self.Scale(sprite: spriteComponent.sprite, delay: 0)
                }
            }
        }
    }
    
    // Scale a spritenode with the specified delay
    func Scale(sprite : SKSpriteNode, delay : TimeInterval){
        let delay = SKAction.wait(forDuration: delay)
        let scaleUp = SKAction.scale(to: 2, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let sequence = SKAction.sequence([delay, scaleUp, scaleDown])
        sprite.run(sequence)
    }
    
    // check if time is up. If time is up stop and setup for restart
    func checkTime() {
        if clock.component(ofType: TimeComponent.self)?.timeIsUp == true {
            self.musicPlayer.fadeOut()
            gameIsRunning = false
            let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(restartSign)
            playSpeakNoMusic(name: "Hulen11")
        }
    }
    
    // scale up the grey pieces matchin the puzzle pieces being touched to guide the player.
    func checkTouch(){
        
        var id = self.entityBeingInteractedWith?.component(ofType: SpriteComponent.self)?.id
        
        if itemHasBeenTouched {
            for entity in entities {
                guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {return}
                if entity.component(ofType: InteractionComponent.self) == nil && spriteComponent.id == id && spriteComponent.id != nil{
                    self.Scale(sprite: spriteComponent.sprite, delay: 0.5)
                    itemHasBeenTouched = false
                }
            }
        }
    }
    
    // Remove an entity
    func removeEntity(entity : GKEntity) {
        guard let index = entities.firstIndex(of: entity) else { return }
        entity.component(ofType: SpriteComponent.self)?.willRemoveFromEntity()
        self.entities.remove(at: index)
    }
    
    // Restart the scene
    override func restart() {
        self.viewController?.selectScene(selectedScene: Cave(size: CGSize(width: 2732, height: 2048)))
    }
    
    // clean up
    override func willMove(from view: SKView) {
        print("will move from cave")
        self.clock.component(ofType: TimeComponent.self)?.timer.invalidate()
        self.clock.component(ofType: TimeComponent.self)?.timer = nil
        self.timer1?.invalidate()
        self.timer1 = nil
        self.timer2?.invalidate()
        self.timer3?.invalidate()
        self.timer4?.invalidate()
        self.removeAllActions()
        self.clock = nil
        self.pieces = nil
        self.puzzle = nil
        for entity in entities {
            removeEntity(entity: entity)
        }
    }

    // game loop update method
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        // If game is running update systems
        if gameIsRunning == true {
            for system in componentSystems {
                system.update(deltaTime: dt)
            }
            // check time, correctplaced pieces and if a pieces is touched
            checkTime()
            checkForCorrectPlacedPiece()
            checkTouch()
        }
        
        self.lastUpdateTime = currentTime
        

    }

}
