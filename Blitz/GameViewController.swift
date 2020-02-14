//
//  GameViewController.swift
//  Arc
//
//  Created by Keith C on 12/22/18.
//  Copyright © 2018 Keith C. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    

    //creates audio player
    static var audioPlayer = AVAudioPlayer()
    
    override func loadView() {
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        authPlayer()
        */
        
        //null check for music
        if UserDefaults.standard.object(forKey: "music") as? Bool == nil {
            UserDefaults.standard.set(true, forKey: "music")
        }
        
        //plays music and loops it
        do {
            GameViewController.audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "blitz", ofType: "m4a")!))
        }
        catch {
            print(error)
        }
        
        //if music is on
        if UserDefaults.standard.object(forKey: "music") as? Bool == true {
            GameViewController.audioPlayer.prepareToPlay()
            GameViewController.audioPlayer.play()
            GameViewController.audioPlayer.numberOfLoops = -1
        } 
        
        
        if let view = self.view as! SKView? {
            //starts tutorial if not complete
            if UserDefaults.standard.object(forKey: "tutorial") as? Bool == true {
                if let scene = SKScene(fileNamed: "GameMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
            }
            //else starts from menu
            else {
                if let scene = SKScene(fileNamed: "Tutorial") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
            }
            
            
            view.ignoresSiblingOrder = true
            
            
            // FPS/NODE COUNT
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
    
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /*
    func showLeaderBoard() {
        let viewController = self
        let gcvc = GKGameCenterViewController()
        gcvc.gameCenterDelegate = self
        
        
        viewController.present(gcvc, animated: true, completion: nil)
        
        print("showed")
    }
    
    func saveHighscore(number : Int) {
        
        if GKLocalPlayer.local.isAuthenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "keithc.Blitz.Scores")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
            
            print("saved")
            
        }
    }
    
    
    //game center
    func authPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            }
            else {
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }*/
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
}

