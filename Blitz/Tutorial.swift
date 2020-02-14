//
//  Tutorial.swift
//  Blitz
//
//  Created by Keith C on 4/17/19.
//  Copyright © 2019 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AudioToolbox
import UIKit

class Tutorial: SKScene, SKPhysicsContactDelegate {
    
    ////////////////////////////////////--- VARS ---/////////////////////////////////////////////////////////////////////
    
    //bool to check if game is still going on
    var isGameOver = false
    
    var pause = true
    
    //player
    var player = SKSpriteNode()
    
    var playerSpeedMax = CGFloat(20.0)
    var playerSpeedCur = CGFloat(0)
    var playerDrag = CGFloat(0.5)
    var angle = CGFloat(0.0)
    var vx = CGFloat(0.0)
    var vy = CGFloat(0.0)
    //creates the player particle as an emitter
    var playerPart = SKEmitterNode(fileNamed: "playerPart")
    
    //ENEMY
    var enemySpeed = CGFloat(5)
    //enemy levels
    //set 1
    var level1 = [100,800, 0,1400, -200,1100, 300,1700, 0,2000]
    
    
    //GOAL
    var goalSpeed = CGFloat(5)
    //goal levels
    var goalLevels = [0,800]
    //creates the goal particle as an emitter
    var goalPart = SKEmitterNode(fileNamed: "goalPart")
    
    
    //all level completions 20
    var levelCompletion = [false]
    
    
    var framecount = 0
    
    
    //used to keep track of the current level for replay function
    static var currentLvl = "0"
    
    var msg = ["WELCOME TO BLITZ",
               "TAP SCREEN\nTO MOVE",
               "AVOID ENEMIES",
               "COLLIDE WITH\nWHITE GOAL TO\nCOMPLETE TUTORIAL"]
    var msgNum = 0
    
    var firstMove = false
    var tutorialChecks = [false, false]
    var goalTextDisplayed = false
    
    /////////////////////////////////--- CREATE ---////////////////////////////////////////////////////////////////////////////
    
    //main
    override func didMove(to view: SKView) {
        
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
        
        //makes scene physical
        physicsWorld.contactDelegate = self
        
        //calls initializePlayer; sets player physics and player node as well as adds player particles
        initializePlayer()
        
        
        
        playerPart!.position = CGPoint(x: player.position.x, y: player.position.y)
        goalUpdate()
        
        
        drawMessage()
    }
    
    //player
    func initializePlayer() {
        
        //creates the playerParticle
        playerPart!.zPosition = CGFloat(2)
        addChild(playerPart!)
        
        //makes the sprite update/draw correctly
        player = self.childNode(withName: "player") as! SKSpriteNode
        
        //player physics
        player.physicsBody?.categoryBitMask = 0
        player.physicsBody?.contactTestBitMask = UInt32(1)
        player.physicsBody?.collisionBitMask = 0
    }
    
    @objc func createEnemy() {
        
        //assigns the coords of each level to a mass array
        var enemyCoords = [level1]
        
        //turns int lst into CGPoint lst
        var newEnemyCoords: [CGPoint] = []
        newEnemyCoords = createEnemies(arr: enemyCoords[0])
        
        var num = 1
        for en in newEnemyCoords {
            let enemyProto : SKSpriteNode!
            if num <= 5 {
                enemyProto = SKSpriteNode(imageNamed: "enemy")
            }
            else {
                enemyProto = SKSpriteNode(imageNamed: "wall")
            }
            enemyProto.name = "enemy" + String(num)
            
            //enemy x; keeps enemies from spawning in wall
            enemyProto.position.x = en.x
            
            //enemy y
            enemyProto.position.y = en.y
            
            //gives enemies physics
            enemyProto.physicsBody = SKPhysicsBody(circleOfRadius : enemyProto.size.height/2)
            enemyProto.physicsBody?.categoryBitMask = UInt32(1)
            enemyProto.physicsBody?.collisionBitMask = 0
            
            //add glow
            enemyProto.addGlow()
            
            //adds the child
            addChild(enemyProto)
            
            num += 1
        }
    }
    
    @objc func createGoal() {
        
        //creates the playerParticle
        goalPart!.zPosition = CGFloat(2)
        addChild(goalPart!)
        
        let newGoalCoords = CGPoint(x: goalLevels[0], y: goalLevels[1])
        
        let goalProto : SKSpriteNode!
        goalProto = SKSpriteNode(imageNamed: "goal")
        goalProto.name = "goal"
        goalProto.position.x = newGoalCoords.x
        goalProto.position.y = newGoalCoords.y
        goalProto.physicsBody = SKPhysicsBody(circleOfRadius : goalProto.size.height/2)
        goalProto.physicsBody?.categoryBitMask = UInt32(1)
        goalProto.physicsBody?.collisionBitMask = 0
        
        //add glow
        goalProto.addGlow()
        
        //adds the child
        addChild(goalProto)
        
    }
    
    
    
    /////////////////////////////////--- COLLISION ---///////////////////////////////////////////////////////////////////////////
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //handles collisions between player/enemy
        if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name?.prefix(5) == "enemy" {
            //vibrate
            AudioServicesPlaySystemSound(1520)
            AudioServicesPlaySystemSound(1520)
            AudioServicesPlaySystemSound(1520)
            isGameOver = true;
            //stop player particles on death
            playerPart!.removeFromParent()
            afterCollisionFalse()
            
        }
        
        //handles collisions between player/goal
        if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "goal" {
            //vibrate
            AudioServicesPlaySystemSound(1520)
            AudioServicesPlaySystemSound(1520)
            AudioServicesPlaySystemSound(1520)
            isGameOver = true;
            //stop player particles on death
            playerPart!.removeFromParent()
            afterCollisionTrue()
            UserDefaults.standard.set(true, forKey: "tutorial")
        }
    }
    
    /////////////////////////////////--- UPDATE ---////////////////////////////////////////////////////////////////////////////
    
    //main
    override func update(_ currentTime: TimeInterval) {
        
        if !isGameOver && !pause {
            
            //increments frames every tick
            framecount += 1
            
            //sets playerParticle position to player position
            playerPart!.position = CGPoint(x: player.position.x, y: player.position.y)
            
            //determines velocity of player based on trig of angle and playerSpeed
            vx = cos(angle) * playerSpeedCur
            vy = sin(angle) * playerSpeedCur
            player.zRotation = angle
            player.position.x += vx
            player.position.y += vy
            
            //slows player down; friction; subtracts the players drag from their speed
            if playerSpeedCur - playerDrag >= 0 {
                playerSpeedCur -= playerDrag
            }
            
            //calls a function that checks to make sure player is within phone border
            checkInBounds()
            
            //calls enemy update; enumerates enemy children and creates enemy if timer calls for it
            enemyUpdate()
            
            goalUpdate()
            
            //removes items past bottom of screen
            removeItems()
            
            messageTimer()
            
            //checks if player is moving
            if firstMove == false && tutorialChecks[0] == false && playerSpeedCur == playerDrag {
                firstMove = true
                tutorialChecks[0] = true
            }
            
        }
    }
    
    //all enemy update stuff parsed out
    func enemyUpdate() {
        //makes new enemy children
        enumerateChildNodes(withName: "*enemy*", using:{(enemy, stop)in
            let enemy = enemy as! SKSpriteNode
            if Int(enemy.name!.suffix(1))! <= 5 {
                enemy.position.y -= self.enemySpeed
            }
            
        })
    }
    
    
    func goalUpdate() {
        //makes new enemy children
        enumerateChildNodes(withName: "goal", using:{(goal, stop)in
            let goal = goal as! SKSpriteNode
            goal.position.y -= self.goalSpeed
            self.goalPart!.position = CGPoint(x: goal.position.x, y: goal.position.y)
        })
    }
    
    
    
    /////////////////////////////////--- TOUCH ---////////////////////////////////////////////////////////////////////////////
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if pause == true {
            pause = false
            for child in children {
                if child.name?.prefix(7) == "message"  {
                    let fadeOut = SKAction.fadeOut(withDuration: 0.3)
                    child.run(fadeOut)
                }
            }
        }
        else if pause == false {
            //vibrate
            AudioServicesPlaySystemSound(1520)
            
            //sets player speed cur to max
            playerSpeedCur = playerSpeedMax
            
            //takes first touch
            let touch = touches.first
            
            //pulls position out of touch
            let position = touch!.location(in:self)
            
            //determines distance between touch and player and then angle using trig
            let dx = position.x - player.position.x
            let dy = position.y - player.position.y
            angle = atan2(dy, dx)
        }
    }
    
    
    
    
    
    /////////////////////////////////--- BOUNDS ---////////////////////////////////////////////////////////////////////////////
    
    //checks player
    func checkInBounds() {
        
        //right
        if player.position.x > self.frame.size.width / 2 - player.size.width / 2 {
            player.position.x = self.frame.size.width / 2 - player.size.width / 2
        }
        //left
        if player.position.x < -self.frame.size.width / 2 + player.size.width / 2 {
            player.position.x = -self.frame.size.width / 2 + player.size.width / 2
        }
        //top
        if player.position.y > self.frame.size.height / 2 - player.size.height / 2 {
            player.position.y = self.frame.size.height / 2 - player.size.height / 2
        }
        //bot
        if player.position.y < -self.frame.size.height / 2 + player.size.height / 2 {
            player.position.y = -self.frame.size.height / 2 + player.size.height / 2
        }
    }
    
    //removes all items that move over the bottom of the screen
    @objc func removeItems() {
        for child in children {
            if child.position.y < -self.size.height / 2 - 50 || child.position.x > self.size.width / 2 + 50 {
                //checks if goal passes end of screen and ends game if so
                if child.name == "goal" {
                    isGameOver = true;
                    afterCollisionFalse()
                }
                if child.name == "enemy5" {
                    tutorialChecks[1] = true
                }
                child.removeFromParent()
            }
        }
    }
    
    //after collision enemy
    func afterCollisionFalse() {
        let menuScene = SKScene(fileNamed: "Tutorial")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
        Levels.currentLvl = self.name!
    }
    
    //after collision goal
    func afterCollisionTrue() {
        let menuScene = SKScene(fileNamed: "GameMenu")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: TimeInterval(2)))
    }
    
    //makes a list of CGPoints out of ints (for creating a list off enemy coords with reduntantly casting CGPoints
    func createEnemies(arr: [Int]) -> [CGPoint] {
        var i = 0
        var newArr: [CGPoint] = []
        while i < arr.count {
            newArr.append(CGPoint(x: arr[i], y: arr[i+1]))
            i += 2
        }
        return newArr
    }
    
    
    
    
    
    func drawMessage() {
        let msgX = 0
        let msgY = 0
        let message = SKLabelNode()
        message.text = msg[msgNum]
        message.numberOfLines = 3
        message.name = "message" + String(msgNum)
        message.fontName = "AvenirNext-Bold"
        message.fontColor = SKColor.white
        message.position = CGPoint(x: msgX, y: msgY)
        message.fontSize = 70
        message.zPosition = 4
        message.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        message.run(fadeIn)
        addChild(message)
        msgNum += 1
    }
    
    func messageTimer() {
        if framecount == 20 {
            pause = true
            drawMessage()
        }
        else if tutorialChecks[0] == true && firstMove == true {
            pause = true
            drawMessage()
            firstMove = false
            createEnemy()
        }
        else if tutorialChecks[1] && goalTextDisplayed == false {
            pause = true
            createGoal()
            goalUpdate()
            drawMessage()
            goalTextDisplayed = true
        }
    }
}
