//
//  GameViewController.swift
//  Onely
//
//  Created by Jevier Izza Maulana on 28/04/22.
//

import UIKit

import GameKit

import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var numbersLabel: UILabel?
    @IBOutlet weak var scoreLabel: UILabel?
    @IBOutlet weak var inputField: UITextField?
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var vwContainer: UIImageView!
    @IBOutlet weak var vwMinusContainer: UIImageView!
    
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    //    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
//        
//    }
    
    public var score:Int = 0
    
    var timer:Timer?
    var seconds:Int = 60
    
    var mistake:Int = 0
    
    var isAlive:Bool = true
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //playBackgrounMusic(filename: "Amusing_Day")
        
        self.heart1.alpha = 1.0
        self.heart2.alpha = 1.0
        self.heart3.alpha = 1.0
        
        self.vwContainer.alpha = 0.0
        self.vwContainer.layer.cornerRadius = 1.0
        
        self.vwMinusContainer.alpha = 0.0
        self.vwMinusContainer.layer.cornerRadius = 1.0
        
        setRandomNumberLabel()
        updateScoreLabel()
        
        setTimer()
        
        inputField?.addTarget(self, action: #selector(GameViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    
    func setTimer() {
        if(timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onUpdateTimer), userInfo: nil, repeats: true)
        }
    }

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if inputField?.text?.count ?? 0 < 4 {
            return
        }
        
        if let numbers_text = numbersLabel?.text, let input_text = inputField?.text, let numbers = Int(numbers_text), let input = Int(input_text) {
            //print("Comparing: \(input_text) minus \(numbers_text) == \(input - numbers)")
            
            if(input - numbers == 1111) {
                //print("Correct")
                MusicHelper.sharedHelper.playCorrectSFX()
                inputField?.text = ""
                score += 1
                
                if self.vwContainer.alpha == 0.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                        self.vwContainer.alpha = 1.0
                    })
                }
                if self.vwContainer.alpha == 1.0 {
                    UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut, animations: {
                        self.vwContainer.alpha = 0.0
                    })
                }
            }
            else {
                //print("Incorect")
                MusicHelper.sharedHelper.playIncorrectSFX()
                inputField?.text = ""
                if(score > 0) {
                    score -= 1
                     
                    if self.vwMinusContainer.alpha == 0.0 {
                        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                            self.vwMinusContainer.alpha = 1.0
                        })
                    }
                    if self.vwMinusContainer.alpha == 1.0 {
                        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut, animations: {
                            self.vwMinusContainer.alpha = 0.0
                        })
                    }
                }
                
                mistake += 1
                
                if(mistake == 1) {
                    UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseOut, animations: {
                        self.heart1.alpha = 0.0
                    })
                }
                if(mistake == 2) {
                    UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseOut, animations: {
                        self.heart2.alpha = 0.0
                    })
                }
                if(mistake == 3) {
                    isAlive = false
                    UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseOut, animations: {
                        self.heart3.alpha = 0.0
                    })
                    
                    let alertController = UIAlertController(title: "Run out of Lives", message: "Your score is : \(score) points", preferredStyle: .alert)
                    
                    let restartAction = UIAlertAction(title: "Play Again", style: .default) {(action) in
                        
                        self.restartGame()
                    }
                    
                    alertController.addAction(restartAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        
    }
    
    @objc func onUpdateTimer() -> Void {
        if(isAlive == true) {
            if(seconds > 0 && seconds <= 60) {
                seconds -= 1
                updateTimeLabel()
            }
            else if (seconds == 0) {
                if (timer != nil) {
                    timer!.invalidate()
                    timer = nil
                    
                    MusicHelper.sharedHelper.playGameOverSFX()
                    
                    saveHighScore(number: score)
                    
                    let alertController = UIAlertController(title: "Time is Up!", message: "Your time is up! Your score is : \(score) points", preferredStyle: .alert)
                    
                    let restartAction = UIAlertAction(title: "Play Again", style: .default) {(action) in
                        
                        self.restartGame()
                    }
                    
                    alertController.addAction(restartAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
        
    }
    
    func updateTimeLabel() {
        if(timeLabel != nil) {
            let min:Int = (seconds / 60) % 60
            let sec:Int = seconds % 60
            
            let min_p:String = String(format: "%02d", min)
            
            let sec_p:String = String(format: "%02d",sec)
            
            timeLabel!.text = "\(min_p):\(sec_p)"
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = "\(score)"
    }
    
    func setRandomNumberLabel() {
        numbersLabel?.text = generateRandomString()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func generateRandomString() -> String {
        var result: String = ""
        
        for _ in 1...4 {
            let digit:Int = Int(arc4random_uniform(8) + 1)
            
            result += "\(digit)"
        }
        
        return result
    }
    
    func saveHighScore(number: Int) {
        if GKLocalPlayer.local.isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier:  "OBS")
            scoreReporter.value = Int64(number)
            
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    
    func restartGame() {
        self.score = 0
        self.seconds = 60
        
        self.isAlive = true
        
        self.heart1.alpha = 1.0
        self.heart2.alpha = 1.0
        self.heart3.alpha = 1.0
        
        self.setTimer()
        self.updateTimeLabel()
        self.updateScoreLabel()
        self.setRandomNumberLabel()
    }
    
//    func playBackgrounMusic(filename: String) {
//        let url = Bundle.main.url(forResource: filename, withExtension: "mp3")
//
//        guard let newURL = url else {
//            print("Cannot find file: \(filename)")
//            return
//        }
//        do {
//            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
//            backgroundMusicPlayer.numberOfLoops = -1
//            backgroundMusicPlayer.prepareToPlay()
//            backgroundMusicPlayer.play()
//        } catch let error as NSError {
//            print(error.description)
//        }
//    }
}

//class MusicHelper {
//    static let sharedHelper = MusicHelper()
//    var audioPlayer: AVAudioPlayer?
//    var sfxCorrectPlayer: AVAudioPlayer?
//    var sfxIncorrectPlayer: AVAudioPlayer?
//    var sfxGameOverPlayer: AVAudioPlayer?
//
//    func playBGM() {
//
//        let bgm = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Amusing_Day", ofType: "mp3")!)
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf:  bgm as URL)
//            audioPlayer!.numberOfLoops = -1
//            audioPlayer!.volume = 0.8
//            audioPlayer!.prepareToPlay()
//            audioPlayer!.play()
//        } catch {
//            print("Cannot Play File")
//        }
//    }
//
//    func stopBGM() {
//        audioPlayer!.stop()
//    }
//
//    func playSong(notification: NSNotification) {
//        audioPlayer?.pause()
//    }
//
//    func playGameOverSFX() {
//        let sfxGameOver = NSURL(fileURLWithPath: Bundle.main.path(forResource: "gameOver", ofType: "mp3")!)
//
//        do {
//            sfxGameOverPlayer = try AVAudioPlayer(contentsOf: sfxGameOver as URL)
//            sfxGameOverPlayer!.volume = 2.0
//            sfxGameOverPlayer!.prepareToPlay()
//            sfxGameOverPlayer!.play()
//        } catch {
//            print("Can't play sfx correct")
//        }
//    }
//
//    func playCorrectSFX() {
//        let sfxCorrect = NSURL(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "mp3")!)
//
//        do {
//            sfxCorrectPlayer = try AVAudioPlayer(contentsOf: sfxCorrect as URL)
//            sfxCorrectPlayer!.volume = 1.5
//            sfxCorrectPlayer!.prepareToPlay()
//            sfxCorrectPlayer!.play()
//        } catch {
//            print("Can't play sfx correct")
//        }
//    }
//
//    func playIncorrectSFX() {
//        let sfxIncorrect = NSURL(fileURLWithPath: Bundle.main.path(forResource: "incorrect", ofType: "mp3")!)
//
//        do {
//            sfxIncorrectPlayer = try AVAudioPlayer(contentsOf: sfxIncorrect as URL)
//            sfxIncorrectPlayer!.volume = 1.5
//            sfxIncorrectPlayer!.prepareToPlay()
//            sfxIncorrectPlayer!.play()
//        } catch {
//            print("Can't play sfx correct")
//        }
//    }
//
//}
