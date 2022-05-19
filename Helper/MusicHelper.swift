//
//  MusicHelper.swift
//  Onely
//
//  Created by Jevier Izza Maulana on 13/05/22.
//

import Foundation
import AVFoundation

class MusicHelper {
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    static let sharedHelper = MusicHelper()
    
    var audioPlayer: AVAudioPlayer?
    var sfxCorrectPlayer: AVAudioPlayer?
    var sfxIncorrectPlayer: AVAudioPlayer?
    var sfxGameOverPlayer: AVAudioPlayer?
    
    func playBGM() {

        let bgm = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Amusing_Day", ofType: "mp3")!)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf:  bgm as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.volume = 0.8
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot Play File")
        }
    }

    func stopBGM() {
        audioPlayer!.stop()
    }

    func playSong(notification: NSNotification) {
        audioPlayer?.pause()
    }
    
    func playGameOverSFX() {
        let sfxGameOver = NSURL(fileURLWithPath: Bundle.main.path(forResource: "gameOver", ofType: "mp3")!)
        
        do {
            sfxGameOverPlayer = try AVAudioPlayer(contentsOf: sfxGameOver as URL)
            sfxGameOverPlayer!.volume = 2.0
            sfxGameOverPlayer!.prepareToPlay()
            sfxGameOverPlayer!.play()
        } catch {
            print("Can't play sfx correct")
        }
    }
    
    func playCorrectSFX() {
        let sfxCorrect = NSURL(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "mp3")!)
        
        do {
            sfxCorrectPlayer = try AVAudioPlayer(contentsOf: sfxCorrect as URL)
            sfxCorrectPlayer!.volume = 1.5
            sfxCorrectPlayer!.prepareToPlay()
            sfxCorrectPlayer!.play()
        } catch {
            print("Can't play sfx correct")
        }
    }
    
    func playIncorrectSFX() {
        let sfxIncorrect = NSURL(fileURLWithPath: Bundle.main.path(forResource: "incorrect", ofType: "mp3")!)
        
        do {
            sfxIncorrectPlayer = try AVAudioPlayer(contentsOf: sfxIncorrect as URL)
            sfxIncorrectPlayer!.volume = 1.5
            sfxIncorrectPlayer!.prepareToPlay()
            sfxIncorrectPlayer!.play()
        } catch {
            print("Can't play sfx correct")
        }
    }

}
