//
//  HomeScene.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 23/08/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

// enum with btn image names
enum btnImageNames: String, CaseIterable {
    case btn1 = "Hulen_Knap"
    case btn2 = "Eventyr_Knap"
    case btn3 = "EnGodMelodi_Knap"
    case btn4 = "DerVarEngang_Knap"
    case btn5 = "Yndlingsdyr_Knap"
    case btn6 = "Godnatsang_Knap"
    case btn7 = "Musik-Knap"
}

// Home scene class
class HomeScene : Scene  {
    
    let menuAtlas : SKTextureAtlas = SKTextureAtlas(named: "Menu Sprites")
        
    override func sceneDidLoad() {
        setScene()        
    }
    
    // make scene with btns, background and title
    func setScene() {
        self.musicPlayer.play(url: "01 Stille morgen")
        makeBackground()
        makeHeadTitle()
        makeBtn(imageName: btnImageNames.btn1.rawValue, startPosition: CGPoint(x: self.frame.minX - 500, y: self.frame.midY))
        makeBtn(imageName: btnImageNames.btn2.rawValue, startPosition: CGPoint(x: self.frame.minX - 500, y: self.frame.midY - 400))
        makeBtn(imageName: btnImageNames.btn3.rawValue, startPosition: CGPoint(x: self.frame.minX - 500, y: self.frame.midY - 800))
        makeBtn(imageName: btnImageNames.btn4.rawValue, startPosition: CGPoint(x: self.frame.maxX + 500, y: self.frame.midY))
        makeBtn(imageName: btnImageNames.btn5.rawValue, startPosition: CGPoint(x: self.frame.maxX + 500, y: self.frame.midY - 400))
        makeBtn(imageName: btnImageNames.btn6.rawValue, startPosition: CGPoint(x: self.frame.maxX + 500, y: self.frame.midY - 800))
        makeMusicBtn(imageName: btnImageNames.btn7.rawValue, startPosition: CGPoint(x: self.frame.maxX + 1000, y: self.frame.midY + 400))
        animateBtns()
    }
    
    // Animate the btns
    func animateBtns(){
        var i = 1
        for b in btnImageNames.allCases {
            let node = childNode(withName: b.rawValue) as! SKSpriteNode
            if i < 4 {
                animateLeftBtn(btn: node)
            }else{
                animateRightBtn(btn: node)
            }
            i += 1
        }
    }
    
    // Make the background
    func makeBackground(){
        let background = SKSpriteNode(texture: menuAtlas.textureNamed("Stille Morgen"))
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = 0
        addChild(background)
    }
    
    // Make the head title
    func makeHeadTitle() {
        let title = SKSpriteNode(texture: menuAtlas.textureNamed("Skyens Børn Header"))
        title.size = CGSize(width: 1500, height: 1000)
        title.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - title.size.height/2)
        title.zPosition = 1
        addChild(title)
    }
    
    // Make a button
    func makeBtn(imageName: String, startPosition : CGPoint){
        print(imageName)
        let btn = SKSpriteNode(texture: menuAtlas.textureNamed(imageName))
        btn.size = CGSize(width: 1000, height: 400)
        btn.position = startPosition
        btn.name = imageName
        btn.zPosition = 2
        addChild(btn)
    }
    
    // Make Music Button
    func makeMusicBtn(imageName: String, startPosition : CGPoint){
        print(imageName)
        let btn = SKSpriteNode(texture: menuAtlas.textureNamed(imageName))
        btn.size = CGSize(width: 700, height: 350)
        btn.position = startPosition
        btn.name = imageName
        btn.zPosition = 2
        addChild(btn)
    }
    
    
    // Animate the left buttons
    func animateLeftBtn(btn : SKSpriteNode){
        let moveAction = SKAction.move(to: CGPoint(x: btn.position.x + self.frame.width/2, y: btn.position.y), duration: 1.5)
        btn.run(moveAction)
    }
    
    // Animate the right buttons
    func animateRightBtn(btn : SKSpriteNode){
        let moveAction = SKAction.move(to: CGPoint(x: btn.position.x - self.frame.width/2, y: btn.position.y), duration: 1.5)
        btn.run(moveAction)
    }
    
    // Clean up before moving from view
    override func willMove(from view: SKView) {
        print("Will move from menu")
        for b in btnImageNames.allCases {
            let node = childNode(withName: b.rawValue) as! SKSpriteNode
            print("Removing actions")
            node.removeAllActions()
        }
    }
}
