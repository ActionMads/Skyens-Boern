//
//  MusicPlayer.swift
//  Dromedary
//
//  Created by Mads Munk on 28/02/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    private var musicPlayer: AVAudioPlayer!
    
    func stopMusic() {
        musicPlayer?.stop()
    }
    
    func setVolume(vol: Float) {
        musicPlayer?.setVolume(0, fadeDuration: 1)
    }
    
    func fadeOut() {
        musicPlayer?.setVolume(0, fadeDuration: 1.0)
    }
    
    func fadeDown() {
        musicPlayer?.setVolume(0.1, fadeDuration: 1.0)
    }
    
    func fadeIn() {
        musicPlayer?.setVolume(1, fadeDuration: 1.0)
    }
    
    func isPlaying() -> Bool{
        if musicPlayer != nil {
            return musicPlayer!.isPlaying
        }
        else {
            return false
        }
    }
    
    func getTimecode() -> TimeInterval {
        return musicPlayer!.currentTime
    }
    
    
    
    func play(url: String) {
           guard let url = Bundle.main.url(forResource: url, withExtension: "mp3") else { return }

           do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
               try AVAudioSession.sharedInstance().setActive(true)

               /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
               musicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

               /* iOS 10 and earlier require the following line:
               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

               guard let player = musicPlayer else { return }

               player.play()
               

           } catch let error {
               print(error.localizedDescription)
           }
       }
}
