//
//  GameScene.swift
//  Eventyr V2
//
//  Created by Mads Munk on 13/02/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class Adventure: Scene, SKPhysicsContactDelegate {
    
    weak var tileMap: SKTileMapNode!
    var mapLocation: CGPoint!
	var x: CGFloat = 20000
    var ship: SKSpriteNode!
    var morphPoint1: TimeInterval = 47.0
	var bounds: CGPoint = CGPoint(x: 0, y: 0)
    var isFiring: Bool = false
    var health: Int32 = 2
    var enemyIsRemoved: Bool = true
    var startBtn: SKSpriteNode!
    var playableRect: CGRect!
	var healthBar: SKSpriteNode!
    let shipMovePointsPerSec: CGFloat = 240.0
    var velocity = CGPoint(x: 0, y: 0)
	private var hasTouchedShip: Bool = false
    private var lastUpdateTime : TimeInterval = 0
    private var dt: TimeInterval = 0
	private var isMorphed: Bool = false
	private var enemyIsHit: Bool = false
	private var isSpace: Bool = false
	private let mapCollisionMask: UInt32 = 1
	private let shipCollisionMask: UInt32 = 2
	private let bulletCollisionMask: UInt32 = 3
	private let enemyCollisionMask: UInt32 = 4
	private let edgeCollisonMask: UInt32 = 5
	private var bulletTexture: SKTexture!
	var mapSpeed: CGFloat = 7
	let VISCOSITY: CGFloat = 6 //Increase to make the water "thicker/stickier," creating more friction.
    let BUOYANCY: CGFloat = 0.4 //Slightly increase to make the object "float up faster," more buoyant.
    let OFFSET: CGFloat = 70 //Increase to make the object float to the surface higher.
	var forground: SKTileMapNode!
	let menuAtlas : SKTextureAtlas = SKTextureAtlas(named: "MenuBar")
	let heroAtlas : SKTextureAtlas = SKTextureAtlas(named: "Hero")
	let enemyAtlas : SKTextureAtlas = SKTextureAtlas(named: "Enemies")
	let explosionAtlas : SKTextureAtlas = SKTextureAtlas(named: "Explosion")

    
	func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 10
		shape.zPosition = 2
        addChild(shape)
    }
    
    func makePlayableArea() {
		self.playableRect = CGRect(x: self.frame.minX, y: self.frame.minY,
								   width: self.frame.width,
								   height: self.frame.height)
		print("Frame width", self.frame.width)
		debugDrawPlayableArea()
    }
    
    override func sceneDidLoad() {
		self.physicsWorld.contactDelegate = self
        setUpGame()
		self.makeBackBtn()
    }
    
	func checkMapLocation(location: CGFloat){
		if location < 20000 && location > 19990 {
			bulletTexture = heroAtlas.textureNamed("Skud_Skib")
			rotateShip()
			self.run(SKAction.repeatForever( SKAction.sequence([SKAction.run(self.spawnWaterEnemy),SKAction.wait(forDuration: 4.0)])), withKey: "spawnWaterEnemy")
		}
		if location < 11000 && location > 10990 {
			self.removeAction(forKey: "spawnWaterEnemy")
		}
		if location < 10100 && location > 10090 {
			self.bulletTexture = heroAtlas.textureNamed("Skud_Fly")
			self.rotateShipToCenter()
			self.bounds = CGPoint(x: self.playableRect.minX, y: self.playableRect.minY + 200)
			self.morph()
			self.ship.removeAction(forKey: "rotateAction")
			self.run(SKAction.repeatForever( SKAction.sequence([SKAction.run(self.spawnAirEnemy),SKAction.wait(forDuration: 3.0)])), withKey: "spawnAirEnemy")
		}
		if location < 1000 && location > 990 {
			self.removeAction(forKey: "spawnAirEnemy")
		}
		if location < -100 && location > -110 {
			self.bulletTexture = heroAtlas.textureNamed("Skud_Rum")
			self.bounds = CGPoint(x: self.playableRect.minX, y: self.playableRect.minY + self.ship.size.height/2)
			self.morphToSpace()
						self.run(SKAction.repeatForever( SKAction.sequence([SKAction.run(self.spawnSpaceEnemy),SKAction.wait(forDuration: 3.0)])), withKey: "spawnSpaceEnemy")
		}
		if location < -17000 && location > -17010 {
			self.removeAction(forKey: "spawnSpaceEnemy")
		}
		if location < -18500 && location > -18510 {
			self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(self.fireworks),.wait(forDuration: 0.1)])))
			self.pauseGame()
			self.endGame()
		}
	}
    
    func setUpGame(){
		print("frame width", self.frame.size.width)
        self.isPaused = true
        loadNodes()
		startBtn = self.makeStartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
		addChild(startBtn)
        makePlayableArea()
		addCamera()
		bounds = CGPoint(x: playableRect.minX, y: playableRect.minY)
		makeHealthBar()
		
    }
	
	func addCamera(){
		print("screen height: ", UIScreen.main.bounds.width)
		print("Orientation: ", UIDevice.current.orientation.isLandscape)
		let screenHeight : CGFloat
		if UIDevice.current.orientation.isPortrait {
			screenHeight = UIScreen.main.bounds.height
		} else {
			screenHeight = UIScreen.main.bounds.height
		}
		let playableAreaScaleForIpadAndIphone = screenHeight / tileMap.mapSize.height
		let camera = SKCameraNode()
		camera.setScale(1/playableAreaScaleForIpadAndIphone)
		self.camera = camera
		self.addChild(camera)
	}
    
	override func startGame(){
        gameIsRunning = true
        musicPlayer.playMusic(url: "04 Eventyr")
		startBtn.isHidden = true
		x = 20000
        self.isPaused = false
    }
    
	func makeRestartSign() {
		let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(restartSign)
		pauseGame()
	}

	
/*	func makeRestartButtons(restartSign: SKSpriteNode){
		let yesButton = SKSpriteNode(imageNamed: "Ja_Grå.png")
		let noButton = SKSpriteNode(imageNamed: "Nej_Grå.png")
		yesButton.size = CGSize(width: 200, height: 100)
		noButton.size = CGSize(width: 200, height: 100)
		noButton.zPosition = 8
		yesButton.zPosition = 8
		yesButton.position = CGPoint(x: playableRect.midX - yesButton.size.width/2 - 67, y: playableRect.midY - yesButton.size.height - 110)
		noButton.position = CGPoint(x: yesButton.position.x + noButton.size.width + 21, y: yesButton.position.y)
		yesButton.name = "yes"
		noButton.name = "no"
		restartSign.addChild(yesButton)
		restartSign.addChild(noButton)
	}

	func setTextureButton(button: SKSpriteNode){
		var texture: SKTexture!
		if button.name == "yes"{
			texture = SKTexture(imageNamed: "Ja_Grøn.png")
		}
		if button.name == "no"{
			texture = SKTexture(imageNamed: "Nej_Rød.png")
		}
		let setTextureAction = SKAction.setTexture(texture)
		button.run(setTextureAction)
	}

	func makeStartButton() {
        startButton = SKLabelNode(text: "Start spillet")
        startButton.fontSize = 100
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startButton.name = "startButton"
        startButton.zPosition = 7
        self.addChild(startButton)
    }
	
	func makeEndSign() {
		let endSign = SKSpriteNode(imageNamed: "SlutSkilt")
		endSign.size = CGSize(width: 833, height: 717)
		endSign.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		endSign.name = "endBtn"
		endSign.zPosition = 7
		addChild(endSign)
		makeRestartButtons(restartSign: endSign)
	}

*/
	
	func makeHealthBar() {
		healthBar = SKSpriteNode(texture: menuAtlas.textureNamed("LivSkilt"))
		healthBar.size = CGSize(width: 600, height: 100)
		healthBar.position = CGPoint(x: playableRect.minX + healthBar.size.width/2 + 20, y: playableRect.maxY - healthBar.size.height/2 - 20)
		healthBar.zPosition = 8
		self.addChild(healthBar)
		createHealthBar()
	}
	
	func updateHealthBar(){
		let currentHealth = self.childNode(withName: "health \(health + 1)")
		currentHealth?.removeFromParent()
	}
	
	func createHealthBar() {
		var oneHealthXPosition = healthBar.position.x
		var i = 0
		while i <= health {
			let oneHealth = SKSpriteNode(texture: menuAtlas.textureNamed("Hjerte"))
			oneHealth.size = CGSize(width: 70, height: 40)
			oneHealth.position = CGPoint(x: oneHealthXPosition, y: healthBar.position.y)
			oneHealth.zPosition = 8
			oneHealth.name = "health \(i)"
			self.addChild(oneHealth)
			oneHealthXPosition += oneHealth.frame.size.width + 25
			i += 1
		}
	}
	
	func makeEdge(){
		let path = CGMutablePath()
		path.addRect(playableRect)
		let edge = SKNode()
		edge.physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
		edge.physicsBody?.isDynamic = false
		edge.physicsBody?.categoryBitMask = edgeCollisonMask
		edge.physicsBody?.contactTestBitMask = bulletCollisionMask
		edge.physicsBody?.collisionBitMask = bulletCollisionMask
		edge.physicsBody?.node?.name = "edge"
		edge.physicsBody?.usesPreciseCollisionDetection = true
		addChild(edge)
	}
	
	func checkBulletPosition(){
		if var bullet = self.childNode(withName: "bullet") as? SKSpriteNode{
			print(bullet.position.x)
			if bullet.position.x > playableRect.width {
				enemyhitBullet(bullet: bullet)
				print("bullet removed")
			}
		}
	}
	
	func endAnimation() {
		let moveToCenter = SKAction.move(to: CGPoint(x: playableRect.midX, y: playableRect.midY), duration: 0.5)
		let wait = SKAction.wait(forDuration: 0.5)
		let changeTexture = SKAction.setTexture(heroAtlas.textureNamed("Rumskib01"))
		let changeTexture2 = SKAction.setTexture(heroAtlas.textureNamed("Rumskib02"))
		let rotateAction = SKAction.rotate(toAngle: +.pi/2, duration: 0.5)
		let rotateToCenterAction = SKAction.rotate(toAngle: .pi/2, duration: 0.02)
		let shakeLeft = SKAction.rotate(byAngle: .pi/16, duration: 0.02)
		let shakeRight = SKAction.rotate(byAngle: -.pi/16, duration: 0.02)
		let shakeSequence = SKAction.sequence([shakeLeft, shakeRight])
		let runShakeSequence = SKAction.repeat(shakeSequence, count: 20)
		let moveUp = SKAction.move(to: CGPoint(x: playableRect.midX, y: playableRect.height + ship.size.height), duration: 0.5)
		let makeEndSign = SKAction.run {
			let endSign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY)) as! SKSpriteNode
			self.addChild(endSign)
		}
		let endSequence = SKAction.sequence([moveToCenter, changeTexture, rotateAction, wait, runShakeSequence, rotateToCenterAction, changeTexture2, moveUp, makeEndSign])
		ship.run(endSequence)
		
	}
	
	func fireworks(){
		let firework = SKSpriteNode(texture: explosionAtlas.textureNamed("Firework"))
		firework.size = CGSize(width: 83, height: 83)
		firework.position = CGPoint(x: CGFloat.random(min: playableRect.minX + 83/2, max: playableRect.maxX - 83/2), y: CGFloat.random(min: playableRect.minY + 83/2, max: playableRect.maxY - 83/2))
		firework.zPosition = 4
		let scaleUp = SKAction.scale(to: CGSize(width: 83, height: 83), duration: 0.2)
		let scaleDown = SKAction.scale(to: CGSize(width: 0, height: 0), duration: 0.2)
		let wait = SKAction.wait(forDuration: 0.2)
		let removeAction = SKAction.removeFromParent()
		let sequence = SKAction.sequence([scaleUp,wait,scaleDown,removeAction])
		addChild(firework)
		firework.run(sequence)
	}
	
	func endGame(){
		endAnimation()
	}
    
    func loadNodes() {
        guard let tileMap = childNode(withName: "tileMap")
                                       as? SKTileMapNode else {
          fatalError("Background node not loaded")
        }
        
        self.tileMap = tileMap
		tileMap.position = CGPoint(x: x, y: 0)
        tileMap.zPosition = 0
        
        guard let ship = childNode(withName: "Ship") as? SKSpriteNode else {
            fatalError("Sprite Nodes not loaded")
        }
        
        self.ship = ship
        ship.zPosition = 5
		ship.isUserInteractionEnabled = false
		ship.physicsBody = SKPhysicsBody(rectangleOf: ship.size)
		ship.physicsBody?.affectedByGravity = false
		ship.physicsBody?.isDynamic = false
		ship.physicsBody?.allowsRotation = false
		ship.physicsBody?.categoryBitMask = shipCollisionMask
		ship.physicsBody?.contactTestBitMask = enemyCollisionMask
		ship.physicsBody?.collisionBitMask = enemyCollisionMask | mapCollisionMask
		ship.physicsBody?.node?.name = "hero"
		
    }
    
	func populatePhysicsOnMap() {
		print("starting poulation")
		let forground = tileMap.childNode(withName: "Forground") as! SKTileMapNode
		self.forground = forground
		self.forground.isUserInteractionEnabled = true
		let tileSize = forground.tileSize
        let halfWidth = CGFloat(forground.numberOfColumns) / 2 * tileSize.width
        let halfHeight = CGFloat(forground.numberOfRows) / 2 * tileSize.height

        for col in 0..<forground.numberOfColumns {
            for row in 0..<forground.numberOfRows {
                let tileDefinition = forground.tileDefinition(atColumn: col, row: row)
                let isGroundTile = tileDefinition?.userData?["isGround"] as? Bool
				print(isGroundTile)
                if (isGroundTile == true) {
					let thisTileSize = tileDefinition?.size
					let tileX = CGFloat(col) * tileSize.width - halfWidth
					let tileY = CGFloat(row) * tileSize.height - halfHeight
					print(tileX, tileY)
					let lowX = tileDefinition?.userData!["x"] as! CGFloat
					let lowY = tileDefinition?.userData!["y"] as! CGFloat
					let path = UIBezierPath()
					path.move(to: CGPoint(x: 0, y: 0))
					path.addLine(to: CGPoint(x: thisTileSize!.width, y: 0))
					path.addLine(to: CGPoint(x: thisTileSize!.width, y: 95))
					path.addLine(to: CGPoint(x: lowX, y: lowY))
					path.addLine(to: CGPoint(x: 0, y: 95))
					path.addLine(to: CGPoint(x: 0, y: 0))
					let tileNode = SKShapeNode()
					tileNode.path = path.cgPath
                    tileNode.position = CGPoint(x: tileX, y: tileY)
					tileNode.strokeColor = UIColor.red
					tileNode.isUserInteractionEnabled = true
					tileNode.lineWidth = 5
					tileNode.zPosition = 7
					tileNode.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
                    tileNode.physicsBody?.isDynamic = false
					tileNode.physicsBody?.affectedByGravity = false
                    tileNode.physicsBody?.categoryBitMask = mapCollisionMask
                    tileNode.physicsBody?.collisionBitMask = shipCollisionMask
					forground.addChild(tileNode)
                }
            }
        }
	}
	
	func rotateShip(){
		let rotateRight = SKAction.rotate(toAngle: .pi / 25, duration: 1.0)
		let rotateCenter = SKAction.rotate(toAngle: 0, duration: 1.0)
		let rotateLeft = SKAction.rotate(toAngle: -.pi / 25, duration: 1.0)
		let sequence = SKAction.sequence([rotateRight, rotateCenter, rotateLeft, rotateCenter])
		ship.run(.repeatForever(sequence), withKey: "rotateAction")
	}
	
	func rotateShipToCenter() {
		let rotateCenter = SKAction.rotate(toAngle: 0, duration: 0.1)
		ship.run(rotateCenter)
	}
	
    func shot() {
		let projectile = SKSpriteNode(texture: bulletTexture)
		let fireProjectile = SKAction.moveTo(x: playableRect.size.width, duration: 1.5)
		projectile.position = CGPoint(x: ship.position.x, y: ship.position.y)
		projectile.zPosition = 4
		projectile.size = CGSize(width: 104, height: 63)
		projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
		if isMorphed{
			projectile.physicsBody?.isDynamic = false
			projectile.physicsBody?.affectedByGravity = false
		}else{
			projectile.physicsBody?.isDynamic = true
			projectile.physicsBody?.affectedByGravity = true
		}
		projectile.physicsBody?.usesPreciseCollisionDetection = true
		projectile.physicsBody?.categoryBitMask = bulletCollisionMask
		projectile.physicsBody?.collisionBitMask = enemyCollisionMask | edgeCollisonMask
		projectile.physicsBody?.contactTestBitMask = enemyCollisionMask | edgeCollisonMask
		projectile.physicsBody?.node?.name = "bullet"
        addChild(projectile)
        projectile.run(fireProjectile)
        isFiring = true
	}
    func morph() {
		let fadeOut = SKAction.fadeOut(withDuration: 0.3)
		let fadeIn = SKAction.fadeIn(withDuration: 0.3)
		let setAlphaAction = SKAction.fadeAlpha(to: 0, duration: 0)
		let changeToPlane1 = SKAction.setTexture(heroAtlas.textureNamed("Fly"))
		let setIsMorphedAction = SKAction.run(setIsMorphed)
		let sequence = SKAction.sequence([fadeOut,setAlphaAction, changeToPlane1,fadeIn,setIsMorphedAction])
		ship.physicsBody?.affectedByGravity = false
		ship.physicsBody?.isDynamic = false
		ship.scale(to: CGSize(width: 250, height: 250))
        ship.run(sequence, withKey: "fly")
        
    }
	
	func setIsMorphed() {
		isMorphed = true
	}
    
    func morphToSpace() {
		let fadeOut = SKAction.fadeOut(withDuration: 0.3)
		let fadeIn = SKAction.fadeIn(withDuration: 0.3)
		let setAlphaAction = SKAction.fadeAlpha(to: 0, duration: 0)
		let wait = SKAction.wait(forDuration: 0.5)
		let changeToSpace = SKAction.setTexture(heroAtlas.textureNamed("Rumskib01"))
		let changeToSpace2 = SKAction.setTexture(heroAtlas.textureNamed("Rumskib02"))
		let sequence = SKAction.sequence([changeToSpace, wait, changeToSpace2, wait])
		let fadeSequence = SKAction.sequence([fadeOut,setAlphaAction,changeToSpace,fadeIn])
		let block = SKAction.sequence([fadeSequence, .repeatForever(sequence)])
		ship.removeAction(forKey: "fly")
		ship.run(block)
		isSpace = true
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) { // 1
        let amountToMove = CGPoint(x: 0, y: velocity.y * CGFloat(dt))
        sprite.position = CGPoint(
        x: sprite.position.x,
        y: sprite.position.y + amountToMove.y)
    }
    
    func moveShipTowards(location: CGPoint) {
        let offset = CGPoint(x: location.x - ship.position.x, y: location.y - ship.position.y)
         let length = sqrt(
        Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * shipMovePointsPerSec, y: direction.y * shipMovePointsPerSec)
    }
    
	func addPhysicsToEnemy(enemy: SKSpriteNode){
		enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
		enemy.physicsBody?.isDynamic = true
		enemy.physicsBody?.affectedByGravity = false
		enemy.physicsBody?.categoryBitMask = enemyCollisionMask
		enemy.physicsBody?.collisionBitMask = bulletCollisionMask | shipCollisionMask
		enemy.physicsBody?.contactTestBitMask = bulletCollisionMask | shipCollisionMask
		enemy.physicsBody?.node?.name = "enemy"
		enemy.physicsBody?.usesPreciseCollisionDetection = true
	}
	
    func spawnSpaceEnemy() {
		let enemy = SKSpriteNode(texture: enemyAtlas.textureNamed("AsteroideLys"))
		enemy.scale(to: CGSize(width: 150, height: 150))
		enemy.position = CGPoint(x: playableRect.size.width + enemy.size.width/2, y: CGFloat.random(
        min: playableRect.minY + enemy.size.height/2,
        max: playableRect.maxY - enemy.size.height/2))
        enemy.name = "enemy"
		addPhysicsToEnemy(enemy: enemy)
        addChild(enemy)
		let actionMove = SKAction.moveTo(x: -playableRect.size.width - 500, duration: 5.0)
        let rotateAction = SKAction.rotate(byAngle: 5.0, duration: 1)
		let actionRemove = SKAction.run {
			enemy.removeAllActions()
			enemy.removeFromParent()
		}
		let sequence = SKAction.sequence([actionMove, actionRemove])
		let group = SKAction.group([sequence, .repeatForever(rotateAction)])
        enemy.run(group)
    }
    
    func spawnAirEnemy() {
		let enemy = SKSpriteNode(texture: enemyAtlas.textureNamed("Fugl01"))
		let flyAction = SKAction.animate(with: [enemyAtlas.textureNamed("Fugl01"), enemyAtlas.textureNamed("Fugl02")], timePerFrame: 0.2)
        enemy.scale(to: CGSize(width: 150, height: 150))
		enemy.position = CGPoint(x: playableRect.size.width + enemy.size.width/2, y: CGFloat.random(
            min: playableRect.minY + 100 + enemy.size.height/2,
            max: playableRect.maxY - enemy.size.height/2))
        enemy.name = "enemy"
		enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
			enemy.physicsBody?.isDynamic = true
			enemy.physicsBody?.affectedByGravity = false
			enemy.physicsBody?.categoryBitMask = enemyCollisionMask
			enemy.physicsBody?.collisionBitMask = bulletCollisionMask | shipCollisionMask
			enemy.physicsBody?.contactTestBitMask = bulletCollisionMask | shipCollisionMask
			enemy.physicsBody?.node?.name = "enemy"
			enemy.physicsBody?.usesPreciseCollisionDetection = true
        addChild(enemy)
		let actionMove = SKAction.moveTo(x: -playableRect.size.width - 500, duration: 6.0)
		let actionRemove = SKAction.run {
			enemy.removeAllActions()
			enemy.removeFromParent()
		}
		let sequence = SKAction.sequence([actionMove, actionRemove])
		let group = SKAction.group([sequence, .repeatForever(flyAction)])
		enemy.run(group)
    }
    
    func spawnWaterEnemy() {
		let enemy = SKSpriteNode(texture: enemyAtlas.textureNamed("FuldHaj"))
		let actionMove = SKAction.moveTo(x: -playableRect.size.width, duration: 6.0)
        enemy.scale(to: CGSize(width: 400, height: 400))
		enemy.position = CGPoint(x: playableRect.size.width, y: playableRect.minY + 50)
        enemy.name = "enemy"
		enemy.zPosition = 3
		enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
		enemy.physicsBody?.isDynamic = true
		enemy.physicsBody?.affectedByGravity = false
		enemy.physicsBody?.categoryBitMask = enemyCollisionMask
		enemy.physicsBody?.collisionBitMask = bulletCollisionMask | shipCollisionMask
		enemy.physicsBody?.contactTestBitMask = bulletCollisionMask | shipCollisionMask
		enemy.physicsBody?.node?.name = "enemy"
		enemy.physicsBody?.usesPreciseCollisionDetection = true
		addChild(enemy)
		enemy.run(.repeatForever(actionMove), withKey: "move")
		
    }
    
	override func restart(){
		self.viewController?.selectGKScene(sceneName: "Adventure")

    }
    
	func killEnemy(enemy: SKSpriteNode) {
		enemy.physicsBody = nil
		enemy.name = "usedEnemy"
		enemy.removeAction(forKey: "move")
		let scaleUp = SKAction.scale(to: 0.5, duration: 0.2)
        let wait = SKAction.wait(forDuration: 0.2)
        let scaleDown = SKAction.scale(to: CGSize(width: 0, height: 0), duration: 0.2)
		let removeAction = SKAction.run {
			enemy.removeAllActions()
			enemy.removeFromParent()
		}
		let setEnemyIsHitAction = SKAction.run(setEnemyIsHit)
        let sequence = SKAction.sequence([scaleUp, wait, scaleDown, removeAction, setEnemyIsHitAction])
        enemy.run(sequence)
    }
    
    func setEnemyIsRemoved() {
        enemyIsRemoved = true
    }
	
	func setEnemyIsHit() {
		enemyIsHit = false
	}
    
	func checkHealth() {
		if health < 0 {
			death()
		}
	}
	
	func explosion(){
		let explosionNode = SKSpriteNode(texture: explosionAtlas.textureNamed("Eksplosion04"), size: CGSize(width: 66, height: 83))
		let explosion01 = SKAction.setTexture(explosionAtlas.textureNamed("Eksplosion01"))
		let explosion02 = SKAction.setTexture(explosionAtlas.textureNamed("Eksplosion02"))
		let explosion03 = SKAction.setTexture(explosionAtlas.textureNamed("Eksplosion03"))
		let explosion04 = SKAction.setTexture(explosionAtlas.textureNamed("Eksplosion04"))
		let wait = SKAction.wait(forDuration: 0.2)
		let scaleAction = SKAction.scale(by: 2, duration: 0.2)
		let scaleDownAction = SKAction.scale(by: 0.5, duration: 0)
		let removeHeroAction = SKAction.run(removeHero)
		let makeRestartButtonAction = SKAction.run(makeRestartSign)
		let removeAction = SKAction.removeFromParent()
		let pauseGameAction = SKAction.run(pauseGame)
		let sequence = SKAction.sequence([pauseGameAction, explosion04, wait, scaleAction, explosion03, wait, scaleAction, explosion02, wait, scaleAction, explosion01, removeHeroAction, wait, scaleDownAction, explosion02, wait, scaleDownAction, explosion03, wait, scaleDownAction, explosion04, removeAction, makeRestartButtonAction])
		explosionNode.position = ship.position
		explosionNode.zPosition = 7
		addChild(explosionNode)
		explosionNode.run(sequence)
		
	}
	
	func removeHero(){
		ship.removeFromParent()
	}
	
	func pauseGame(){
		gameIsRunning = false
		mapSpeed = 0
        musicPlayer.fadeOut()
	}
	
    func death() {
		let enemy = childNode(withName: "enemy") as! SKSpriteNode
		enemy.removeAllActions()
		enemy.removeFromParent()
		removeAction(forKey: "spawnWaterEnemy")
		explosion()
    }
    
    func enemyhitBullet(bullet: SKSpriteNode){
		bullet.removeAllActions()
        bullet.removeFromParent()
    }
    
    func reduceHealth(){
			health -= 1
			updateHealthBar()
			print(health, "reduce")
    }
    
	func enemyAttack(enemy: SKSpriteNode) {
		print("Attack")
		enemy.name = "usedEnemy"
		enemy.removeAction(forKey: "move")
		let diveAction = SKAction.move(to: CGPoint(x: enemy.position.x, y: enemy.position.y - 200), duration: 0.4)
		let removeAction = SKAction.removeFromParent()
		let diveSequence = SKAction.sequence([diveAction,removeAction])
		enemy.run(diveSequence)
		let shark = SKSpriteNode(texture: enemyAtlas.textureNamed("Haj"))
		shark.position = CGPoint(x: ship.position.x, y: playableRect.minY)
		shark.scale(to: CGSize(width: 300, height: 300))
		let attackAction = SKAction.move(to: CGPoint(x: shark.position.x, y: ship.position.y), duration: 1)
		let attackReverseAction = SKAction.move(to: CGPoint(x: shark.position.x, y: playableRect.minY), duration: 1)
		let enemyHitShipAction = SKAction.run(enemyHitShip)
		let sequence = SKAction.sequence([attackAction,enemyHitShipAction,attackReverseAction, removeAction])
		addChild(shark)
		shark.run(sequence)
	}
	
    func enemyHitShip() {
		let scaleUp = SKAction.scale(to: CGSize(width: 500, height: 500), duration: 0.2)
		let wait = SKAction.wait(forDuration: 0.2)
		let scaleDown = SKAction.scale(to: CGSize(width: 250, height: 250), duration: 0.2)
		let reduceHealthAction = SKAction.run(reduceHealth)
		let checkHealthAction = SKAction.run(checkHealth)
		let sequence = SKAction.sequence([scaleUp, wait, scaleDown, reduceHealthAction,checkHealthAction])
		ship.run(sequence)
    }
    
	func boundsCheckShip() {
		let bottomLeft: CGPoint = bounds
		
		let topRight = CGPoint(x: playableRect.maxX, y: playableRect.maxY - ship.size.height/2)
		if ship.position.y <= bottomLeft.y {
			ship.position.y = bottomLeft.y
			velocity.y = -velocity.y
		}
		if ship.position.y >= topRight.y {
			ship.position.y = topRight.y
			velocity.y = -velocity.y
		}
    }
	
	func findCurrentGroundLevel(currentShipPosition: CGPoint) {
		var tilePosition = CGPoint(x: currentShipPosition.x, y: currentShipPosition.y)
		var forground = tileMap.childNode(withName: "Forground") as! SKTileMapNode
		var column = forground.tileColumnIndex(fromPosition: tilePosition)
		var row = forground.tileRowIndex(fromPosition: tilePosition)
		let tileDefinition = forground.tileDefinition(atColumn: column, row: row)
		var groundLevel = tileDefinition?.userData?["groundLevel"] as! Float
		print(groundLevel)
	}
    
    func checkCollisions() {
		var hitEnemies: [SKSpriteNode] = []
		self.enumerateChildNodes(withName: "enemy") { node, _ in
				var enemy = node as! SKSpriteNode
				if var bullet = self.childNode(withName: "bullet") as? SKSpriteNode {
						if bullet.frame.intersects(enemy.frame) {
							print("enemy hit")
							self.enemyIsHit = true
							hitEnemies.append(enemy)
							self.enemyhitBullet(bullet: bullet)
						}
					}

				}
            
			
		
		for enemy in hitEnemies{
			killEnemy(enemy: enemy)
		}

		var enemiesHitShip: [SKSpriteNode] = []
        if var enemy = childNode(withName: "enemy") as? SKSpriteNode {
			if self.ship.frame.intersects(enemy.frame){
				enemiesHitShip.append(enemy)
			}
        }
		
		for enemy in enemiesHitShip {
			if self.health == 0 {
				self.death()
			}
			hasTouchedShip = true
			if !enemyIsHit {
			}
		}
    }
	
	func checkForground(point: CGPoint) {
		let forground = tileMap.childNode(withName: "Forground") as! SKTileMapNode
		let col = forground.tileColumnIndex(fromPosition: point)
		let row = forground.tileRowIndex(fromPosition: point)
		print(col,row)
		let tileDefinition = forground.tileDefinition(atColumn: col, row: row)
		let isEarth = tileDefinition?.userData?["isEarth"] as? Bool
		let isSpace = tileDefinition?.userData?["isSpace"] as? Bool
		print("isEarth", isEarth)
		print("isSpace", isSpace)
		if isEarth == true || isSpace == true {
			
			self.removeAction(forKey: "spawnWaterEnemy")
			self.removeAction(forKey: "spawnAirEnemy")
		}
	}
    
	func didBegin(_ contact: SKPhysicsContact) {
		print("first contact")
		if contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "bullet"  {
			print("bullet hit enemy")
				enemyIsHit = true
				enemyhitBullet(bullet: contact.bodyB.node as! SKSpriteNode)
				killEnemy(enemy: contact.bodyA.node as! SKSpriteNode )
			
		}else if contact.bodyA.node?.name == "bullet" && contact.bodyB.node?.name == "enemy" {
			print("enemy hit bullet")
				enemyIsHit = true
				enemyhitBullet(bullet: contact.bodyA.node as! SKSpriteNode)
				killEnemy(enemy: contact.bodyB.node as! SKSpriteNode)
		}
		else if contact.bodyA.node?.name == "hero" && contact.bodyB.node?.name == "enemy" {
			if !enemyIsHit {
				if isMorphed {
					enemyHitShip()
					killEnemy(enemy: contact.bodyB.node as! SKSpriteNode)
				} else {
					enemyAttack(enemy: contact.bodyB.node as! SKSpriteNode)
				}
			}
		}
		else if contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "hero" {
			if !enemyIsHit {
				if isMorphed {
					enemyHitShip()
					killEnemy(enemy: contact.bodyA.node as! SKSpriteNode)
				}else {
					enemyAttack(enemy: contact.bodyA.node as! SKSpriteNode)
				}
			}
		}
		else if contact.bodyA.node?.name == "bullet" && contact.bodyB.node?.name == "edge"{
			contact.bodyA.node?.removeAllActions()
			contact.bodyA.node?.removeFromParent()
			print("bullet hit edge")
		}
		else if contact.bodyA.node?.name == "edge" && contact.bodyB.node?.name == "bullet"{
			contact.bodyB.node?.removeAllActions()
			contact.bodyB.node?.removeFromParent()
			print("bullet hit edge")
		}
	}
	
	override func willMove(from view: SKView) {
		print("will move from adventure")
		self.ship.removeAllActions()
		self.ship.removeFromParent()
		self.removeAllActions()
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
			print(touchedNode.name)
            if gameIsRunning {
                if touchedNode.name == "hero"{
                    print("shipTouched")
					shot()
                }
                    moveShipTowards(location: location)
            }
        }
    }
    	
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {		
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
	
	/*func makeShipFloat(currentWaterNode: SKShapeNode) {
		if currentWaterNode.frame.contains(CGPoint(x:ship.position.x, y:ship.position.y-ship.size.height/2.0)) {
            let rate: CGFloat = 0.01; //Controls rate of applied motion. You shouldn't really need to touch this.
			let waterNodeHeight = currentWaterNode.size.height
			let disp = (((currentWaterNode.position.y+OFFSET)+waterNode.height/2.0)-((ship.position.y)-ship.size.height/2.0))
			let dispTimesBUOYANCY = disp * BUOYANCY
            let targetPos = CGPoint(x: ship.position.x, y: ship.position.y+disp)
            let targetVel = CGPoint(x: (targetPos.x-ship.position.x)/(1.0/60.0), y: (targetPos.y-ship.position.y)/(1.0/60.0))
            let relVel: CGVector = CGVector(dx:targetVel.x-ship.physicsBody.velocity.dx*VISCOSITY, dy:targetVel.y-ship.physicsBody.velocity.dy*VISCOSITY);
			ship.physicsBody?.velocity=CGVector(dx:ship.physicsBody?.velocity.dx+relVel.dx*rate, dy:ship.physicsBody?.velocity.dy+relVel.dy*rate);
        }
	}*/
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        if gameIsRunning {
			checkMapLocation(location: x)
			print("mapLocation", x)
            mapLocation = CGPoint(x: x,y: 0)
            tileMap.position = mapLocation
            x = x - mapSpeed
        }
        
        // Calculate time since last update
        dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
		checkBulletPosition()
        if isMorphed && gameIsRunning {
			boundsCheckShip()
			moveSprite(sprite: ship, velocity: CGPoint(x: 0, y: velocity.y))
		}else{
			//moveShipTowards(location: <#T##CGPoint#>)
			//moveSprite(sprite: ship, velocity: velocity)
		}
    }
	
	override func didEvaluateActions() {
		//checkCollisions()
	}
}
