//
//  GameScene.swift
//  Dromedary
//
//  Created by Mads Munk on 21/01/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class ThereOnceWasAMan: Scene, SKPhysicsContactDelegate {
    
    var tileMap:SKTileMapNode!
    var man:SKSpriteNode!
    var MyLocation = CGPoint(x: 0, y: 0)
    var x: CGFloat = 21350
    var startButton: SKSpriteNode!
    var sequence: SKAction!
    var edgeCollisionMask: UInt32 = 0b0100
    var dromedaryCategoryBitMask: UInt32 = 0b001
    var edge: SKSpriteNode!
    var dromedary: SKSpriteNode!
    var nose: SKSpriteNode!
    var noseXPosition: CGFloat!
    var nosePositionIsUpdated: Bool = false
    var wizard: SKSpriteNode!
    var mapSpeed: CGFloat = 5
    var canJump = true
    var book: SKSpriteNode!
    var wizNose: SKSpriteNode!
    var hasMounted: Bool = false
    var dancer: SKSpriteNode!
    var viewHeight : CGFloat!
    var ground : SKTileMapNode!
    var groundMinX : CGFloat = -22500
    var currentXLocInMap : CGFloat = -22500
    var isMounting : Bool = false
    var wizardEnhancedNode : SKSpriteNode?
    var wizardIsMounting : Bool = false
    var timer1 : Timer?
    var timer2 : Timer?
    var timer3 : Timer?
    var timer4 : Timer?
    var timer5 : Timer?
    let manAtlas : SKTextureAtlas = SKTextureAtlas(named: "Man")
    let wizardAtlas : SKTextureAtlas = SKTextureAtlas(named: "Wizard")
    let dromedaryAtlas : SKTextureAtlas = SKTextureAtlas(named: "Dromedary")
    let dancerAtlas : SKTextureAtlas = SKTextureAtlas(named: "Dancer")
    let bookAtlas : SKTextureAtlas = SKTextureAtlas(named: "Book")
    let noseAtlas : SKTextureAtlas = SKTextureAtlas(named: "Nose")


    
    private var lastUpdateTime : TimeInterval = 0
    
    
    override func sceneDidLoad() {
        loadNodes()
        startButton = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startButton)
        setUpPhysics()
        makeEdge()
        addCamera()
        self.makeBackBtn()
    }
    
    func addCamera(){
        print("screen height: ", UIScreen.main.bounds.size.width)
        print("Orientation: ", UIDevice.current.orientation.isLandscape)
        var screenHeight : CGFloat
        if UIDevice.current.orientation.isPortrait {
            screenHeight = UIScreen.main.bounds.height
        } else {
            screenHeight = UIScreen.main.bounds.height
        }
        let playableAreaScaleForIpadAndIphone = screenHeight / tileMap.mapSize.height
        let camera = SKCameraNode()
        camera.setScale(1/playableAreaScaleForIpadAndIphone)
        self.camera = camera
        self.addChild(self.camera!)
    }
    
    func schedual(){
        timer1 = Timer.scheduledTimer(withTimeInterval: 25, repeats: false, block: { [self] timer in
            print("first event")
            animateNose(noseIMG1: "NæseRød01", noseIMG2: "NæseRød02", noseToAni: nose)
            animateDancer()
        })
        

        timer2 = Timer.scheduledTimer(withTimeInterval: 50, repeats: false, block: { [self] timer in
            standingDromedary()
        })
        
        //mounting

        timer3 = Timer.scheduledTimer(withTimeInterval: 70, repeats: false, block: { [self] timer in
            makeWizNose()

        })
        

        timer4 = Timer.scheduledTimer(withTimeInterval: 170, repeats: false, block: { [self] timer in
            ending()
        })
        

    }
    
    func checkMapLocation(mapXLocation : CGFloat){
        print("map x loc ", mapXLocation)
        if mapXLocation >= -13500 && mapXLocation <= -13490 {
            canJump = false
        }
        if mapXLocation >= -5200 && mapXLocation <= -5190{
            canJump = false
        }
    }
    
    func animateDancer(){
        print("animating dancer")
        let move01 = SKAction.setTexture(dancerAtlas.textureNamed("DanserMove01"))
        let move02 = SKAction.setTexture(dancerAtlas.textureNamed("DanserMove02"))
        let move03 = SKAction.setTexture(dancerAtlas.textureNamed("DanserMove03"))
        let move04 = SKAction.setTexture(dancerAtlas.textureNamed("DanserMove04"))
        let wait = SKAction.wait(forDuration: 0.2)
        let wait02 = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([move01, wait, move02, wait, move03, wait, move02, wait, move01, wait, move04, wait02])
        dancer.run(.repeatForever(sequence), withKey: "dance")
    }
    
    func addNodeToWizard(){
        wizardEnhancedNode = SKSpriteNode()
        wizardEnhancedNode!.name = "enhancedNode"
        wizardEnhancedNode!.size = CGSize(width: 600, height: wizard.size.height)
        wizardEnhancedNode!.zPosition = -1
        wizard.addChild(wizardEnhancedNode!)
    }
    
    func dancerLeave() {
        dancer.removeAction(forKey: "dance")
        let walk01 = SKAction.setTexture(dancerAtlas.textureNamed("DanserStårFraSide"))
        let walk02 = SKAction.setTexture(dancerAtlas.textureNamed("DanserGårFraSiden"))
        let wait = SKAction.wait(forDuration: 0.2)
        let moveDancer = SKAction.move(to: CGPoint(x: self.frame.maxX + 300, y: -150), duration: 20)
        let sequence = SKAction.sequence([walk01, wait, walk02, wait])
        dancer.run(moveDancer, completion: removeDancer)
        dancer.run(.repeatForever(sequence))
    }
    
    func removeDancer() {
        dancer.removeAllActions()
        dancer.removeFromParent()
    }
    
    func animateMounting(){
        isMounting = true
        man.physicsBody?.affectedByGravity = false
        man.removeAction(forKey: "walk")
        let jump = SKAction.move(to: CGPoint(x: man.position.x, y: dromedary.position.y + dromedary.size.height/2 + man.size.height), duration: 0.5)
        let land = SKAction.move(to: CGPoint(x: man.position.x - 50 + dromedary.size.width/2, y: dromedary.position.y + man.size.height/2), duration: 0.5)
        let jumpTexture = SKAction.setTexture(manAtlas.textureNamed("MandHop"))
        let landTexture = SKAction.setTexture(manAtlas.textureNamed("MandRidende"))
        let mountAction = SKAction.run(mountMan)
        let setNosePos = SKAction.run { [self] in
            changeNosePosition(position: CGPoint(x: 16 + nose.size.width/2, y: nose.position.y))
        }
        let sequence = SKAction.sequence([jumpTexture, setNosePos, jump, landTexture, land, mountAction])

        man.run(sequence, completion: activateDromedary)
        man.name = "activeDromedary"
    }
    
    func activateDromedary(){
        dromedary.move(toParent: self.scene!)
        dromedary.removeAction(forKey: "standingDromedary")
        addPhysicsToDromedary()
        man.physicsBody = nil
        animateDromedary()
        hasMounted = true
        canJump = true
    }
    
    func ending(){
        mapSpeed = 0
        dromedary.removeAllActions()
        unMountMan()
        unMountWizard()
    }
    
    func unMountWizard() {
        let wait = SKAction.wait(forDuration: 0.3)
        let moveToScene = SKAction.run {
            self.wizard.move(toParent: self.scene!)
        }
        let changeToJump = SKAction.setTexture(wizardAtlas.textureNamed("TroldSide02"))
        let invert = SKAction.scaleX(to: -1.0, duration: 0)
        let moveUp = SKAction.move(to: CGPoint(x: 70, y: 250), duration: 0.5)
        let land = SKAction.move(to: CGPoint(x: 250, y: -316 + wizard.size.height/2), duration: 0.5)
        let changeToFront = SKAction.setTexture(wizardAtlas.textureNamed("TroldeFront"))
        let openBookAction = SKAction.run(openBook)
        let changeWizNoseToFront = SKAction.run(setWizNoseToFront)
        let sequence = SKAction.sequence([moveToScene, wait, changeToJump, invert, moveUp, land, changeToFront, changeWizNoseToFront, openBookAction])
        wizard.run(sequence, completion: endSign)
    }
    
    func unMountMan(){
        let wait = SKAction.wait(forDuration: 0.2)
        let moveToScene = SKAction.run {
            self.man.move(toParent: self.scene!)
        }
        let changeToJump = SKAction.setTexture(manAtlas.textureNamed("MandHop"))
        let moveUp = SKAction.move(to: CGPoint(x: 100, y: 250), duration: 0.5)

        let land = SKAction.move(to: CGPoint(x: 500, y: -316 + man.size.height/2), duration: 0.5)
        let changeToFront = SKAction.setTexture(manAtlas.textureNamed("ManForfra"))
        let changeManNoseToFront = SKAction.run(setManNoseToFront)
        let sequence = SKAction.sequence([moveToScene, wait, changeToJump, moveUp, land, changeToFront, changeManNoseToFront])
        man.run(sequence)
    }
    
    func celebrationAni(){
        let moveManUp = SKAction.moveTo(y: man.position.y + 40, duration: 0.1)
        let moveManDown = SKAction.moveTo(y: man.position.y, duration: 0.1)
        let moveWizUp = SKAction.moveTo(y: wizard.position.y + 40, duration: 0.1)
        let moveWizDown = SKAction.moveTo(y: wizard.position.y, duration: 0.1)
        let wizSequence = SKAction.sequence([moveWizDown, moveWizUp])
        let manSeq = SKAction.sequence([moveManUp, moveManDown])
        man.run(.repeatForever(manSeq))
        wizard.run(.repeatForever(wizSequence))
        
    }
    
    func endSign(){
        let wait = SKAction.wait(forDuration: 5.0)
        let endAction = SKAction.run { [self] in
            let endSign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(endSign)
        }
        let celebAction = SKAction.run(celebrationAni)
        let seq = SKAction.sequence([wait, endAction])
        let group = SKAction.group([celebAction, seq])
        self.run(group)
        
    }
    
    func openBook(){
        book.texture = bookAtlas.textureNamed("BogÅben")
        let changePos = SKAction.move(to: CGPoint(x: -book.size.width, y: 0), duration: 0)
        book.run(changePos)
    }
    
    func mountMan() {
        man.move(toParent: dromedary)
    }
    
    func mountNose(){
        nose = SKSpriteNode(texture: noseAtlas.textureNamed("NæseGrå"))
        nose.size = CGSize(width: 50, height: 64)
        nose.name = "nose"
        nose.zPosition = 1
        noseXPosition = man.position.x + 16 + nose.size.width/2
        nose.position = CGPoint(x: noseXPosition, y: -90)
        addChild(nose)
        nose.move(toParent: man)
        noseXPosition = nose.position.x
        print(noseXPosition)
    }
    
    func remountNose(){
        let rotateAction = SKAction.rotate(byAngle: +.pi/2, duration: 0)
        changeNosePosition(position: CGPoint(x: noseXPosition + 26, y: man.position.y - 110))
        nose.run(rotateAction)
    }
        
    func meeting(){
        //manMeetingAni()
        mountWizard()
        
    }
    
    func manMeetingAni(){
        let change = SKAction.setTexture(manAtlas.textureNamed("MandBøjet"))
        man.run(change)
        man.position = CGPoint(x: man.position.x + 80, y: man.position.y - 100)
        man.scale(to: CGSize(width: 320, height: 256))
        noseMeetingAni()
    }
    
    func noseMeetingAni(){
        let rotatateAction = SKAction.rotate(byAngle: -.pi/2, duration: 0)
        changeNosePosition(position: CGPoint(x: man.position.x - 14, y: man.position.y - 78))
        nose.run(rotatateAction)
    }
    
    func addPhysicsToDromedary() {
        /*
        let path = UIBezierPath()
        let startX: CGFloat = dromedary.position.x
        let startY: CGFloat = dromedary.position.y + dromedary.size.height
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: startX + dromedary.size.width, y: startY))
        path.addLine(to: CGPoint(x: startX + 462, y: startY - dromedary.size.height - 16))
        path.addLine(to: CGPoint(x: startX + 162, y: startY - dromedary.size.height - 16))
        path.addLine(to: CGPoint(x: startX, y: startY))
        */
        dromedary.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: dromedary.size.height))
        dromedary.physicsBody?.affectedByGravity = true
        dromedary.physicsBody?.isDynamic = true
        dromedary.physicsBody?.allowsRotation = false
        dromedary.physicsBody?.categoryBitMask = dromedaryCategoryBitMask
        dromedary.physicsBody?.collisionBitMask = edgeCollisionMask
        dromedary.physicsBody?.contactTestBitMask = edgeCollisionMask
    }
    
    func animateDromedary() {
        let run01 = SKAction.setTexture(dromedaryAtlas.textureNamed("Dromedar_HaleNed"))
        let run02 = SKAction.setTexture(dromedaryAtlas.textureNamed("DromedarILøb_HaleOp"))
        let run04 = SKAction.setTexture(dromedaryAtlas.textureNamed("Dromedar_HaleOp"))
        let wait = SKAction.wait(forDuration: 0.2)
        let moveUp = SKAction.move(to: CGPoint(x: dromedary.position.x, y: dromedary.position.y + 50), duration: 0.2)
        let moveDown = SKAction.move(to: CGPoint(x: dromedary.position.x, y: dromedary.position.y - 50), duration: 0.2)
        let applyImpulse = SKAction.run {
            self.dromedary.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        }
        let sequence = SKAction.sequence([run01, wait, run02, wait, run01, wait, run02, wait])
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        let group = SKAction.group([sequence,applyImpulse])
        dromedary.run(.repeatForever(group), withKey: "dromedaryWalk")
        dromedary.name = "activeDromedary"
    }
    
    func standingDromedary(){
        let taleDown = SKAction.setTexture(dromedaryAtlas.textureNamed("Dromedar_HaleNed"))
        let taleUp = SKAction.setTexture(dromedaryAtlas.textureNamed("Dromedar_HaleOp"))
        let wait01 = SKAction.wait(forDuration: 0.5)
        let wait02 = SKAction.wait(forDuration: 1.5)
        let sequence = SKAction.sequence([taleDown, wait02, taleUp, wait01])
        dromedary.run(.repeatForever(sequence), withKey: "standingDromedary")


    }
    
    func loadNodes() {
        guard let tileMap = childNode(withName: "tileMap")
                                       as? SKTileMapNode else {
          fatalError("Background node not loaded")
        }

        self.tileMap = tileMap
        tileMap.position = CGPoint(x: 21350, y: 0)
        ground = tileMap.childNode(withName: "ground") as? SKTileMapNode
        let tileSize = ground.tileSize
        let halfWidth = CGFloat(ground.numberOfColumns) / 2 * tileSize.width
        let halfHeight = CGFloat(ground.numberOfRows) / 2 * tileSize.height

        for col in 0..<ground.numberOfColumns {
            for row in 0..<ground.numberOfRows {
                let tileDefinition = ground.tileDefinition(atColumn: col, row: row)
                let isGroundTile = tileDefinition?.userData?["isGround"] as? Bool
                let isDesertTile = tileDefinition?.userData?["isDesert"] as? Bool
                if (isGroundTile == true) {
                    var level : CGFloat = 16
                    if isDesertTile == true {
                        level = 0
                    }
                    let tileDefSize = tileDefinition!.size
                    let tileX = CGFloat(col) * tileSize.width - halfWidth
                    let tileY = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: tileX, y: tileY, width: tileDefSize.width, height: tileDefSize.height - level)
                    print("tileX", tileX)
                    print("tileY", tileY)
                    let tileNode = SKNode()
                    tileNode.position = CGPoint(x: tileX, y: tileY)
                    tileNode.zPosition = 7
                    tileNode.physicsBody = SKPhysicsBody(rectangleOf: rect.size, center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.name = "ground"
                    ground.addChild(tileNode)
                }
            }
        }
        guard let dancer = tileMap.childNode(withName: "Danser") as? SKSpriteNode else {
            fatalError("Dancer not loaded")
        }
        
        self.dancer = dancer
        dancer.name = "dancer"
        
        guard let wizard = tileMap.childNode(withName: "Troldmand") as? SKSpriteNode else {
                fatalError("Wizard not loaded")
        }
        self.wizard = wizard
        wizard.name = "wizard"
        addNodeToWizard()
        
        guard let dromedary = tileMap.childNode(withName: "Dromedar") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.dromedary = dromedary
        dromedary.name = "dromedary"
        
        guard let book = tileMap.childNode(withName: "Bog") as? SKSpriteNode
        else {
            fatalError("Sprite Node not loaded")
        }
        self.book = book
        book.name = "book"
        
        guard let man = childNode(withName: "Man") as? SKSpriteNode else {
        fatalError("Sprite Nodes not loaded")
        }
            self.man = man
        man.name = "man"
        tileMap.zPosition = 0
        mountNose()
        man.physicsBody = SKPhysicsBody(rectangleOf: man.size)
        man.physicsBody?.affectedByGravity = true
        man.physicsBody?.isDynamic = true
        man.physicsBody?.usesPreciseCollisionDetection = false;
        man.physicsBody?.allowsRotation = false
        man.physicsBody?.collisionBitMask = edgeCollisionMask
        
    }
    
    func makeWizNose(){
        wizNose = SKSpriteNode(texture: noseAtlas.textureNamed("TroldeNæseFront02"))
        wizNose.position = CGPoint(x: 6, y: 20)
        wizNose.zPosition = 1
        wizNose.size = CGSize(width: 64, height: 64)
        wizard.addChild(wizNose)
        print("zrotation ", zRotation)
    }
    
    func turnWizard(){
        let turnAction = SKAction.setTexture(wizardAtlas.textureNamed("TroldSide03"))
        wizard.run(turnAction)
        wizNose.texture = noseAtlas.textureNamed("TroldeNæseSide02")
        wizNose.size = CGSize(width: 64, height: 80)
        let noseRotate = SKAction.rotate(toAngle: 3.141593, duration: 0)
        wizNose.run(noseRotate)
        wizNose.position = CGPoint(x: 15, y: 25)
    }
    
    func setWizNoseToFront(){
        wizNose.position = CGPoint(x: 6, y: 20)
        wizNose.size = CGSize(width: 64, height: 64)
        animateNose(noseIMG1: "TroldeNæseFront02", noseIMG2: "TroldeNæseFront01", noseToAni: wizNose)
    }
    
    func setManNoseToFront() {
        nose.position = CGPoint(x: 0, y: 80)
        nose.size = CGSize(width: 64, height: 64)
        animateNose(noseIMG1: "MandNæseFront", noseIMG2: "MandNæseFront02", noseToAni: nose)
    }
    
    func mountWizard(){
        wizardIsMounting = true
        let wait = SKAction.wait(forDuration: 1.5)
        let moveToSelf = SKAction.run {
            self.wizard.move(toParent: self.scene!)
        }
        let jump = SKAction.move(to: CGPoint(x: wizard.position.x, y: wizard.position.y + 200), duration: 0.5)
        let changeTex = SKAction.setTexture(wizardAtlas.textureNamed("TroldSide02"))
        let moveUp = SKAction.move(to: CGPoint(x: dromedary.position.x, y: 300), duration: 1.0)
        let changeTex2 = SKAction.setTexture(wizardAtlas.textureNamed("TroldSide01"))
        let moveNose = SKAction.run { [self] in
            print("zrotation: ", wizNose.zRotation)
            wizNose.zRotation = 0.0
            print("zrotation: ", wizNose.zRotation)
            wizNose.position.x = 90
            animateNose(noseIMG1: "TroldeNæseSide", noseIMG2: "TroldeNæseSide02", noseToAni: wizNose)
        }
        let land = SKAction.move(to: CGPoint(x: dromedary.position.x - 100, y: dromedary.position.y + 100), duration: 0.8)
        let mount = SKAction.run { [self] in
            wizard.move(toParent: self.dromedary)
        }
/*
        let normalizeMan = SKAction.run { [self] in
            let changeManTex = SKAction.setTexture(SKTexture(imageNamed: "MandRidende"))
            man.run(changeManTex)
            man.scale(to: CGSize(width: 232, height: 466))
            man.position = CGPoint(x: 0, y: 0 + man.size.height/2)
            remountNose()

        }
 */
        let sequence = SKAction.sequence([wait, jump, moveToSelf, changeTex, moveUp, changeTex2, moveNose, land, mount])
        wizard.run(sequence, completion: setCanJump)
        wizard.name = "activeDromedary"
    }
    
    func setCanJump(){
        canJump = true
    }
    
    override func startGame() -> Void {
        x = 21350
        gameIsRunning = true
        self.musicPlayer.playMusic(url: "05 Der var engang en mand")
        run()
        startButton.isHidden = true
        schedual()
    }
    func makeEdge() {
        let rect = CGSize(width: self.frame.width, height: 50)
        edge = SKSpriteNode()
        edge.size = rect
        edge.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
        edge.name = "edge"
        addChild(edge)
    }
    func setUpPhysics(){
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = 0.7
    }
    
    func removePhysicsOffScreen(){
        groundMinX += mapSpeed
        ground.enumerateChildNodes(withName: "ground", using: { node, _ in
            let groundNode = node
            
            print("groundNode x pos", groundNode.position.x)
            print("map pos", self.groundMinX)
            if groundNode.position.x < self.groundMinX{
                
                groundNode.removeFromParent()
            }
                                   })
    }
    
    func jump(sprite: SKSpriteNode) {
        let moveSpriteUp = SKAction.move(to: CGPoint(x: sprite.position.x, y: sprite.position.y + 200), duration: 1.2)
        let moveSpriteDown = SKAction.move(to: CGPoint(x: sprite.position.x, y: sprite.position.y), duration: 1.2)
        let wait = SKAction.wait(forDuration: 1.8)
        var jump: SKAction!
        var runAgain: SKAction!
        var noseStartPos: CGFloat!
        if sprite.name == "man" {
            noseStartPos = 16 + nose.size.width/2
            sprite.removeAction(forKey: "walk")
            jump = SKAction.setTexture(manAtlas.textureNamed("MandHop"))
            runAgain = SKAction.run(run)
        }
        if sprite.name == "activeDromedary" {
            noseStartPos = nose.position.x
            sprite.removeAction(forKey: "dromedaryWalk")
            jump = SKAction.setTexture(dromedaryAtlas.textureNamed("DromedarHop"))
            runAgain = SKAction.run(animateDromedary)
        }
        let setNosePos = SKAction.run {
            self.changeNosePosition(position: CGPoint(x: noseStartPos, y: self.nose.position.y))
        }
        let setName = SKAction.run {
            sprite.name = "jumping"
        }
        let speedUpMap = SKAction.run {
            self.mapSpeed += 5
        }
        let speedDownMap = SKAction.run {
            self.mapSpeed -= 5
        }
        let sequence1 = SKAction.sequence([speedUpMap,setNosePos, setName, wait, speedDownMap, runAgain])
        let actionGroup = SKAction.group([sequence1, jump])
        sprite.run(actionGroup)

        
    }
    
    func stop(){
        man.removeAllActions()
        
    }
    
/*    func setRestartButton(){
        startButton.text = "Vil du spille igen?"
        startButton.isHidden = false
    }
*/
    func death(){
        self.musicPlayer.fadeOut()
        mapSpeed = 0
        edge.removeFromParent()
        man.removeAllActions()
        timer5 = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [self] timer in
            let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(restartSign)

        })
        
    }
    
    func animateNose(noseIMG1: String, noseIMG2: String, noseToAni: SKSpriteNode) {
        let redNose = SKAction.setTexture(noseAtlas.textureNamed(noseIMG1))
        let bigRedNose = SKAction.setTexture(noseAtlas.textureNamed(noseIMG2))
        let wait = SKAction.wait(forDuration: 0.2)
        let sequence = SKAction.sequence([redNose, wait, bigRedNose, wait])
        noseToAni.run(.repeatForever(sequence), withKey: "noseBlink")
    }
    
    func changeNosePosition(position: CGPoint){
        noseXPosition = position.x
        let moveNose = SKAction.move(to: CGPoint(x: noseXPosition, y: position.y), duration: 0)
        nose.run(moveNose)
    }
    
    func moveNoseRight(){
        noseXPosition += 10
        let moveNoseRight = SKAction.move(to: CGPoint(x: noseXPosition, y: nose.position.y), duration: 0)
        nose.run(moveNoseRight)
    }
    
    func moveNoseLeft(){
        noseXPosition -= 10
        let moveNoseLeft = SKAction.move(to: CGPoint(x: noseXPosition, y: nose.position.y), duration: 0)
        nose.run(moveNoseLeft)
    }
    
    func bookAni(){
        book.move(toParent: man)
        let moveBook = SKAction.move(to: CGPoint(x: -30, y: -40), duration: 0.3)
        book.run(moveBook)
        book.zPosition = 1
        book.name = "activeDromedary"

        
    }
    
    func run(){
        let duration = 0.2
        let wait = SKAction.wait(forDuration: duration)
        let run1 = SKAction.setTexture(manAtlas.textureNamed("Mand01"))
        let run3 = SKAction.setTexture(manAtlas.textureNamed("Mand02"))
        let moveNoseR = SKAction.run(moveNoseRight)
        let moveNoseL = SKAction.run(moveNoseLeft)
        let sequence = SKAction.sequence([run3, moveNoseR, wait, run1, moveNoseL, wait])
        man.run(.repeatForever(sequence), withKey: "walk")
        man.name = "man"
    }
    
    func collisionDetection(){
        if self.dromedary.intersects(self.book){
            bookAni()
        }
        if self.man.intersects(self.dancer){
            dancerLeave()
        }
        if self.man.intersects(self.dromedary) && !isMounting{
            animateMounting()
        }
        if self.dromedary.intersects(self.wizardEnhancedNode!) && !wizardIsMounting{
            turnWizard()
            meeting()
        }
        if self.man.intersects(self.edge) {
            death()
        }
        if self.dromedary.intersects(self.edge) {
            death()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Body A", contact.bodyA.node?.name)
        print("Body B", contact.bodyB.node?.name)

        if contact.bodyA.node?.name == "edge" && contact.bodyB.node?.name == "man" {
            print("Man edge contact")
            death()
        }
        if contact.bodyA.node?.name == "edge" && contact.bodyB.node?.name == "activeDromedary" {
            death()
        }
        if contact.bodyB.node?.name == "edge" && contact.bodyA.node?.name == "man" {
            print("Man edge contact")
            death()
        }
        if contact.bodyB.node?.name == "edge" && contact.bodyA.node?.name == "activeDromedary" {
            death()
        }

    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if gameIsRunning {
                if touchedNode.name == "man" || touchedNode.name == "activeDromedary" {
                    if canJump {
                        if hasMounted {
                            dromedary.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 2500))
                            jump(sprite: dromedary)
                        }else{
                            man.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 2500))
                            jump(sprite: man)
                        }
                    }
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
 /*   override func backToHome(){
        self.viewController!.performSegue(withIdentifier: "Home", sender: self)
        self.view?.presentScene(nil)

    }
*/
    override func restart(){
        self.viewController.selectGKScene(sceneName: "ThereOnceWasAMan")
    }
  
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func willMove(from view: SKView) {
        timer1?.invalidate()
        timer2?.invalidate()
        timer3?.invalidate()
        timer4?.invalidate()
        self.man.removeAllActions()
        self.man.removeFromParent()
        self.dromedary.removeAllActions()
        self.dromedary.removeFromParent()
        self.dancer.removeAllActions()
        self.dancer.removeFromParent()
        self.wizard.removeAllActions()
        self.wizard.removeFromParent()
        self.nose.removeAllActions()
        self.nose.removeFromParent()
        self.wizNose?.removeAllActions()
        print("Cleaned up")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        if gameIsRunning {
            //checkForEvents(mapLocation: x)
            MyLocation = CGPoint(x: x,y: 0)
            tileMap.position = MyLocation
            x = x - mapSpeed
            gameIsRunning = musicPlayer.isPlaying()
            collisionDetection()
            removePhysicsOffScreen()
            currentXLocInMap += mapSpeed
            checkMapLocation(mapXLocation: currentXLocInMap)
        }else{
            stop()
        }
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        print(dromedary.position.y)
        print(dromedary.size.height)
        print(dromedary.size.width)
    }
    
    override func didEvaluateActions() {
    }
}
