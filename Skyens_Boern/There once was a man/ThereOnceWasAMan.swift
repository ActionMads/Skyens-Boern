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
    var nose: SKSpriteNode!
    var noseXPosition: CGFloat!
    var nosePositionIsUpdated: Bool = false
    var wizard: SKSpriteNode!
    var mapSpeed: CGFloat = 5
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
    var timer6 : Timer?
    let manAtlas : SKTextureAtlas = SKTextureAtlas(named: "Man")
    let wizardAtlas : SKTextureAtlas = SKTextureAtlas(named: "Wizard")
    let dromedaryAtlas : SKTextureAtlas = SKTextureAtlas(named: "Dromedary")
    let dancerAtlas : SKTextureAtlas = SKTextureAtlas(named: "Dancer")
    let bookAtlas : SKTextureAtlas = SKTextureAtlas(named: "Book")
    let noseAtlas : SKTextureAtlas = SKTextureAtlas(named: "Nose")
    var firstSpeak : SKSpriteNode = SKSpriteNode()
    var secondSpeak : SKSpriteNode = SKSpriteNode()
    var theirdSpeak : SKSpriteNode = SKSpriteNode()
    var fourthSpeak : SKSpriteNode = SKSpriteNode()
    var fithSpeak : SKSpriteNode = SKSpriteNode()
    var sixthSpeak : SKSpriteNode = SKSpriteNode()
    var seventhSpeak : SKSpriteNode = SKSpriteNode()
    var eigthSpeak : SKSpriteNode = SKSpriteNode()
    var ninthSpeak : SKSpriteNode = SKSpriteNode()
    var tenthSpeak : SKSpriteNode = SKSpriteNode()
    var eleventhSpeak : SKSpriteNode = SKSpriteNode()

    private var lastUpdateTime : TimeInterval = 0
    
    // When Scene loads setup game elements
    override func sceneDidLoad() {
        loadNodes()
        startButton = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startButton)
        setUpPhysics()
        makeEdge()
        addCamera()
        self.makeBackBtn()
        self.makeHelpBtn()
        self.speakPlayer.setVolume(vol: 10)
        canJump = true

    }
    
    // Add a cameranode to scale the scene according to the screen size
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
        let scale = playableAreaScaleForIpadAndIphone*2
        self.setSizeDivider(scale: scale)
        self.camera = camera
        self.addChild(self.camera!)
    }
    
    // schedual with timers activating scene events
    func schedual(){
        timer2 = Timer.scheduledTimer(withTimeInterval: 25, repeats: false, block: { [self] timer in
            print("second event")
            animateNose(noseIMG1: "NæseRød01", noseIMG2: "NæseRød02", noseToAni: nose)
            animateDancer()
        })

        timer3 = Timer.scheduledTimer(withTimeInterval: 50, repeats: false, block: { [self] timer in
            standingDromedary()

        })
        
        //mounting

        timer4 = Timer.scheduledTimer(withTimeInterval: 70, repeats: false, block: { [self] timer in
            makeWizNose()
        })
        
        timer5 = Timer.scheduledTimer(withTimeInterval: 170, repeats: false, block: { [self] timer in
            ending()
        })
        

    }
    
    // check where in the map hero is
    func checkMapLocation(mapXLocation : CGFloat){
        if mapXLocation >= -13500 && mapXLocation <= -13490 {
            canJump = false
        }
        if mapXLocation >= -5200 && mapXLocation <= -5190{
            canJump = false
        }
    }
    
    // Dancer animation
    func animateDancer(){
        let move01 = SKAction.setTexture(dancerAtlas.textureNamed("DanserMove01"))
        let move02 = SKAction.setTexture(dancerAtlas.textureNamed("DanserMove02"))
        let move03 = SKAction.setTexture(dancerAtlas.textureNamed("DanserMove03"))
        let move04 = SKAction.setTexture(dancerAtlas.textureNamed("DanserMove04"))
        let wait = SKAction.wait(forDuration: 0.2)
        let wait02 = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([move01, wait, move02, wait, move03, wait, move02, wait, move01, wait, move04, wait02])
        dancer.run(.repeatForever(sequence), withKey: "dance")
    }
    
    // add hidden enhanced node to wizard
    func addNodeToWizard(){
        wizardEnhancedNode = SKSpriteNode()
        wizardEnhancedNode!.name = "enhancedNode"
        wizardEnhancedNode!.size = CGSize(width: 600, height: wizard.size.height)
        wizardEnhancedNode!.zPosition = -1
        wizard.addChild(wizardEnhancedNode!)
    }
    
    // Dancer leaves animation
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
    
    // Remove Dancer
    func removeDancer() {
        dancer.removeAllActions()
        dancer.removeFromParent()
    }
    
    // Animate man mounting dromedary
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
    
    // Activate dromedary and add physics
    func activateDromedary(){
        dromedary.move(toParent: self.scene!)
        dromedary.removeAction(forKey: "standingDromedary")
        addPhysicsToDromedary()
        man.physicsBody = nil
        animateDromedary()
        hasMounted = true
        canJump = true
    }
    
    // Start ending
    func ending(){
        mapSpeed = 0
        dromedary.removeAllActions()
        defaults.set(true, forKey: "thereOnceWasAManCompleted")
        unMountMan()
        unMountWizard()
    }
    
    // Unmount the wizard from the dromedary and land on ground facing front
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
    
    // Unmount the man and land on ground facing front
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
    
    // man and wizard celebration animation
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
    
    // Add end sign and start celebration action
    func endSign(){
        let wait = SKAction.wait(forDuration: 5.0)
        let endAction = SKAction.run { [self] in
            let endSign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(endSign)
            playSpeakNoMusic(name: "Speak DVEEM12")
        }
        let celebAction = SKAction.run(celebrationAni)
        let seq = SKAction.sequence([wait, endAction])
        let group = SKAction.group([celebAction, seq])
        self.run(group)
        
    }
    
    // Open the book animation
    func openBook(){
        book.texture = bookAtlas.textureNamed("BogÅben")
        let changePos = SKAction.move(to: CGPoint(x: -book.size.width, y: 0), duration: 0)
        book.run(changePos)
    }
    
    // Mount the man
    func mountMan() {
        man.move(toParent: dromedary)
    }
    
    // Mount man nose
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
    }
    
    // remount nose
    func remountNose(){
        let rotateAction = SKAction.rotate(byAngle: +.pi/2, duration: 0)
        changeNosePosition(position: CGPoint(x: noseXPosition + 26, y: man.position.y - 110))
        nose.run(rotateAction)
    }
      
    // Man meeting wizard
    func meeting(){
        mountWizard()
    }
    
    //
    func manMeetingAni(){
        let change = SKAction.setTexture(manAtlas.textureNamed("MandBøjet"))
        man.run(change)
        man.position = CGPoint(x: man.position.x + 80, y: man.position.y - 100)
        man.scale(to: CGSize(width: 320, height: 256))
        noseMeetingAni()
    }
    
    // nose meeting animation
    func noseMeetingAni(){
        let rotatateAction = SKAction.rotate(byAngle: -.pi/2, duration: 0)
        changeNosePosition(position: CGPoint(x: man.position.x - 14, y: man.position.y - 78))
        nose.run(rotatateAction)
    }
    
    // Add Physics to dromedary
    func addPhysicsToDromedary() {
        dromedary.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: dromedary.size.height))
        dromedary.physicsBody?.affectedByGravity = true
        dromedary.physicsBody?.isDynamic = true
        dromedary.physicsBody?.allowsRotation = false
        dromedary.physicsBody?.categoryBitMask = dromedaryCategoryBitMask
        dromedary.physicsBody?.collisionBitMask = edgeCollisionMask
        dromedary.physicsBody?.contactTestBitMask = edgeCollisionMask
    }
    
    // Animate dromedary walk
    func animateDromedary() {
        let run01 = SKAction.setTexture(dromedaryAtlas.textureNamed("Dromedar_HaleNed"))
        let run02 = SKAction.setTexture(dromedaryAtlas.textureNamed("DromedarILøb_HaleOp"))
        let wait = SKAction.wait(forDuration: 0.2)
        let applyImpulse = SKAction.run {
            self.dromedary.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        }
        let sequence = SKAction.sequence([run01, wait, run02, wait, run01, wait, run02, wait])
        let group = SKAction.group([sequence,applyImpulse])
        dromedary.run(.repeatForever(group), withKey: "dromedaryWalk")
        dromedary.name = "activeDromedary"
    }
    
    // Standin dromedary animation
    func standingDromedary(){
        let taleDown = SKAction.setTexture(dromedaryAtlas.textureNamed("Dromedar_HaleNed"))
        let taleUp = SKAction.setTexture(dromedaryAtlas.textureNamed("Dromedar_HaleOp"))
        let wait01 = SKAction.wait(forDuration: 0.5)
        let wait02 = SKAction.wait(forDuration: 1.5)
        let sequence = SKAction.sequence([taleDown, wait02, taleUp, wait01])
        dromedary.run(.repeatForever(sequence), withKey: "standingDromedary")


    }
    
    // Load tilemap nodes
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
            fatalError("Sprite Nodes did not load")
        }
        self.dromedary = dromedary
        dromedary.name = "dromedary"
        
        guard let book = tileMap.childNode(withName: "Bog") as? SKSpriteNode
        else {
            fatalError("Sprite Nodes did not load")
        }
        self.book = book
        book.name = "book"
        
        guard let man = childNode(withName: "Man") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        
        guard let firstSpeak = tileMap.childNode(withName: "FirstSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.firstSpeak = firstSpeak
        guard let secondSpeak = tileMap.childNode(withName: "SecondSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.secondSpeak = secondSpeak
        guard let theirdSpeak = tileMap.childNode(withName: "TheirdSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.theirdSpeak = theirdSpeak
        guard let fourthSpeak = tileMap.childNode(withName: "FourthSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.fourthSpeak = fourthSpeak
        guard let fithSpeak = tileMap.childNode(withName: "FifthSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.fithSpeak = fithSpeak
        guard let sixthSpeak = tileMap.childNode(withName: "SixthSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.sixthSpeak = sixthSpeak
        guard let seventhSpeak = tileMap.childNode(withName: "SeventhSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.seventhSpeak = seventhSpeak
        guard let eigthSpeak = tileMap.childNode(withName: "EigthSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.eigthSpeak = eigthSpeak
        guard let ninthSpeak = tileMap.childNode(withName: "NinthSpeak") as? SKSpriteNode else {
            fatalError("Sprite Nodes did not load")
        }
        self.ninthSpeak = ninthSpeak
        guard let tenthSpeak = tileMap.childNode(withName: "TenthSpeak") as? SKSpriteNode else {
            fatalError("Sprite nodes did not load")
        }
        self.tenthSpeak = tenthSpeak
        guard let eleventhSpeak = tileMap.childNode(withName: "EleventhSpeak") as? SKSpriteNode else {
            fatalError("Sprite nodes did not load")
        }
        self.eleventhSpeak = eleventhSpeak
        self.man = man
        man.name = "man"
        tileMap.zPosition = 0
        // Mount mans nose
        mountNose()
        // Add physics to man
        man.physicsBody = SKPhysicsBody(rectangleOf: man.size)
        man.physicsBody?.affectedByGravity = true
        man.physicsBody?.isDynamic = true
        man.physicsBody?.usesPreciseCollisionDetection = false;
        man.physicsBody?.allowsRotation = false
        man.physicsBody?.collisionBitMask = edgeCollisionMask
        
    }
    
    // Make the wizards nose
    func makeWizNose(){
        wizNose = SKSpriteNode(texture: noseAtlas.textureNamed("TroldeNæseFront02"))
        wizNose.position = CGPoint(x: 6, y: 20)
        wizNose.zPosition = 1
        wizNose.size = CGSize(width: 64, height: 64)
        wizard.addChild(wizNose)
    }
    
    // Turn wizard
    func turnWizard(){
        let turnAction = SKAction.setTexture(wizardAtlas.textureNamed("TroldSide03"))
        wizard.run(turnAction)
        wizNose.texture = noseAtlas.textureNamed("TroldeNæseSide02")
        wizNose.size = CGSize(width: 64, height: 80)
        let noseRotate = SKAction.rotate(toAngle: 3.141593, duration: 0)
        wizNose.run(noseRotate)
        wizNose.position = CGPoint(x: -30, y: 25)
    }
    
    // Set wizard nose to face front
    func setWizNoseToFront(){
        wizNose.position = CGPoint(x: 6, y: 20)
        wizNose.size = CGSize(width: 64, height: 64)
        animateNose(noseIMG1: "TroldeNæseFront02", noseIMG2: "TroldeNæseFront01", noseToAni: wizNose)
    }
    
    // Set mans nose to face front
    func setManNoseToFront() {
        nose.position = CGPoint(x: 0, y: 80)
        nose.size = CGSize(width: 64, height: 64)
        animateNose(noseIMG1: "MandNæseFront", noseIMG2: "MandNæseFront02", noseToAni: nose)
    }
    
    // Mount the wizard to the dromedary
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
            wizard.zPosition = 5
        }
        let sequence = SKAction.sequence([wait, jump, moveToSelf, changeTex, moveUp, changeTex2, moveNose, land, mount])
        wizard.run(sequence, completion: setCanJump)
        wizard.name = "activeDromedary"
    }
    
    // Set the can jump boolean
    func setCanJump(){
        canJump = true
    }
    
    // start the game
    override func startGame() -> Void {
        x = 21350
        gameIsRunning = true
        self.musicPlayer.play(url: "05 Der var engang en mand")
        walk()
        startButton.isHidden = true
        schedual()
    }
    
    // Make the edgenode
    func makeEdge() {
        let rect = CGSize(width: self.frame.width, height: 50)
        edge = SKSpriteNode()
        edge.size = rect
        edge.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
        edge.name = "edge"
        addChild(edge)
    }
    
    // Set up physic in the scene
    func setUpPhysics(){
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = 1.0
    }
    
    // Remove physics objects off screen
    func removePhysicsOffScreen(){
        groundMinX += mapSpeed
        ground.enumerateChildNodes(withName: "ground", using: { node, _ in
            let groundNode = node
            
            if groundNode.position.x < self.groundMinX{
                
                groundNode.removeFromParent()
            }
                                   })
    }
    
    // Jump animation for man and dromedary
    override func jump(sprite: SKSpriteNode) {
        let wait = SKAction.wait(forDuration: 1.8)
        var jump: SKAction!
        var runAgain: SKAction!
        var noseStartPos: CGFloat!
        if sprite.name == "man" {
            noseStartPos = 16 + nose.size.width/2
            sprite.removeAction(forKey: "walk")
            jump = SKAction.setTexture(manAtlas.textureNamed("MandHop"))
            runAgain = SKAction.run(walk)
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
    
    // stop all action on man
    func stop(){
        man.removeAllActions()
    }
    
    // If man dies do this
    func death(){
        self.musicPlayer.fadeOut()
        mapSpeed = 0
        gameIsRunning = false
        physicsWorld.speed = 0.1
        timer5?.invalidate()
        timer6 = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [self] timer in
            let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(restartSign)
            playSpeakNoMusic(name: "Speak DVEEM13")
        })
    }
    
    // Animate the nose
    func animateNose(noseIMG1: String, noseIMG2: String, noseToAni: SKSpriteNode) {
        let redNose = SKAction.setTexture(noseAtlas.textureNamed(noseIMG1))
        let bigRedNose = SKAction.setTexture(noseAtlas.textureNamed(noseIMG2))
        let wait = SKAction.wait(forDuration: 0.2)
        let sequence = SKAction.sequence([redNose, wait, bigRedNose, wait])
        noseToAni.run(.repeatForever(sequence), withKey: "noseBlink")
    }
    
    // Change the nose position when man animates
    func changeNosePosition(position: CGPoint){
        noseXPosition = position.x
        let moveNose = SKAction.move(to: CGPoint(x: noseXPosition, y: position.y), duration: 0)
        nose.run(moveNose)
    }
    
    // Move nose right
    func moveNoseRight(){
        noseXPosition += 10
        let moveNoseRight = SKAction.move(to: CGPoint(x: noseXPosition, y: nose.position.y), duration: 0)
        nose.run(moveNoseRight)
    }
    
    // Move nose left
    func moveNoseLeft(){
        noseXPosition -= 10
        let moveNoseLeft = SKAction.move(to: CGPoint(x: noseXPosition, y: nose.position.y), duration: 0)
        nose.run(moveNoseLeft)
    }
    
    // Book animations when meet by heros
    func bookAni(){
        book.move(toParent: man)
        let moveBook = SKAction.move(to: CGPoint(x: -30, y: -40), duration: 0.3)
        book.run(moveBook)
        book.zPosition = 1
        book.name = "activeDromedary"
    }
    
    // Run/walk
    func walk(){
        let duration = 0.2
        let wait = SKAction.wait(forDuration: duration)
        let walk1 = SKAction.setTexture(manAtlas.textureNamed("Mand01"))
        let walk3 = SKAction.setTexture(manAtlas.textureNamed("Mand02"))
        let moveNoseR = SKAction.run(moveNoseRight)
        let moveNoseL = SKAction.run(moveNoseLeft)
        let sequence = SKAction.sequence([walk3, moveNoseR, wait, walk1, moveNoseL, wait])
        man.run(.repeatForever(sequence), withKey: "walk")
        man.name = "man"
    }
    
    // collision detection
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
            speakPlayer.play(url: "Speak DVEEM 10")
            turnWizard()
            meeting()
        }
        if self.man.intersects(self.edge) {
            death()
        }
        if self.man.intersects(self.firstSpeak) {
            playSpeak(name: "Speak DVEEM1", length: 1)
            firstSpeak.removeFromParent()
        }
        if self.man.intersects(self.secondSpeak) {
            playSpeak(name: "Speak DVEEM2", length: 4)
            secondSpeak.removeFromParent()
        }
        if self.man.intersects(self.theirdSpeak) {
            playSpeak(name: "Speak DVEEM4", length: 1)
            theirdSpeak.removeFromParent()
        }
        if self.man.intersects(self.fourthSpeak) {
            playSpeak(name: "Speak DVEEM3", length: 2)
            fourthSpeak.removeFromParent()
        }
        if self.man.intersects(self.fithSpeak) {
            playSpeak(name: "Speak DVEEM5", length: 3)
            fithSpeak.removeFromParent()
        }
        if self.man.intersects(self.sixthSpeak) {
            playSpeak(name: "Speak DVEEM6", length: 2)
            sixthSpeak.removeFromParent()
        }
        if self.man.intersects(self.seventhSpeak) {
            playSpeak(name: "Speak DVEEM7", length: 2)
            seventhSpeak.removeFromParent()
        }
        if self.man.intersects(self.eigthSpeak){
            playSpeak(name: "Speak DVEEM8", length: 2)
            eigthSpeak.removeFromParent()
        }
        if self.man.intersects(self.ninthSpeak) {
            playSpeak(name: "Speak DVEEM9", length: 2)
            ninthSpeak.removeFromParent()
        }
        if self.man.intersects(self.tenthSpeak) {
            playSpeak(name: "Speak DVEEM10", length: 4)
            tenthSpeak.removeFromParent()
        }
        if self.man.intersects(self.eleventhSpeak) {
            playSpeak(name: "Speak DVEEM11", length: 1)
            eleventhSpeak.removeFromParent()
        }
        if self.dromedary.intersects(self.edge) {
            death()
        }
    }
    
    // Restart the scene
    override func restart(){
        self.viewController.selectGKScene(sceneName: "ThereOnceWasAMan")
    }
    
    // Clean before moving from scene
    override func willMove(from view: SKView) {
        timer1?.invalidate()
        timer2?.invalidate()
        timer3?.invalidate()
        timer4?.invalidate()
        timer5?.invalidate()
        timer6?.invalidate()
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
    
    // Gameloop update
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        if gameIsRunning {
            MyLocation = CGPoint(x: x,y: 0)
            tileMap.position = MyLocation
            x = x - mapSpeed
            collisionDetection()
            removePhysicsOffScreen()
            currentXLocInMap += mapSpeed
            checkMapLocation(mapXLocation: currentXLocInMap)
        }
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
