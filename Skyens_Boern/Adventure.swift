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
    var hero: SKSpriteNode!
    var morphPoint1: TimeInterval = 47.0
	var bounds: CGPoint = CGPoint(x: 0, y: 0)
    var isFiring: Bool = false
    var health: Int32 = 2
    var enemyIsRemoved: Bool = true
    var startBtn: SKSpriteNode!
    var playableRect: CGRect!
	var healthBar: SKSpriteNode!
    let shipMovePointsPerSec: CGFloat = 320
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
	var hasShotFirstEnemy : Bool = false

    
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
    /* Create an area where playing takes place */
    func makePlayableArea() {
		self.playableRect = CGRect(x: self.frame.minX, y: self.frame.minY,
								   width: self.frame.width,
								   height: self.frame.height)
		print("Frame width", self.frame.width)
    }
    
    override func sceneDidLoad() {
		self.physicsWorld.contactDelegate = self
        setUpGame()
		self.makeBackBtn()
		self.makeHelpBtn()
    }
    
	/* Checks the current map location and activates events at certain points */
	
	func checkMapLocation(location: CGFloat){
		if location < 20000 && location > 19990 {
			bulletTexture = heroAtlas.textureNamed("Skud_Skib")
			rotateShip()
			playSpeak(name: "Eventyr1", length: 5)
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
			self.hero.removeAction(forKey: "rotateAction")
			playSpeak(name: "Eventyr4", length: 5)
			self.run(SKAction.repeatForever( SKAction.sequence([SKAction.run(self.spawnAirEnemy),SKAction.wait(forDuration: 3.0)])), withKey: "spawnAirEnemy")
			self.hasShotFirstEnemy = false
		}
		if location < 9700 && location > 9695 {
			playSpeak(name: "Eventyr5", length: 4)
		}
		if location < 9200 && location > 9195 {
			playSpeak(name: "Eventyr7", length: 4)
		}
		if location < 7500 && location > 7495 {
			playSpeak(name: "Eventyr6", length: 4)
		}
		if location < 1000 && location > 990 {
			self.removeAction(forKey: "spawnAirEnemy")
		}
		if location < -100 && location > -110 {
			self.bulletTexture = heroAtlas.textureNamed("Skud_Rum")
			self.bounds = CGPoint(x: self.playableRect.minX, y: self.playableRect.minY + self.hero.size.height/2)
			self.morphToSpace()
			self.playSpeak(name: "Eventyr8", length: 6)
			self.run(SKAction.repeatForever( SKAction.sequence([SKAction.run(self.spawnSpaceEnemy),SKAction.wait(forDuration: 3.0)])), withKey: "spawnSpaceEnemy")
			self.hasShotFirstEnemy = false
		}
		if location < 50 && location > 45 {
			playSpeak(name: "Eventyr9", length: 3)
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
    
	/* Sets up the game for start */
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
	
	/* Adds a camera node to scale the game for different devices */
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
		let scale = playableAreaScaleForIpadAndIphone*2
		self.calculateSizeDivider(scale: scale)
		self.camera = camera
		self.addChild(camera)
	}
    
	/* Start the game */
	override func startGame(){
        gameIsRunning = true
        musicPlayer.play(url: "04 Eventyr")
		startBtn.isHidden = true
		x = 20000
        self.isPaused = false
    }
    
	/* Create a RestartSign with buttons */
	func makeRestartSign() {
		let restartSign = self.makeRestartSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(restartSign)
		playSpeakNoMusic(name: "Eventyr3")
		pauseGame()
	}
	
	/* Make the health bar node */
	func makeHealthBar() {
		healthBar = SKSpriteNode(texture: menuAtlas.textureNamed("LivSkilt"))
		healthBar.size = CGSize(width: 600, height: 100)
		healthBar.position = CGPoint(x: playableRect.minX + healthBar.size.width/2 + 20, y: playableRect.maxY - healthBar.size.height/2 - 20)
		healthBar.zPosition = 8
		self.addChild(healthBar)
		addHealth()
	}
	
	/* Update the healthbar */
	func updateHealthBar(){
		let currentHealth = self.childNode(withName: "health \(health + 1)")
		currentHealth?.removeFromParent()
	}
	
	/* Add health to the healthbar */
	func addHealth() {
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
	
	/* Create and edge node */
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
	
	/* Check bullet position and remove when off screen */
	func checkBulletPosition(){
		if let bullet = self.childNode(withName: "bullet") as? SKSpriteNode{
			print(bullet.position.x)
			if bullet.position.x > playableRect.width {
				enemyhitBullet(bullet: bullet)
				print("bullet removed")
			}
		}
	}
	
	/* Final celebration animation if player is victorios */
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
		let moveUp = SKAction.move(to: CGPoint(x: playableRect.midX, y: playableRect.height + hero.size.height), duration: 0.5)
		let makeEndSign = SKAction.run {
			let endSign = self.makeEndSign(position: CGPoint(x: self.frame.midX, y: self.frame.midY))
			self.addChild(endSign)
			self.playSpeakNoMusic(name: "Eventyr10")
		}
		let endSequence = SKAction.sequence([moveToCenter, changeTexture, rotateAction, wait, runShakeSequence, rotateToCenterAction, changeTexture2, moveUp, makeEndSign])
		hero.run(endSequence)
		
	}
	
	/* Fireworks animation for end animation */
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
	
	/* End the game */
	func endGame(){
		endAnimation()
	}
    
	/* Load the nodes from tilemap and add physicsbody elements */
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
        
        self.hero = ship
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
    
/*	func populatePhysicsOnMap() {
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
	} */
	
	/* Rotate animation for ship on water*/
	func rotateShip(){
		let rotateRight = SKAction.rotate(toAngle: .pi / 25, duration: 1.0)
		let rotateCenter = SKAction.rotate(toAngle: 0, duration: 1.0)
		let rotateLeft = SKAction.rotate(toAngle: -.pi / 25, duration: 1.0)
		let sequence = SKAction.sequence([rotateRight, rotateCenter, rotateLeft, rotateCenter])
		hero.run(.repeatForever(sequence), withKey: "rotateAction")
	}
	
	/* Rotate ship to center position */
	func rotateShipToCenter() {
		let rotateCenter = SKAction.rotate(toAngle: 0, duration: 0.1)
		hero.run(rotateCenter)
	}
	
	/* create a bullet node, add physicsbody, and create firingAction */
	override func shot() {
		let projectile = SKSpriteNode(texture: bulletTexture)
		let fireProjectile = SKAction.moveTo(x: playableRect.size.width, duration: 1.5)
		projectile.position = CGPoint(x: hero.position.x, y: hero.position.y)
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
	
	/* morph hero into flyMode*/
    func morph() {
		let fadeOut = SKAction.fadeOut(withDuration: 0.3)
		let fadeIn = SKAction.fadeIn(withDuration: 0.3)
		let setAlphaAction = SKAction.fadeAlpha(to: 0, duration: 0)
		let changeToPlane1 = SKAction.setTexture(heroAtlas.textureNamed("Fly"))
		let setIsMorphedAction = SKAction.run(setIsMorphed)
		let sequence = SKAction.sequence([fadeOut,setAlphaAction, changeToPlane1,fadeIn,setIsMorphedAction])
		hero.physicsBody?.affectedByGravity = false
		hero.physicsBody?.isDynamic = false
		hero.scale(to: CGSize(width: 250, height: 250))
        hero.run(sequence, withKey: "fly")
        
    }
	
	func setIsMorphed() {
		isMorphed = true
	}
    
	/*morph hero into Spacemode*/
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
		hero.removeAction(forKey: "fly")
		hero.run(block)
		isSpace = true
    }
    
	/*move hero diagonally in fly and space mode*/
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) { // 1
        let amountToMove = CGPoint(x: 0, y: velocity.y * CGFloat(dt))
        sprite.position = CGPoint(
        x: sprite.position.x,
        y: sprite.position.y + amountToMove.y)
    }
    
	/* Set direction for hero in fly and space mode*/
	override func moveShipTowards(location: CGPoint) {
        let offset = CGPoint(x: location.x - hero.position.x, y: location.y - hero.position.y)
         let length = sqrt(
        Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * shipMovePointsPerSec, y: direction.y * shipMovePointsPerSec)
    }
    
	/* Add physicsbody to enemy*/
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
	
	/* Spawn a space enemy and create move action*/
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
	
	/* Spawn a air enemy and create move action*/
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
    
	/* Spawn a water enemy and create move action*/
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
    
	/*Restart scene*/
	override func restart(){
		self.viewController?.selectGKScene(sceneName: "Adventure")

    }
    
	/* Kill enemy and create death animation*/
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
		if !hasShotFirstEnemy {
			playSpeak(name: "Eventyr2", length: 2)
			hasShotFirstEnemy = true
		}
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
	
	/* Create hero death animation*/
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
		explosionNode.position = hero.position
		explosionNode.zPosition = 7
		addChild(explosionNode)
		explosionNode.run(sequence)
		
	}
	
	func removeHero(){
		hero.removeFromParent()
	}
	
	func pauseGame(){
		gameIsRunning = false
		mapSpeed = 0
        musicPlayer.fadeOut()
	}
	
	/* Hero death*/
    func death() {
		if let enemy = childNode(withName: "enemy") as? SKSpriteNode {
			enemy.removeAllActions()
			enemy.removeFromParent()
		}
			removeAction(forKey: "spawnWaterEnemy")
			explosion()
		
		
    }
    
	/* Enemy is shot down by bullet*/
    func enemyhitBullet(bullet: SKSpriteNode){
		bullet.removeAllActions()
        bullet.removeFromParent()
    }
    
	/* Hero is hit reduce health*/
    func reduceHealth(){
			health -= 1
			updateHealthBar()
			print(health, "reduce")
    }
    
	/* Shark attacks hero animation*/
	func enemyAttack(enemy: SKSpriteNode) {
		print("Attack")
		enemy.name = "usedEnemy"
		enemy.removeAction(forKey: "move")
		let diveAction = SKAction.move(to: CGPoint(x: enemy.position.x, y: enemy.position.y - 200), duration: 0.4)
		let removeAction = SKAction.removeFromParent()
		let diveSequence = SKAction.sequence([diveAction,removeAction])
		enemy.run(diveSequence)
		let shark = SKSpriteNode(texture: enemyAtlas.textureNamed("Haj"))
		shark.position = CGPoint(x: hero.position.x, y: playableRect.minY)
		shark.scale(to: CGSize(width: 300, height: 300))
		let attackAction = SKAction.move(to: CGPoint(x: shark.position.x, y: hero.position.y), duration: 1)
		let attackReverseAction = SKAction.move(to: CGPoint(x: shark.position.x, y: playableRect.minY), duration: 1)
		let enemyHitShipAction = SKAction.run(enemyHitShip)
		let sequence = SKAction.sequence([attackAction,enemyHitShipAction,attackReverseAction, removeAction])
		addChild(shark)
		shark.run(sequence)
	}
	
	/* Enemy hits hero animation and health check*/
    func enemyHitShip() {
		let scaleUp = SKAction.scale(to: CGSize(width: 500, height: 500), duration: 0.2)
		let wait = SKAction.wait(forDuration: 0.2)
		let scaleDown = SKAction.scale(to: CGSize(width: 250, height: 250), duration: 0.2)
		let reduceHealthAction = SKAction.run(reduceHealth)
		let checkHealthAction = SKAction.run(checkHealth)
		let sequence = SKAction.sequence([scaleUp, wait, scaleDown, reduceHealthAction,checkHealthAction])
		hero.run(sequence)
    }
    
	/* Check if hero is off bounds*/
	func boundsCheckShip() {
		let bottomLeft: CGPoint = bounds
		
		let topRight = CGPoint(x: playableRect.maxX, y: playableRect.maxY - hero.size.height/2)
		if hero.position.y <= bottomLeft.y {
			hero.position.y = bottomLeft.y
			velocity.y = -velocity.y
		}
		if hero.position.y >= topRight.y {
			hero.position.y = topRight.y
			velocity.y = -velocity.y
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
		if isEarth == true || isSpace == true {
			
			self.removeAction(forKey: "spawnWaterEnemy")
			self.removeAction(forKey: "spawnAirEnemy")
		}
	}
    
	/* Physicsbody contact*/
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
		self.hero.removeAllActions()
		self.hero.removeFromParent()
		self.removeAllActions()
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
			moveSprite(sprite: hero, velocity: CGPoint(x: 0, y: velocity.y))
		}
    }
}
