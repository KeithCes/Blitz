//
//  Settings.swift
//  Blitz
//
//  Created by Keith C on 5/6/19.
//  Copyright © 2019 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class Settings: SKScene {
    
    var resetBackground = SKSpriteNode()
    var resetConfirm = SKSpriteNode()
    var resetDecline = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
        
        //sets initial mic on/off pic
        if UserDefaults.standard.object(forKey: "music") as? Bool == true {
            drawMusicIcon(mic: "micOn")
        }
        else {
            drawMusicIcon(mic: "micOff")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "backButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "GameMenu")
                gameScene!.scaleMode = .aspectFill
                view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
            else if atPoint(touchLocation).name == "mic" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                if UserDefaults.standard.object(forKey: "music") as? Bool == true {
                    GameViewController.audioPlayer.stop()
                    UserDefaults.standard.set(false, forKey: "music")
                    removeMic()
                    drawMusicIcon(mic: "micOff")
                }
                else if UserDefaults.standard.object(forKey: "music") as? Bool == false {
                    GameViewController.audioPlayer.prepareToPlay()
                    GameViewController.audioPlayer.play()
                    GameViewController.audioPlayer.numberOfLoops = -1
                    UserDefaults.standard.set(true, forKey: "music")
                    removeMic()
                    drawMusicIcon(mic: "micOn")
                }
            }
            else if atPoint(touchLocation).name == "resetButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                resetConfirmation()
            }
            else if atPoint(touchLocation).name == "resetConfConfirmation" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                resetDefaults()
                removeReset()
                GameViewController.audioPlayer.prepareToPlay()
                GameViewController.audioPlayer.play()
                GameViewController.audioPlayer.numberOfLoops = -1
                UserDefaults.standard.set(true, forKey: "music")
                UserDefaults.standard.set(true, forKey: "tutorial")
                let gameScene = SKScene(fileNamed: "GameMenu")
                gameScene!.scaleMode = .aspectFill
                view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: TimeInterval(5)))
            }
            else if atPoint(touchLocation).name == "resetConfDecline" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                removeReset()
            }
        }
    }
    
    //draws music on/off icon
    func drawMusicIcon(mic: String) {
        var musicIcon : SKSpriteNode!
        musicIcon = SKSpriteNode(imageNamed: mic)
        musicIcon.name = "mic"
        musicIcon.position.x = CGFloat(0)
        musicIcon.position.y = CGFloat(13)
        addChild(musicIcon)
    }
    
    //resets userDefaults
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    //removes mic icon
    @objc func removeMic() {
        for child in children {
            if (child.name == "mic") {
                child.removeFromParent()
            }
        }
    }
    
    //creates reset confirmation screen
    func resetConfirmation() {
        resetBackground = SKSpriteNode(imageNamed: "resetConfBackground")
        resetBackground.name = "resetConfBackground"
        resetBackground.position = CGPoint(x: 0, y: 0)
        resetBackground.size.width = 500
        resetBackground.size.height = 350
        resetBackground.zPosition = 10
        addChild(resetBackground)
        resetConfirm = SKSpriteNode(imageNamed: "confirm")
        resetConfirm.name = "resetConfConfirmation"
        resetConfirm.position = CGPoint(x: 125, y: -150)
        resetConfirm.size.width = 250
        resetConfirm.size.height = 99
        resetConfirm.zPosition = 11
        addChild(resetConfirm)
        resetDecline = SKSpriteNode(imageNamed: "decline")
        resetDecline.name = "resetConfDecline"
        resetDecline.position = CGPoint(x: -125, y: -150)
        resetDecline.size.width = 250
        resetDecline.size.height = 100
        resetDecline.zPosition = 11
        addChild(resetDecline)
    
    }
    
    //removes reset confrimation screen
    @objc func removeReset() {
        for child in children {
            if (child.name != nil && child.name!.prefix(9) == "resetConf") {
                child.removeFromParent()
            }
        }
    }
    
}

