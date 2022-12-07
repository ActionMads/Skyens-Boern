//
//  GoodnightSong.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 14/01/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GoodnightSong : Scene {
    private var lastUpdateTime : TimeInterval = 0
    var girl : SKSpriteNode!
    var background : SKSpriteNode?
    var lyingGirl : SKSpriteNode?
    var hand : SKSpriteNode!
    var arm : SKSpriteNode!
    let goodnightAtlas : SKTextureAtlas = SKTextureAtlas(named: "Godnatsang Sprites")
    var eyesTimer : Timer!
    var handShakeTimer : Timer!
    var changeSceneTimer : Timer!
    var lyingGirlTimer : Timer!
    var duvetTimer : Timer!
    var closeEyesTimer : Timer!
    var blackScreenTimer : Timer!
    var backToHomeTimer : Timer!
    
    override func sceneDidLoad() {
        makeBackground()
        makeGirl()
        musicPlayer.playMusic(url: "07 Godnatsang")
        presentGirl()
        self.makeBackBtn()
        self.eyesTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: { [self] timer in
            animateEyes(tex1: "PigeLukkedeØjne", tex2: "PigeÅbneØjne", sprite: girl)

        })
        self.handShakeTimer = Timer.scheduledTimer(withTimeInterval: 39, repeats: false, block: { [self] timer in
            makeHandShake()
        })
        self.changeSceneTimer = Timer.scheduledTimer(withTimeInterval: 47, repeats: false, block: { [self] timer in
            changeScene()
        })
        self.lyingGirlTimer = Timer.scheduledTimer(withTimeInterval: 53, repeats: false, block: { [self] timer in
            makeLyingGirl()
            animateEyes(tex1: "PigeLiggendeLukkedeØjne", tex2: "PigeLiggendeÅbneØjne", sprite: lyingGirl!)
        })
        self.duvetTimer = Timer.scheduledTimer(withTimeInterval: 70, repeats: false, block: { [self] timer in
            makeDuvet()
        })
        self.closeEyesTimer = Timer.scheduledTimer(withTimeInterval: 98, repeats: false, block: { [self] timer in
            closeEyes()
        })
        self.blackScreenTimer = Timer.scheduledTimer(withTimeInterval: 104, repeats: false, block: { [self] timer in
            makeBlackScreen()
        })
        self.backToHomeTimer = Timer.scheduledTimer(withTimeInterval: 130, repeats: false, block: { [self] timer in
            backToHome()
        })
    }
    
    func makeBlackScreen(){
        let blackScreen = SKSpriteNode(color: UIColor.black, size: CGSize(width: 2732, height: 2048))
        blackScreen.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        blackScreen.zPosition = 3
        blackScreen.alpha = 0.0
        addChild(blackScreen)
        fadeIn(sprite: blackScreen)
    }
    
    func makeLyingGirl(){
        lyingGirl = SKSpriteNode(texture: goodnightAtlas.textureNamed("PigeLiggendeÅbneØjne"))
        lyingGirl!.alpha = 0.0
        lyingGirl!.position = CGPoint(x: size.width/2, y: size.height/2)
        lyingGirl!.zPosition = 1
        addChild(lyingGirl!)
        fadeIn(sprite: lyingGirl!)
    }
    
    func makeDuvet(){
        let duvet = SKSpriteNode(texture: goodnightAtlas.textureNamed("Dyne"))
        duvet.position = CGPoint(x: self.frame.width/2, y: -self.frame.height/2)
        duvet.zPosition = 2
        addChild(duvet)
        let moveUp = SKAction.moveTo(y: self.frame.height/3, duration: 4.0)
        duvet.run(moveUp)
    }
    
    func makeHandShake(){
        hand = SKSpriteNode(texture: goodnightAtlas.textureNamed("Hånd"))
        hand.position = CGPoint(x: self.frame.maxX + hand.size.width, y: self.frame.height/2)
        hand.zPosition = 4
        addChild(hand)
        arm = SKSpriteNode(texture: goodnightAtlas.textureNamed("Arm"))
        arm.position = CGPoint(x: self.frame.midX, y: self.frame.minY - arm.size.height)
        arm.zPosition = 3
        addChild(arm)
        let moveHand = SKAction.moveTo(x: self.frame.midX, duration: 3)
        let wait = SKAction.wait(forDuration: 3)
        let moveArm = SKAction.moveTo(y: self.frame.midY, duration: 3)
        let sequence = SKAction.sequence([wait, moveArm])
        hand.run(moveHand)
        arm.run(sequence)
    }
    
    func changeScene(){
        let fadeOut = SKAction.fadeOut(withDuration: 3.0)
        let changeBackground = SKAction.setTexture(goodnightAtlas.textureNamed("Seng"))
        let fadeIn = SKAction.fadeIn(withDuration: 3.0)
        let sequence = SKAction.sequence([fadeOut,changeBackground,fadeIn])
        background?.run(sequence)
        girl.run(fadeOut, completion: removeFromParent)
        hand.run(fadeOut, completion: removeFromParent)
        arm.run(fadeOut, completion: removeFromParent)
    }
    
    func fadeOut(sprite: SKSpriteNode){
        let fadeAction = SKAction.fadeOut(withDuration: 3.0)
        sprite.run(fadeAction)
    }
    
    func fadeIn(sprite: SKSpriteNode){
        let wait = SKAction.wait(forDuration: 0)
        let fadeInAction = SKAction.fadeIn(withDuration: 3.0)
        let sequence = SKAction.sequence([wait, fadeInAction])
        sprite.run(sequence)
    }
    
    func makeBackground(){
        background = SKSpriteNode(texture: goodnightAtlas.textureNamed("Vindue"))
        background!.position = CGPoint(x: size.width/2, y: size.height/2)
        background!.zPosition = 0
        addChild(background!)
    }
    
    func makeGirl(){
        girl = SKSpriteNode(texture: goodnightAtlas.textureNamed("PigeÅbneØjne"))
        girl.position = CGPoint(x: frame.minX - girl.size.width/2, y: size.height/2)
        girl.zPosition = 1
        addChild(girl)
    }
    
    func animateEyes(tex1: String, tex2: String, sprite: SKSpriteNode){
        let eyesClosed = goodnightAtlas.textureNamed(tex1)
        let eyesOpen = goodnightAtlas.textureNamed(tex2)
        let wait1 = SKAction.wait(forDuration: 3)
        let wait2 = SKAction.wait(forDuration: 0.2)
        let closeEyes = SKAction.setTexture(eyesClosed)
        let openEyes = SKAction.setTexture(eyesOpen)
        let sequence = SKAction.sequence([closeEyes, wait2, openEyes, wait1, closeEyes, wait2, openEyes, wait2, closeEyes, wait2, openEyes, wait1])
        sprite.run(.repeatForever(sequence))
    }
    
    func closeEyes(){
        lyingGirl!.removeAllActions()
        let closeEyes = SKAction.setTexture(goodnightAtlas.textureNamed("PigeLiggendeLukkedeØjne"))
        lyingGirl!.run(closeEyes)
    }
    
    override func willMove(from view: SKView) {
        self.eyesTimer.invalidate()
        self.handShakeTimer.invalidate()
        self.changeSceneTimer.invalidate()
        self.lyingGirlTimer.invalidate()
        self.duvetTimer.invalidate()
        self.closeEyesTimer.invalidate()
        self.blackScreenTimer.invalidate()
        self.backToHomeTimer.invalidate()
        self.lyingGirl?.removeAllActions()
        self.lyingGirl?.removeFromParent()
        self.girl.removeAllActions()
        self.girl.removeFromParent()        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime
        }
    func presentGirl() {
        let move = SKAction.moveTo(x: self.frame.minX + girl.size.width/2, duration: 5.0)
        girl.run(move)
    }
    
}
