//
//  MusicScene.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 24/11/2023.
//  Copyright © 2023 Mads Munk. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

enum playerImageNames: String, CaseIterable {
    case player1 = "SkyAfspiller-Hulen"
    case player2 = "SkyAfspiller-Eventyr"
    case player3 = "SkyAfspiller-EnGodMelodi"
    case player4 = "SkyAfspiller-DerVarEngang"
    case player5 = "SkyAfspiller-Yndlingsdyr"
    case player6 = "SkyAfspiller-Godnatsang"
}

enum songTitles: String, CaseIterable {
    case song1 = "02 Hulen"
    case song2 = "04 Eventyr"
    case song3 = "06 En god melodi"
    case song4 = "05 Der var engang en mand"
    case song5 = "03 Yndlingsdyr"
    case song6 = "07 Godnatsang"
    
}

class MusicScene: Scene {
    
    let menuAtlas : SKTextureAtlas = SKTextureAtlas(named: "Menu Sprites")
    var hulenPlayer = MusicPlayer()
    var eventyrPlayer = MusicPlayer()
    var enGodMelodiPlayer = MusicPlayer()
    var derVarEngangPlayer = MusicPlayer()
    var yndlingsDyrPlayer = MusicPlayer()
    var godnatSangPlayer = MusicPlayer()
    var players : Dictionary<String, MusicPlayer> = [:]
    let completedLevelKeys : Dictionary<String, String> = ["caveCompleted" : playerImageNames.player1.rawValue, "favoriteAnimalCompleted" : playerImageNames.player5.rawValue, "thereOnceWasAManCompleted" : playerImageNames.player4.rawValue, "aGoodMelodiCompleted" : playerImageNames.player3.rawValue, "goodnightSongCompleted" : playerImageNames.player6.rawValue, "adventureCompleted" : playerImageNames.player2.rawValue]
    
    
    override func sceneDidLoad() {
        setScene()
        loadMusicPlayers()
    }
    
    func setScene() {
        makeBackground()
        makeBackBtn()
        makePlayer(imageName: playerImageNames.player1.rawValue, startPosition: CGPoint(x: self.frame.minX - 600, y: self.frame.maxY - 350))
        makePlayer(imageName: playerImageNames.player2.rawValue, startPosition: CGPoint(x: self.frame.minX - 600, y: self.frame.maxY - 1025))
        makePlayer(imageName: playerImageNames.player3.rawValue, startPosition: CGPoint(x: self.frame.minX - 600, y: self.frame.maxY - 1700))
        makePlayer(imageName: playerImageNames.player4.rawValue, startPosition: CGPoint(x: self.frame.maxX + 600, y: self.frame.maxY - 350))
        makePlayer(imageName: playerImageNames.player5.rawValue, startPosition: CGPoint(x: self.frame.maxX + 600, y: self.frame.maxY - 1025))
        makePlayer(imageName: playerImageNames.player6.rawValue, startPosition: CGPoint(x: self.frame.maxX + 600, y: self.frame.maxY - 1700))
        animatePlayers()
        for key in completedLevelKeys.keys {
            guard let playerName = completedLevelKeys[key] else {return}
            self.deaktivatePlayers(key: key, playerName: playerName)
        }
    }
    
    func loadMusicPlayers(){
        players[playerImageNames.player1.rawValue] = hulenPlayer
        players[playerImageNames.player2.rawValue] = eventyrPlayer
        players[playerImageNames.player3.rawValue] = enGodMelodiPlayer
        players[playerImageNames.player4.rawValue] = derVarEngangPlayer
        players[playerImageNames.player5.rawValue] = yndlingsDyrPlayer
        players[playerImageNames.player6.rawValue] = godnatSangPlayer

    }
    
    func deaktivatePlayers(key : String, playerName : String){
        if defaults.value(forKey: key) as? Bool != true {
            let player = self.childNode(withName: playerName)
            let playBtn = player?.childNode(withName: "play") as? SKSpriteNode
            let stopBtn = player?.childNode(withName: "stop") as? SKSpriteNode
            player?.alpha = 0.5
            playBtn?.name = "deaktivated"
            stopBtn?.name = "deaktivated"
        }
    }
    
    func animatePlayers(){
        var i = 1
        for p in playerImageNames.allCases {
            let node = childNode(withName: p.rawValue) as! SKSpriteNode
            if i < 4 {
                animateLeftPlayers(player: node)
            }else{
                animateRightPlayers(player: node)
            }
            i += 1
        }
    }
    
    func makeBackground(){
        let background = SKSpriteNode(texture: menuAtlas.textureNamed("Stille Morgen"))
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = 0
        addChild(background)
    }
    
    func makeHeadTitle() {
        let title = SKSpriteNode(texture: menuAtlas.textureNamed("Skyens Børn Header"))
        title.size = CGSize(width: 1500, height: 1000)
        title.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - title.size.height/2)
        title.zPosition = 1
        addChild(title)
    }
    
    func animateLeftPlayers(player : SKSpriteNode){
        let moveAction = SKAction.move(to: CGPoint(x: player.position.x + self.frame.width/2, y: player.position.y), duration: 1.5)
        player.run(moveAction)
    }
    
    // Animate the right buttons
    func animateRightPlayers(player : SKSpriteNode){
        let moveAction = SKAction.move(to: CGPoint(x: player.position.x - self.frame.width/2, y: player.position.y), duration: 1.5)
        player.run(moveAction)
    }
    
    func makePlayer(imageName: String, startPosition : CGPoint){
        print(imageName)
        let player = SKSpriteNode(texture: menuAtlas.textureNamed(imageName))
        player.size = CGSize(width: 1100, height: 650)
        player.position = startPosition
        player.name = imageName
        player.zPosition = 2
        let playBtn = SKSpriteNode(texture: self.menuAtlas.textureNamed("Play-Knap"))
        playBtn.size = CGSize(width: 150, height: 150)
        playBtn.name = "play"
        playBtn.position = CGPoint(x: -265, y: 45)
        playBtn.zPosition = 3
        let stopBtn = SKSpriteNode(texture: self.menuAtlas.textureNamed("Stop-Knap"))
        stopBtn.size = CGSize(width: 160, height: 160)
        stopBtn.name = "stop"
        stopBtn.position = CGPoint(x: -430, y: 45)
        stopBtn.zPosition = 3
        player.addChild(stopBtn)
        player.addChild(playBtn)
        addChild(player)
    }
    
    func pauseOtherPlayers(playerName : String){
        for key in players.keys {
            if key != playerName {
                players[key]?.pause()
            }
        }
        for child in self.children {
            if child.name != playerName {
                if let sprite = child.childNode(withName: "pause") as? SKSpriteNode {
                    sprite.texture = self.menuAtlas.textureNamed("Play-Knap")
                    sprite.name = "resumePlay"
                }
            }
        }
    }
    
    override func stopMusic(parentName : String) {
        let player = players[parentName]
        player?.stopMusic()
        let playerNode = self.childNode(withName: parentName)
        let playBtn = playerNode?.childNode(withName: "pause") as? SKSpriteNode
        playBtn?.texture = self.menuAtlas.textureNamed("Play-Knap")
        playBtn?.name = "play"
    }
    
    override func playPauseMusic(node : SKSpriteNode, parentName : String) -> String {
        print("MusicNode name: ", node.name)
        print("Parent Name: ", parentName)
        var name : String = ""
        var url : String = ""
        
        switch parentName {
        case playerImageNames.player1.rawValue:
            url = songTitles.song1.rawValue
            break
        case playerImageNames.player2.rawValue:
            url = songTitles.song2.rawValue
            break
        case playerImageNames.player3.rawValue:
            url = songTitles.song3.rawValue
            break
        case playerImageNames.player4.rawValue:
            url = songTitles.song4.rawValue
            break
        case playerImageNames.player5.rawValue:
            url = songTitles.song5.rawValue
            break
        case playerImageNames.player6.rawValue:
            url = songTitles.song6.rawValue
            break
        default:
            break
        }
        
        if node.name == "play" {
            let player = players[parentName]
            pauseOtherPlayers(playerName: parentName)
            player?.play(url: url)
            node.texture = self.menuAtlas.textureNamed("Pause-Knap")
            name = "pause"
        }
        
        if node.name == "pause" {
            let player = players[parentName]
            player?.pause()
            
            node.texture = self.menuAtlas.textureNamed("Play-Knap")
            name = "resumePlay"
        }
        
        if node.name == "resumePlay" {
            let player = players[parentName]
            pauseOtherPlayers(playerName: parentName)
            player?.play()
            node.texture = self.menuAtlas.textureNamed("Pause-Knap")
            name = "pause"
        }
        
        return name
    }
}
