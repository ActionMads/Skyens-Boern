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
import UIKit

// Extension to the Scene class handling the info signs for all games
extension Scene {
    
    // Start sign
    func makeStartSign(position: CGPoint) -> SKSpriteNode {
        let startSign = SKSpriteNode(texture: infoAtlas.textureNamed("StartSkilt"))
        startSign.position = position
        startSign.size = CGSize(width: self.frame.width/sizeDivider, height: self.frame.height/sizeDivider)
        startSign.name = "startBtn"
        startSign.zPosition = 10
        return startSign
    }
    
    // Restart sign
    func makeRestartSign(position: CGPoint) -> SKSpriteNode {
        let restartSign = SKSpriteNode(texture: infoAtlas.textureNamed("PrøvIgen"))
        restartSign.size = CGSize(width: self.frame.width/sizeDivider, height: self.frame.height/sizeDivider)
        restartSign.position = position
        restartSign.name = "restartBtn"
        restartSign.zPosition = 10
        // Add yes and no btns
        makeOptionButtons(sign: restartSign)
        return restartSign
    }
    
    // Yes and no btns for restart and end sign
    func makeOptionButtons(sign: SKSpriteNode){
        let yesButton = SKSpriteNode(texture: infoAtlas.textureNamed("Ja_Grå"))
        let noButton = SKSpriteNode(texture: infoAtlas.textureNamed("Nej_Grå"))
        // define btn size according to the parent sign size
        let buttonSize = CGSize(width: sign.size.width/4, height: sign.size.height/6)
        yesButton.size = buttonSize
        noButton.size = buttonSize
        noButton.zPosition = 11
        yesButton.zPosition = 11
        // Set the btn position
        yesButton.position = CGPoint(x: 0 - yesButton.size.width * 0.8, y: 0 - yesButton.size.height * 1.8)
        noButton.position = CGPoint(x: yesButton.position.x + noButton.size.width + 21, y: yesButton.position.y)
        yesButton.name = "yes"
        noButton.name = "no"
        sign.addChild(yesButton)
        sign.addChild(noButton)
    }
    
    // Set the color of the btn
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
    
    // End sign
    func makeEndSign(position: CGPoint) -> SKSpriteNode {
        let endSign = SKSpriteNode(texture: infoAtlas.textureNamed("SlutSkilt"))
        endSign.size = CGSize(width: self.frame.width/sizeDivider, height:  self.frame.width/sizeDivider)
        endSign.position = position
        endSign.name = "endBtn"
        endSign.zPosition = 10
        makeOptionButtons(sign: endSign)
        return endSign
    }
    
    // Back btn
    func makeBackBtn(){
        let backBtn = SKSpriteNode(texture: infoAtlas.textureNamed("TilbageKnap"), size: CGSize(width: self.frame.width/10, height: self.frame.width/22))
        backBtn.position = CGPoint(x: self.frame.minX + backBtn.size.width/2 + 50, y: self.frame.minY + backBtn.size.height/2 + 35)
        backBtn.zPosition = 11
        backBtn.name = "backBtn"
        addChild(backBtn)
    }
    
    // Help on/off btn
    func makeHelpBtn(){
        self.helpBtn = SKSpriteNode(texture: infoAtlas.textureNamed("HjælpKnap"), size: CGSize(width: self.frame.width/20, height: self.frame.width/10))
        self.helpBtn.position = CGPoint(x: self.frame.maxX - helpBtn.size.width/2 - 50, y: self.frame.minY + helpBtn.size.height/2 + 35)
        self.helpBtn.zPosition = 11
        self.helpBtn.name = "helpBtn"
        addChild(helpBtn)
    }
    
    // Change the texture of the help btn
    func helpBtnAction(){
        print("Help is on: ", self.helpIsOn)
        switch self.helpIsOn {
        case true:
            helpBtn.texture = infoAtlas.textureNamed("HjælpKnapOn")
            self.helpIsOn = false
            break
        case false:
            helpBtn.texture = infoAtlas.textureNamed("HjælpKnap")
            self.helpIsOn = true
            break
        }
    }
    
    // set the size divider according to the correct scale
    func setSizeDivider(scale : CGFloat){
            sizeDivider = scale
    }
    
}
