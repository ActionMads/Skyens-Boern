//
//  GameScene.swift
//  Dromedary
//
//  Created by Mads Munk on 21/01/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController: UIViewController?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var tileMap:SKTileMapNode!
    var man:SKSpriteNode!
    var MyLocation = CGPoint(x: 0, y: 0)
    var x: CGFloat = 21818
    var player: AVAudioPlayer?
    var gameIsRunning: Bool = false
    var startButton: SKSpriteNode!
    var sequence: SKAction!
    var mapCollisionMask: UInt32 = 0b0001
    var horseCollisionMask: UInt32 = 0b0010
    var edgeCollisionMask: UInt32 = 0b0100
    var edge: SKNode!
    var mPlayer: MusicPlayer!
    var dromedary: SKSpriteNode!
    var nose: SKSpriteNode!
    var noseXPosition: CGFloat!
    var nosePositionIsUpdated: Bool = false
    var wizard: SKSpriteNode!
    var info: Info!
    var mapSpeed: CGFloat = 5
    var canJump = true
    var book: SKSpriteNode!
    var wizNose: SKSpriteNode!
    var hasMounted: Bool = false
    var dancer: SKSpriteNode!
    
    private var lastUpdateTime : TimeInterval = 0
    
    
    override func sceneDidLoad() {
        loadNodes()
        info = Info()
        startButton = info.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(startButton)
        setUpPhysics()
        makeEdge()
        mPlayer = MusicPlayer()
    }
    
    func checkForEvents(mapLocation: CGFloat){
        if mapLocation < 13000 && mapLocation > 12995 {
            canJump = false
            makeWizNose()
        }
        if mapLocation < 12800 && mapLocation > 12795 {
            animateMounting()
            canJump = true
        }
        if mapLocation < 12700 && mapLocation > 12695 {
            dromedary.move(toParent: self.scene!)
            dromedary.removeAction(forKey: "standingDromedary")
            addPhysicsToDromedary()
            man.physicsBody = nil
            animateDromedary()
            hasMounted = true
        }
        if mapLocation < 18400 && mapLocation > 18395 {
            animateNose(noseIMG1: "NæseRød01", noseIMG2: "NæseRød02", noseToAni: nose)
            animateDancer()
            standingDromedary()

        }
        if mapLocation < 7000 && mapLocation > 6995 {
            turnWizard()
            meeting()
        }
        if mapLocation < -2600 && mapSpeed == 5{
            ending()
        }
    }
    func animateDancer(){
        let move01 = SKAction.setTexture(SKTexture(imageNamed: "DanserMove01"))
        let move02 = SKAction.setTexture(SKTexture(imageNamed: "DanserMove02"))
        let move03 = SKAction.setTexture(SKTexture(imageNamed: "DanserMove03"))
        let move04 = SKAction.setTexture(SKTexture(imageNamed: "DanserMove04"))
        let wait = SKAction.wait(forDuration: 0.2)
        let wait02 = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([move01, wait, move02, wait, move03, wait, move02, wait, move01, wait, move04, wait02])
        dancer.run(.repeatForever(sequence), withKey: "dance")
    }
    
    func animateMounting(){
        man.physicsBody?.affectedByGravity = false
        man.removeAction(forKey: "walk")
        let jump = SKAction.move(to: CGPoint(x: man.position.x, y: dromedary.position.y + dromedary.size.height/2 + man.size.height), duration: 0.5)
        let land = SKAction.move(to: CGPoint(x: man.position.x + 180, y: dromedary.position.y + man.size.height/2), duration: 0.5)
        let jumpTexture = SKAction.setTexture(SKTexture(imageNamed: "MandHop"))
        let landTexture = SKAction.setTexture(SKTexture(imageNamed: "MandRidende"))
        let mountAction = SKAction.run(mountMan)
        let setNosePos = SKAction.run { [self] in
            changeNosePosition(position: CGPoint(x: 16 + nose.size.width/2, y: nose.position.y))
        }
        let sequence = SKAction.sequence([jumpTexture, setNosePos, jump, landTexture, land, mountAction])

        man.run(sequence)
        man.name = "activeDromedary"
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
        let changeToJump = SKAction.setTexture(SKTexture(imageNamed: "TroldSide02"))
        let invert = SKAction.scaleX(to: -1.0, duration: 0)
        let moveUp = SKAction.move(to: CGPoint(x: 70, y: 250), duration: 0.5)
        let land = SKAction.move(to: CGPoint(x: 130, y: -360 + wizard.size.height/2), duration: 0.5)
        let changeToFront = SKAction.setTexture(SKTexture(imageNamed: "TroldeFront"))
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
        let changeToJump = SKAction.setTexture(SKTexture(imageNamed: "MandHop"))
        let moveUp = SKAction.move(to: CGPoint(x: 100, y: 250), duration: 0.5)

        let land = SKAction.move(to: CGPoint(x: 550, y: -360 + man.size.height/2), duration: 0.5)
        let changeToFront = SKAction.setTexture(SKTexture(imageNamed: "ManForfra"))
        let sequence = SKAction.sequence([moveToScene, wait, changeToJump, moveUp, land, changeToFront])
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
            let endSign = info.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
            addChild(endSign)
        }
        let celebAction = SKAction.run(celebrationAni)
        let seq = SKAction.sequence([wait, endAction])
        let group = SKAction.group([celebAction, seq])
        self.run(group)
        
    }
    
    func openBook(){
        book.texture = SKTexture(imageNamed: "BogÅben")
        let changePos = SKAction.move(to: CGPoint(x: -book.size.width, y: 0), duration: 0)
        book.run(changePos)
    }
    
    func mountMan() {
        man.move(toParent: dromedary)
    }
    
    func mountNose() {
        nose = SKSpriteNode(imageNamed: "NæseGrå.png")
        nose.size = CGSize(width: 70, height: 84)
        nose.name = "nose"
        noseXPosition = man.position.x + 16 + nose.size.width/2
        nose.position = CGPoint(x: noseXPosition, y: -17)
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
        let change = SKAction.setTexture(SKTexture(imageNamed: "MandBøjet"))
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
        dromedary.physicsBody?.affectedByGravity = false
        dromedary.physicsBody?.allowsRotation = false
        dromedary.physicsBody?.restitution = 1
        dromedary.physicsBody?.categoryBitMask = horseCollisionMask
        dromedary.physicsBody?.collisionBitMask = edgeCollisionMask | mapCollisionMask
        dromedary.physicsBody?.contactTestBitMask = edgeCollisionMask
    }
    
    func animateDromedary() {
        let run01 = SKAction.setTexture(SKTexture(imageNamed: "Dromedar_HaleNed"))
        let run02 = SKAction.setTexture(SKTexture(imageNamed: "DromedarILøb_HaleOp"))
        let run04 = SKAction.setTexture(SKTexture(imageNamed: "Dromedar_HaleOp"))
        let wait = SKAction.wait(forDuration: 0.2)
        let moveUp = SKAction.move(to: CGPoint(x: dromedary.position.x, y: dromedary.position.y + 50), duration: 0.2)
        let moveDown = SKAction.move(to: CGPoint(x: dromedary.position.x, y: dromedary.position.y - 50), duration: 0.2)
        let sequence = SKAction.sequence([run01, wait, run02, wait, run01, wait, run02, wait])
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        let group = SKAction.group([sequence,moveSequence])
        dromedary.run(.repeatForever(group), withKey: "dromedaryWalk")
        dromedary.name = "activeDromedary"
    }
    
    func standingDromedary(){
        let taleDown = SKAction.setTexture(SKTexture(imageNamed: "Dromedar_HaleNed"))
        let taleUp = SKAction.setTexture(SKTexture(imageNamed: "Dromedar_HaleOp"))
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
        tileMap.position = CGPoint(x: 21818, y: 0)
        let ground = tileMap.childNode(withName: "ground") as! SKTileMapNode
        let tileSize = ground.tileSize
        let halfWidth = CGFloat(ground.numberOfColumns) / 2 * tileSize.width
        let halfHeight = CGFloat(ground.numberOfRows) / 2 * tileSize.height

        for col in 0..<ground.numberOfColumns {
            for row in 0..<ground.numberOfRows {
                let tileDefinition = ground.tileDefinition(atColumn: col, row: row)
                let isGroundTile = tileDefinition?.userData?["isGround"] as? Bool
                let isDesert = tileDefinition?.userData?["isDesert"] as? Bool
                if (isGroundTile ?? false) {
                    var level: CGFloat = 16
                    if isDesert == true {
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
                    tileNode.physicsBody?.categoryBitMask = mapCollisionMask
                    tileNode.physicsBody?.collisionBitMask = horseCollisionMask
                    ground.addChild(tileNode)
                }
            }
        }
        guard let dancer = tileMap.childNode(withName: "Danser") as? SKSpriteNode else {
            fatalError("Dancer not loaded")
        }
        
        self.dancer = dancer
        
        guard let wizard = tileMap.childNode(withName: "Troldmand") as? SKSpriteNode else {
                fatalError("Wizard not loaded")
        }
        self.wizard = wizard
        
        guard let dromedary = tileMap.childNode(withName: "Dromedar") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        self.dromedary = dromedary
        
        guard let book = tileMap.childNode(withName: "Bog") as? SKSpriteNode
        else {
            fatalError("Sprite Node not loaded")
        }
        self.book = book
        
        guard let man = childNode(withName: "Man") as? SKSpriteNode else {
        fatalError("Sprite Nodes not loaded")
        }
            self.man = man
        man.name = "man"
        tileMap.zPosition = 0
        mountNose()
        man.physicsBody = SKPhysicsBody(rectangleOf: man.size)
        man.physicsBody?.affectedByGravity = false
        man.physicsBody?.isDynamic = true
        man.physicsBody?.usesPreciseCollisionDetection = true;
        man.physicsBody?.allowsRotation = false
        man.physicsBody?.contactTestBitMask = edgeCollisionMask
        man.physicsBody?.categoryBitMask = horseCollisionMask
        man.physicsBody?.collisionBitMask = mapCollisionMask | edgeCollisionMask
        
    }
    
    func makeWizNose(){
        wizNose = SKSpriteNode(imageNamed: "TroldeNæseFront02")
        wizNose.position = CGPoint(x: 6, y: 20)
        wizNose.zPosition = 3
        wizNose.size = CGSize(width: 64, height: 64)
        wizard.addChild(wizNose)
        print("zrotation ", zRotation)
    }
    
    func turnWizard(){
        let turnAction = SKAction.setTexture(SKTexture(imageNamed: "TroldSide03"))
        wizard.run(turnAction)
        wizNose.texture = SKTexture(imageNamed: "TroldeNæseSide02")
        wizNose.size = CGSize(width: 64, height: 80)
        let noseRotate = SKAction.rotate(toAngle: 3.141593, duration: 0)
        wizNose.run(noseRotate)
        wizNose.position = CGPoint(x: -28, y: 36)
    }
    
    func setWizNoseToFront(){
        wizNose.position = CGPoint(x: 6, y: 20)
        wizNose.size = CGSize(width: 64, height: 64)
        animateNose(noseIMG1: "TroldeNæseFront02", noseIMG2: "TroldeNæseFront01", noseToAni: wizNose)
    }
    
    func mountWizard(){
        let wait = SKAction.wait(forDuration: 1.5)
        let moveToSelf = SKAction.run {
            self.wizard.move(toParent: self.scene!)
        }
        let jump = SKAction.move(to: CGPoint(x: wizard.position.x, y: wizard.position.y + 200), duration: 0.5)
        let changeTex = SKAction.setTexture(SKTexture(imageNamed: "TroldSide02"))
        let moveUp = SKAction.move(to: CGPoint(x: -450, y: 300), duration: 1.0)
        let changeTex2 = SKAction.setTexture(SKTexture(imageNamed: "TroldSide01"))
        let moveNose = SKAction.run { [self] in
            print("zrotation: ", wizNose.zRotation)
            wizNose.zRotation = 0.0
            print("zrotation: ", wizNose.zRotation)
            wizNose.position.x = 118
            animateNose(noseIMG1: "TroldeNæseSide", noseIMG2: "TroldeNæseSide02", noseToAni: wizNose)
        }
        let land = SKAction.move(to: CGPoint(x: dromedary.position.x - 150, y: dromedary.position.y + 184), duration: 0.8)
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
        wizard.run(sequence)
        wizard.name = "activeDromedary"
    }
    
    func startGame() -> Void {
        x = 21818
        gameIsRunning = true
        mPlayer.playMusic(url: "05 Der var engang en mand")
        run()
        startButton.isHidden = true
    }
    func makeEdge() {
        let rect = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: 100)
        edge = SKNode()
        edge.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        edge.physicsBody?.isDynamic = false
        edge.physicsBody?.categoryBitMask = edgeCollisionMask
        edge.physicsBody?.node?.name = "edge"
        addChild(edge)
    }
    func setUpPhysics(){
        self.physicsWorld.contactDelegate = self
    }
    
    func jump(sprite: SKSpriteNode) {
        print(man.position.x)
        let moveSpriteUp = SKAction.move(to: CGPoint(x: sprite.position.x, y: sprite.position.y + 200), duration: 1.2)
        let moveSpriteDown = SKAction.move(to: CGPoint(x: sprite.position.x, y: sprite.position.y), duration: 1.2)
        var jump: SKAction!
        var runAgain: SKAction!
        var noseStartPos: CGFloat!
        if sprite.name == "man" {
            noseStartPos = 16 + nose.size.width/2
            sprite.removeAction(forKey: "walk")
            jump = SKAction.setTexture(SKTexture(imageNamed: "MandHop"))
            runAgain = SKAction.run(run)
        }
        if sprite.name == "activeDromedary" {
            noseStartPos = nose.position.x
            sprite.removeAction(forKey: "dromedaryWalk")
            jump = SKAction.setTexture(SKTexture(imageNamed: "DromedarHop"))
            runAgain = SKAction.run(animateDromedary)
        }
        let setNosePos = SKAction.run {
            self.changeNosePosition(position: CGPoint(x: noseStartPos, y: self.nose.position.y))
        }
        let setName = SKAction.run {
            sprite.name = "jumping"
        }
        let sequence1 = SKAction.sequence([setNosePos, setName, moveSpriteUp, moveSpriteDown, runAgain])
        let actionGroup = SKAction.group([sequence1, jump])
        sprite.run(actionGroup)

        
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "05 Der var engang en mand", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()
            

        } catch let error {
            print(error.localizedDescription)
        }
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
        mPlayer?.stopMusic()
        mapSpeed = 0
        let restartSign = info.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY), Size: CGSize(width: 564, height: 426))
        addChild(restartSign)
        
    }
    
    func animateNose(noseIMG1: String, noseIMG2: String, noseToAni: SKSpriteNode) {
        let redNose = SKAction.setTexture(SKTexture(imageNamed: noseIMG1))
        let bigRedNose = SKAction.setTexture(SKTexture(imageNamed: noseIMG2))
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
        let moveBook = SKAction.move(to: CGPoint(x: -30, y: 0), duration: 0.3)
        book.run(moveBook)
        book.zPosition = 1
        book.name = "activeDromedary"

        
    }
    
    func run(){
        let duration = 0.2
        let wait = SKAction.wait(forDuration: duration)
        let run1 = SKAction.setTexture(SKTexture(imageNamed: "Mand01"))
        let run3 = SKAction.setTexture(SKTexture(imageNamed: "Mand02"))
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
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "edge" && contact.bodyB.node?.name == "man" {
            death()
        }
        /*if contact.bodyA.node?.name == "edge" && contact.bodyB.node?.name == "activeDromedary" {
            death()
        } */

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
                            jump(sprite: dromedary)
                        }else{
                            jump(sprite: man)
                        }
                    }
                }
            }
            if touchedNode.name == "yes" || touchedNode.name == "no"{
                info.setTextureButton(button: touchedNode as! SKSpriteNode)
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
            if touchedNode.name == "startBtn"{
                startGame()
                
            }
            if touchedNode.name == "yes"{
                restartScene()
            }
            if touchedNode.name == "no"{
                backToHome()
            }
        }
    }
    
    func backToHome(){
        self.viewController!.performSegue(withIdentifier: "Home", sender: nil)
    }
    
    func restartScene(){
        if let scene = GKScene(fileNamed: "GameScene.sks") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            checkForEvents(mapLocation: x)
            MyLocation = CGPoint(x: x,y: 0)
            tileMap.position = MyLocation
            x = x - mapSpeed
            print("mapLocation: ", x)
            gameIsRunning = mPlayer!.isPlaying()
            collisionDetection()
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
