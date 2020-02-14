//
//  GameMenu.swift
//  Arc
//
//  Created by Keith C on 12/27/18.
//  Copyright © 2018 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class GameMenu: SKScene {
    
    
    //sets vars
    override func didMove(to view: SKView) {
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
    }
    
    //any touch on the game menu starts the game/switches scene to GameScene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "endlessButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
            else if atPoint(touchLocation).name == "levelButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "LevelSelect")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
            else if atPoint(touchLocation).name == "statsButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "Stats")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
            else if atPoint(touchLocation).name == "settingsButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "Settings")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
            else if atPoint(touchLocation).name == "infoButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "Info")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
        }
    }
}
