//
//  Scene.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 24/08/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// The scene class which all other scenes inherit from
class Scene : SKScene {
    
    // Gobal varibles
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var panRecogniser: UIPanGestureRecognizer!
    var clickRecognizer : UILongPressGestureRecognizer!
    var rotationRecogniser : UIRotationGestureRecognizer!
    var entityBeingInteractedWith : GKEntity?
    weak var viewController : ViewController!
    let musicPlayer : MusicPlayer = MusicPlayer()
    let infoAtlas : SKTextureAtlas = SKTextureAtlas(named: "Info Sprites")
    var withCamera : Bool = false
    var sizeDivider : CGFloat = 2
    var gameIsRunning : Bool = false
    let speakPlayer : MusicPlayer = MusicPlayer()
    var helpBtn : SKSpriteNode!
    var helpIsOn : Bool = true
    var canJump : Bool = false
    var dromedary: SKSpriteNode!
    var soundIsPlaying : Bool = false
    var itemHasBeenTouched : Bool = false
    let defaults = UserDefaults.standard
    
    // OVerride Did move to view
    override func didMove(to view: SKView) {
        self.setupInteractionHandlers()
    }
    
    // Override scene did load
    override func sceneDidLoad(){
    }
    
    // Get the top node according to zposition
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
    
    // Following fuctions a define so that the can be call from scene+Touch extension
    
    // Define a jump function
    func jump(sprite: SKSpriteNode){
    }
    
    // Define a shot function
    func shot(){
    }
    
    // Define moveShipTowards function
    func moveShipTowards(location: CGPoint){
    }
    
    // Define startgame function
    func startGame() {
    }
    
    // Define restart function
    func restart() {
    }
    
    // BackToHome function
    func backToHome() {
        gameIsRunning = false
        musicPlayer.fadeOut()
        self.viewController.previusScene = self
        self.viewController.selectScene(selectedScene: HomeScene(size: CGSize(width: 2732, height: 2048)))
        self.viewController.isFirst = false
    }
    
    // Play speak
    func playSpeak(name: String, length: CGFloat){
        if self.helpIsOn && self.soundIsPlaying == false {
            print("preparing speak")
            let fadeDown = SKAction.run {
                self.soundIsPlaying = true
                self.musicPlayer.fadeDown()
            }
            let fadeUp = SKAction.run {
                self.musicPlayer.fadeIn()
            }
            let playSpeak = SKAction.run {
                self.speakPlayer.play(url: name)
            }
            let setSoundIsPlaying = SKAction.run {
                self.soundIsPlaying = false
            }
            let wait1 = SKAction.wait(forDuration: 1)
            let wait2 = SKAction.wait(forDuration: length)
            let sequence = SKAction.sequence([fadeDown, wait1, playSpeak, wait2, fadeUp, setSoundIsPlaying])
            self.run(sequence)
        }
    }
    
    // Play speak when there is no music playing
    func playSpeakNoMusic(name : String){
        if self.helpIsOn {
            let playSpeak = SKAction.run {
                self.speakPlayer.play(url: name)
            }
            self.run(playSpeak)
        }
    }
    
    func playPauseMusic(node : SKSpriteNode, parentName : String) -> String {
        return ""
    }
    
    func stopMusic(parentName : String){
    }
    
    // wiggle a sprite that can be interacted with to guide the player
    func wiggle(sprite : SKSpriteNode){
        let turnLeft = SKAction.rotate(toAngle: -0.1, duration: 0.1)
        let turnRight = SKAction.rotate(toAngle: 0.1, duration: 0.1)
        let turnCenter = SKAction.rotate(toAngle: 0, duration: 0.1)
        let sequence = SKAction.sequence([turnLeft, turnRight, turnLeft, turnRight, turnLeft, turnRight, turnCenter])
        sprite.run(sequence)
    }
    
    override func willMove(from view: SKView) {
        print("will move")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Test to see if previus scene is released proberly
        print("previus scene: ", self.viewController.previusScene as Any)
        if self.viewController.previusScene == nil && self.viewController.isFirst == false {
            print("Previus Scene released")
        }
    }
    
}
