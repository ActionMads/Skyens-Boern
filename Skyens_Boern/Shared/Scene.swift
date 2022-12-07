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



class Scene : SKScene {
    
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
    
    override func didMove(to view: SKView) {
        self.setupInteractionHandlers()
    }
    
    override func sceneDidLoad(){
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
    
    func startGame() {
    }
    
    func restart() {
    }
    
    func backToHome() {
        gameIsRunning = false
        musicPlayer.fadeOut()
        self.viewController.previusScene = self
        self.viewController.selectScene(selectedScene: HomeScene(size: CGSize(width: 2732, height: 2048)))
        self.viewController.isFirst = false
    }
    
    override func willMove(from view: SKView) {
        print("will move")
    }
    
    override func update(_ currentTime: TimeInterval) {
        print("previus scene: ", self.viewController.previusScene)
        if self.viewController.previusScene == nil && self.viewController.isFirst == false {
            print("Previus Scene released")
        }
    }
    
}
