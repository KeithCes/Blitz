//
//  GameEndLvlWin.swift
//  Arc
//
//  Created by Keith C on 1/27/19.
//  Copyright © 2019 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class GameEndLvlWin: SKScene {
    
    //creates the goal particle as an emitter
    var goalPart = SKEmitterNode(fileNamed: "goalPart")
    
    override func didMove(to view: SKView) {
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
        
        createGoal()
    }
    
    //creates a goal obj
    @objc func createGoal() {
        
        let goalProto : SKSpriteNode!
        goalProto = SKSpriteNode(imageNamed: "goal")
        goalProto.name = "goal"
        goalProto.position.x = 0
        goalProto.position.y = 160
        goalProto.physicsBody = SKPhysicsBody(circleOfRadius : goalProto.size.height/2)
        goalProto.physicsBody?.categoryBitMask = UInt32(1)
        goalProto.physicsBody?.collisionBitMask = 0
        goalProto.zPosition = CGFloat(10)
        
        //add glow
        goalProto.addGlow()
        
        
        goalPart!.zPosition = CGFloat(0)
        goalPart!.position = goalProto.position
        addChild(goalPart!)
        
        //adds the child
        addChild(goalProto)
        
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
        }
    }
    
}
