//
//  ViewController.swift
//  Onely
//
//  Created by Jevier Izza Maulana on 28/04/22.
//

import UIKit
import GameKit

class ViewController: UIViewController, GKGameCenterControllerDelegate {

//    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
//
//    }
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MusicHelper.sharedHelper.playBGM()
        
        authPlayer()
    }
    

    @IBAction func openGC(_ sender: Any) {
        let VC = self.view.window?.rootViewController
        
        let CGVC = GKGameCenterViewController()
        
        CGVC.gameCenterDelegate = self
        
        VC?.present(CGVC, animated: false, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: false, completion: nil)
    }
    
    
    func authPlayer() {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
}

