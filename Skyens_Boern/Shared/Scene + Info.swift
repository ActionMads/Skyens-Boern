//
//  Info.swift
//  Dromedary
//
//  Created by Mads Munk on 16/11/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension Scene {
    
    func makeStartSign(position: CGPoint) -> SKSpriteNode {
        let startSign = SKSpriteNode(texture: infoAtlas.textureNamed("StartSkilt"))
        startSign.position = position
        startSign.size = CGSize(width: self.frame.width/2, height: self.frame.height/2)
        startSign.name = "startBtn"
        startSign.zPosition = 10
        return startSign
    }
    
    func makeRestartSign(position: CGPoint) -> SKSpriteNode {
        calculateSizeDivider()
        let restartSign = SKSpriteNode(texture: infoAtlas.textureNamed("PrøvIgen"))
        restartSign.size = CGSize(width: self.frame.width/sizeDivider, height: self.frame.height/sizeDivider)
        restartSign.position = position
        print("restart position", restartSign.position)
        restartSign.name = "restartBtn"
        restartSign.zPosition = 10
        //addChild(restartSign)
        makeRestartButtons(restartSign: restartSign)
        //pauseGame()
        return restartSign
    }
    
    func makeRestartButtons(restartSign: SKSpriteNode){
        let yesButton = SKSpriteNode(texture: infoAtlas.textureNamed("Ja_Grå"))
        let noButton = SKSpriteNode(texture: infoAtlas.textureNamed("Nej_Grå"))
        let buttonSize = CGSize(width: restartSign.size.width/4, height: restartSign.size.height/6)
        yesButton.size = buttonSize
        noButton.size = buttonSize
        noButton.zPosition = 11
        yesButton.zPosition = 11
        yesButton.position = CGPoint(x: 0 - yesButton.size.width * 0.8, y: 0 - yesButton.size.height * 1.8)
        noButton.position = CGPoint(x: yesButton.position.x + noButton.size.width + 21, y: yesButton.position.y)
        print("Button position", yesButton.position)
        yesButton.name = "yes"
        noButton.name = "no"
        restartSign.addChild(yesButton)
        restartSign.addChild(noButton)
    }
    
    func setTextureButton(button: SKSpriteNode){
        print("setting texture")
        var texture: SKTexture!
        if button.name == "yes"{
            texture = infoAtlas.textureNamed("Ja_Grøn")
        }
        if button.name == "no"{
            texture = infoAtlas.textureNamed("Nej_Rød")
        }
        let changeTexture = SKAction.setTexture(texture)
        button.run(changeTexture)
    }
    
    func makeEndSign(position: CGPoint) -> SKSpriteNode {
        calculateSizeDivider()
        let endSign = SKSpriteNode(texture: infoAtlas.textureNamed("SlutSkilt"))
        endSign.size = CGSize(width: self.frame.width/sizeDivider, height:  self.frame.width/sizeDivider)
        endSign.position = position
        endSign.name = "endBtn"
        endSign.zPosition = 10
        makeRestartButtons(restartSign: endSign)
        return endSign
    }
    
    func makeBackBtn(){
        let backBtn = SKSpriteNode(texture: infoAtlas.textureNamed("TilbageKnap"), size: CGSize(width: self.frame.width/10, height: self.frame.width/20))
        backBtn.position = CGPoint(x: self.frame.minX + backBtn.size.width/2 + 50, y: self.frame.minY + backBtn.size.height/2 + 35)
        backBtn.zPosition = 9
        backBtn.name = "backBtn"
        addChild(backBtn)
    }
    
    func calculateSizeDivider(){
        if self.withCamera {
            sizeDivider = 1.5
        }else {
            sizeDivider = 2
        }
    }
    
}
