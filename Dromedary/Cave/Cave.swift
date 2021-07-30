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

class Cave: SKScene {

    weak var viewController: UIViewController?
    var entities = [GKEntity]()
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
        return [interactionCompSystem, snappingSystem, groundContactCompSystem, gravityCompSystem, spriteCompSystem, timeCompSystem, changeCompSystem]
    }()
    var entityBeingInteractedWith : GKEntity?
    var musicPlayer: MusicPlayer!
    var correctPieces: Int = 0
    var gameIsPaused = true
    
    var info: Info!
    var startSign: SKSpriteNode!

    var panRecogniser: UIPanGestureRecognizer!
    var clickRecognizer : UILongPressGestureRecognizer!
    var rotationRecogniser : UIRotationGestureRecognizer!
    
    override func didMove(to view: SKView) {
        self.setupInteractionHandlers()
    }

    override func sceneDidLoad() {
        makeBackground()
        addGround()
        info = Info()
        puzzle = Puzzle()
        pieces = puzzle.makePieces()
        makeStartSign()

       
    }
    
    func makeStartSign() {
        startSign = info.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startSign)
    }
    
    func startGame() {
        makePuzzlePieceEntity()
        addSystems()
        playMusic()
        makeClock()
        gameIsPaused = false
    }
    
    func playMusic(){
        musicPlayer = MusicPlayer()
        musicPlayer.playMusic(url: "02 Hulen")
    }
    
    func getCorrectPieces() -> Int{
        return correctPieces
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

    func addSystems(){
        for system in componentSystems {
            for entity in entities {
                system.addComponent(foundIn: entity)
            }
        }
    }
    
    func makeBackground(){
        let background = SKSpriteNode(imageNamed: "HulenBaggrund")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    func makeClock(){
        clock = GKEntity()
        let timeComponent = TimeComponent()
        clock.addComponent(timeComponent)
        let clockSpriteComp = SpriteComponent(name: "ClockBackground", zPos: 2)
        clock.addComponent(clockSpriteComp)
        clock.addComponent(PositionComponent(currentPosition: CGPoint(x: 410, y: 1895), targetPosition: CGPoint(x: 410, y: 1895)))
        
        let minDigit = GKEntity()
        let firstSecDigit = GKEntity()
        let lastSecDigit = GKEntity()
        minDigit.addComponent(ChangeComponent(clock: clock, digit: "min", scene: self))
        let spriteComp1 = SpriteComponent(name: "0", zPos: 5)
        minDigit.addComponent(spriteComp1)
        minDigit.addComponent(PositionComponent(currentPosition: CGPoint(x: 200, y: 1900), targetPosition: CGPoint(x: 200, y: 1900)))
        let spriteComp2 = SpriteComponent(name: "0", zPos: 5)

        firstSecDigit.addComponent(ChangeComponent(clock: clock, digit: "firstSec", scene: self))
        firstSecDigit.addComponent(spriteComp2)
        firstSecDigit.addComponent(PositionComponent(currentPosition: CGPoint(x: 425, y: 1900), targetPosition: CGPoint(x: 425, y: 1900)))
        let spriteComp3 = SpriteComponent(name: "0", zPos: 5)

        lastSecDigit.addComponent(ChangeComponent(clock: clock, digit: "lastSec", scene: self))
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
        let scoreBoardSprite = SpriteComponent(name: "ScoreBackground", zPos: 2)
        scoreBoard.addComponent(scoreBoardSprite)
        scoreBoard.addComponent(PositionComponent(currentPosition: CGPoint(x: 2500, y: 1895), targetPosition: CGPoint(x: 2500, y: 1895)))
        
        let pointsDigit = GKEntity()
        let pointsSpriteComp = SpriteComponent(name: "0", zPos: 5)
        pointsDigit.addComponent(ChangeComponent(clock: clock, digit: "points", scene: self))
        pointsDigit.addComponent(pointsSpriteComp)
        pointsDigit.addComponent(PositionComponent(currentPosition: CGPoint(x: 2500, y: 1900), targetPosition: CGPoint(x: 2500, y: 1900)))
        self.addChild(pointsSpriteComp.sprite)
        self.addChild(scoreBoardSprite.sprite)
        self.entities.append(scoreBoard)
        self.entities.append(pointsDigit)
    }
    
    func backToHome() {
        self.viewController?.performSegue(withIdentifier: "Home", sender: nil)
    }
    
    func restart() {
        self.viewController?.viewDidLoad()
        self.viewController?.removeFromParent()
        self.removeFromParent()
        
    }
    
    func makePuzzlePieceEntity(){
        for piece in pieces {
            let puzzlePiece = GKEntity()
            let spriteComponent = SpriteComponent(name: piece.name, zPos: piece.zPos)
            let positionComponent = PositionComponent(currentPosition: CGPoint(x: CGFloat.random(min: 150, max: 1900), y: 600), targetPosition: piece.targetPosition)
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
        let ground = SKSpriteNode(imageNamed: "Græs")
        ground.position = CGPoint(x: size.width/2, y: 250)
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
            }
        }
        if correctPieces == pieces.count {
            clock?.component(ofType: TimeComponent.self)?.endTimer()
            musicPlayer.stopMusic()
            let endsign = info.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(endsign)
        }
    }
    
    func checkTime() {
        if clock?.component(ofType: TimeComponent.self)?.timeIsUp == true {
            musicPlayer.stopMusic()
            let restartSign = info.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY), Size: CGSize(width: 1500, height: 1500))
            addChild(restartSign)
        }
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

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
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
            entity.component(ofType: SnappingComponent.self)?.isSetup = true
        }
        checkTime()
        checkForCorrectPlacedPiece()
        
        self.lastUpdateTime = currentTime
        

    }

}
