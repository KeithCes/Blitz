//
//  GameEnd.swift
//  Arc
//
//  Created by Keith C on 12/27/18.
//  Copyright © 2018 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class GameEnd: SKScene {
    
    var endScreen = SKSpriteNode()
    var endScore = SKLabelNode()
    
    //sets menu to menu
    override func didMove(to view: SKView) {
        
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
        
        endScreen = self.childNode(withName: "endScreen") as! SKSpriteNode
        
        endScore.removeAllChildren()
        endScore.text = String(GameScene.score)
        endScore.fontName = "AvenirNext-Bold"
        endScore.fontColor = Colors.blitzCyan
        endScore.position = CGPoint(x: 0, y: -420)
        endScore.fontSize = 250
        endScore.zPosition = 4
        addChild(endScore)
        
        if Int((UserDefaults.standard.object(forKey: "hiscore") as? String)!)! < GameScene.score {
            UserDefaults.standard.set(String(GameScene.score), forKey: "hiscore")
        }
        
    }
    
    //any touch on the game menu starts the game/switches scene to GameScene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //vibrate
        AudioServicesPlaySystemSound(1519)
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "endScreen" {
                let gameScene = SKScene(fileNamed: "GameMenu")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
        }
    }
    
}
