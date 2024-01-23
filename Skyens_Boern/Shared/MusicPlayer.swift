//
//  MusicPlayer.swift
//  Dromedary
//
//  Created by Mads Munk on 28/02/2020.
//  Copyright © 2020 Mads Munk. All rights reserved.
//

import Foundation
import AVFoundation

// Musicplayer class responsible for playing music and sounds
class MusicPlayer {
    private var musicPlayer: AVAudioPlayer!
    
    // Stop musicplayer
    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer?.currentTime = 0
    }
    
    func pause() {
        musicPlayer?.pause()
    }
    
    func play(){
        musicPlayer.play()
    }
    
    func resumePlay(time : TimeInterval, url : String) {
        print("From resume play timecode: ", time, "Url: ", url)
        guard let url = Bundle.main.url(forResource: url, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            musicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = musicPlayer else { return }

            player.play(atTime: time)
            

        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    // Set the volume of the music player with parameter vol
    func setVolume(vol: Float) {
        musicPlayer?.setVolume(0, fadeDuration: 1)
    }
    
    // Fade out music player
    func fadeOut() {
        musicPlayer?.setVolume(0, fadeDuration: 1.0)
    }
    
    // Fade down music player
    func fadeDown() {
        musicPlayer?.setVolume(0.1, fadeDuration: 1.0)
    }
    
    // Fade in music player
    func fadeIn() {
        musicPlayer?.setVolume(1, fadeDuration: 1.0)
    }
    
    // Get the boolean indicating if the music player is playing
    func isPlaying() -> Bool{
        if musicPlayer != nil {
            return musicPlayer!.isPlaying
        }
        else {
            return false
        }
    }
    
    // Get time code of music player
    func getTimecode() -> TimeInterval {
        return musicPlayer!.currentTime
    }
    
    // play a mp3 sound or music with the given url
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
