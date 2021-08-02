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

class Info {
    
    func makeStartSign(position: CGPoint) -> SKSpriteNode {
        let startSign = SKSpriteNode(imageNamed: "StartSkilt")
        startSign.position = position
        startSign.size = CGSize(width: 1500, height: 1000)
        startSign.name = "startBtn"
        startSign.zPosition = 10
        return startSign
    }
    
    func makeRestartSign(position: CGPoint, Size: CGSize) -> SKSpriteNode {
        let restartSign = SKSpriteNode(imageNamed: "PrøvIgen.png")
        restartSign.size = Size
        restartSign.position = position
        restartSign.name = "restartBtn"
        restartSign.zPosition = 10
        //addChild(restartSign)
        makeRestartButtons(restartSign: restartSign)
        //pauseGame()
        return restartSign
    }
    
    func makeRestartButtons(restartSign: SKSpriteNode){
        let yesButton = SKSpriteNode(imageNamed: "Ja_Grå.png")
        let noButton = SKSpriteNode(imageNamed: "Nej_Grå.png")
        yesButton.size = CGSize(width: 400, height: 200)
        noButton.size = CGSize(width: 400, height: 200)
        noButton.zPosition = 11
        yesButton.zPosition = 11
        yesButton.position = CGPoint(x: 100 - yesButton.size.width, y: 0 - yesButton.size.height * 2.5)
        noButton.position = CGPoint(x: yesButton.position.x + noButton.size.width + 21, y: yesButton.position.y)
        yesButton.name = "yes"
        noButton.name = "no"
        restartSign.addChild(yesButton)
        restartSign.addChild(noButton)
    }
    
    func setTextureButton(button: SKSpriteNode){
        print("setting texture")
        var texture: SKTexture!
        if button.name == "yes"{
            texture = SKTexture(imageNamed: "Ja_Grøn.png")
        }
        if button.name == "no"{
            texture = SKTexture(imageNamed: "Nej_Rød.png")
        }
        let changeTexture = SKAction.setTexture(texture)
        button.run(changeTexture)
    }
    
    func makeEndSign(position: CGPoint) -> SKSpriteNode {
        let endSign = SKSpriteNode(imageNamed: "SlutSkilt")
        endSign.size = CGSize(width: 1500, height: 1500)
        endSign.position = position
        endSign.name = "endBtn"
        endSign.zPosition = 10
        makeRestartButtons(restartSign: endSign)
        return endSign
    }
    
}
