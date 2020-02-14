//
//  GameOverLvl.swift
//  Arc
//
//  Created by Keith C on 1/15/19.
//  Copyright © 2019 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class GameEndLvl: SKScene {
    
    override func didMove(to view: SKView) {
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
    }
    //any touch on the game menu starts the game/switches scene to GameScene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "lvlSelectButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "LevelSelect")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
            else if atPoint(touchLocation).name == "mainMenuButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519);
                let gameScene = SKScene(fileNamed: "GameMenu")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
            else if atPoint(touchLocation).name == "replayButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519);
                let gameScene = SKScene(fileNamed: Levels.currentLvl)!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
        }
    }
    
}
