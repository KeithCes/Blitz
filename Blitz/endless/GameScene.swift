//
//  GameScene.swift
//  Arc
//
//  Created by Keith C on 12/22/18.
//  Copyright © 2018 Keith C. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
////////////////////////////////////--- VARS ---/////////////////////////////////////////////////////////////////////
    
    //bool to check if game is still going on
    var isGameOver = false
    
    //player
    var player = SKSpriteNode()
    
    var playerSpeedMax = CGFloat(20.0)
    var playerSpeedCur = CGFloat(0)
    var playerDrag = CGFloat(0.5)
    var angle = CGFloat(0.0)
    var vx = CGFloat(0.0)
    var vy = CGFloat(0.0)
    var playerRad = CGFloat()
    //creates the player particle as an emitter
    var playerPart = SKEmitterNode(fileNamed: "playerPart")
    
    //enemy
    var enemySpeed = CGFloat(0.0)
    var enemySpeeds = [CGFloat(7.5), CGFloat(8.5), CGFloat(9.5), CGFloat(10.5), CGFloat(11.5)]
    //enemy speed kicker
    var enemySpeedKicker = CGFloat(10)
    //enemy spawn timer
    var enemyTimerMax = CGFloat(15)
    var enemyTimerCur = CGFloat(15)
    //lower enemyTimerLogKicker more spawns
    var enemyTimerLogKicker = 30
    
    var framecount = 0

 
    //score
    static var score = 0
    var scoreText = SKLabelNode()
    
    var hiscoreText = SKLabelNode()
    
/////////////////////////////////--- CREATE ---////////////////////////////////////////////////////////////////////////////
    
    //main
    override func didMove(to view: SKView) {
        
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
        
        //makes scene physical
        physicsWorld.contactDelegate = self
        
        //calls initializePlayer; sets player physics and player node as well as adds player particles
        initializePlayer()
        
        //calls initializeScore; sets and draws score and score board
        initializeScore()
        
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
    
    //score
    func initializeScore() {
        
        //sets hiscore to 0 if no previous hiscore
        if UserDefaults.standard.object(forKey: "hiscore") as? String == nil {
            UserDefaults.standard.set("0", forKey: "hiscore")
        }
        
        GameScene.score = 0
        
        //initializes score text
        scoreText.text = "0"
        scoreText.removeAllChildren()
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: 0, y: self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        addChild(scoreText)
        
        //draws the score background
        let scoreBackGround = SKShapeNode(rect:CGRect(x: -90 ,y: self.size.height / 2 - 130 ,width:180,height:80), cornerRadius: 25)
        scoreBackGround.zPosition = 4
        scoreBackGround.fillColor = Colors.blitzCyan
        scoreBackGround.strokeColor = SKColor.black
        addChild(scoreBackGround)
        
        
        //initializes score text
        hiscoreText.text = (UserDefaults.standard.object(forKey: "hiscore") as? String)!
        hiscoreText.removeAllChildren()
        hiscoreText.name = "hiscore"
        hiscoreText.fontName = "AvenirNext-Bold"
        hiscoreText.fontColor = SKColor.white
        hiscoreText.position = CGPoint(x: -self.size.width/2 + 80, y: self.size.height / 2 - 95)
        hiscoreText.fontSize = 35
        hiscoreText.zPosition = 4
        addChild(hiscoreText)
        
        //draws the score background
        let hiscoreBackGround = SKShapeNode(rect:CGRect(x: -self.size.width/2 + 30 ,y: self.size.height / 2 - 110 ,width:100,height:60), cornerRadius: 25)
        hiscoreBackGround.zPosition = 4
        hiscoreBackGround.fillColor = Colors.blitzYellow.withAlphaComponent(0.8)
        hiscoreBackGround.strokeColor = SKColor.black
        addChild(hiscoreBackGround)
    }

/////////////////////////////////--- COLLISION ---///////////////////////////////////////////////////////////////////////////
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //handles collisions between player/enemy
        if contact.bodyA.node?.name == "player" && (contact.bodyB.node?.name?.prefix(5) == "enemy" || contact.bodyB.node?.name == "wall") {
            //vibrate
            AudioServicesPlaySystemSound(1520)
            AudioServicesPlaySystemSound(1520)
            AudioServicesPlaySystemSound(1520)
            isGameOver = true;
            //stop player particles on death
            playerPart!.removeFromParent()
            afterCollision()
            
        }
    }
    
/////////////////////////////////--- UPDATE ---////////////////////////////////////////////////////////////////////////////
    
    //main
    override func update(_ currentTime: TimeInterval) {
        
        if !isGameOver {
            
            //increments frames every tick
            framecount += 1
            
            //sets rate for enemy spawning
            enemyTimerMax = CGFloat(enemyTimerLogKicker) - log2(CGFloat(framecount) / 3)
            
            //sets rate for enemy speed
            //enemySpeed = CGFloat(enemySpeedKicker) + log2(CGFloat(framecount) / 10)
            updateEnemySpeed()
            
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
            
            /* WALLS
            //calls wall update; enumerates enemy children and creates wall if timer calls for it
            wallUpdate()
            */
            //calls checks on out of bounds enemies and increases score accordingly
            checkEnemyBounds()
            
            //removes items past bottom of screen
            removeItems()
        }
    }
    
    //all enemy update stuff parsed out
    func enemyUpdate() {
        //makes new enemy children
        enumerateChildNodes(withName: "enemy", using:{(enemy, stop)in
            let enemy = enemy as! SKSpriteNode
            enemy.position.y -= self.enemySpeed
            
        })
        //makes new horizontal enemy children
        enumerateChildNodes(withName: "enemyHori", using:{(enemy, stop)in
            let enemy = enemy as! SKSpriteNode
            enemy.position.x += self.enemySpeed
            
        })
        //makes new reverse vertical enemy children
        enumerateChildNodes(withName: "enemyReverse", using:{(enemy, stop)in
            let enemy = enemy as! SKSpriteNode
            enemy.position.y += self.enemySpeed
            
        })
        
        //only spawns enemy if timer goes off
        if enemyTimerCur <= 0 {
            createEnemy()
            enemyTimerCur = enemyTimerMax
        }
        else {
            enemyTimerCur -= 1
        }
    }
    
    //creates a new enemy every (enemyTimerMax) seconds
    @objc func createEnemy() {
        let enemyProto : SKSpriteNode!
        let kicker = arc4random_uniform(14)
        //normal vertical enemy
        if kicker >= 0 && kicker < 9 {
            enemyProto = SKSpriteNode(imageNamed: "enemy")
            enemyProto.name = "enemy"
            //enemy x; keeps enemies from spawning in wall
            enemyProto.position.x = CGFloat(arc4random_uniform(UInt32(self.frame.size.width - enemyProto.size.width))) - self.frame.size.width / 2 + enemyProto.size.width / 2
            //enemy y
            enemyProto.position.y = CGFloat(self.frame.size.height / 2 + enemyProto.size.height / 2)
            //gives enemies physics
            enemyProto.physicsBody = SKPhysicsBody(circleOfRadius : enemyProto.size.height/2)
            enemyProto.physicsBody?.categoryBitMask = UInt32(1)
            enemyProto.physicsBody?.collisionBitMask = 0
            
            //add glow
            enemyProto.addGlow()
            
            //adds the child
            addChild(enemyProto)
        }
        //normal horizontal enemy
        else if kicker >= 9 && kicker < 11 && GameScene.score > 10 {
            enemyProto = SKSpriteNode(imageNamed: "enemyHori")
            enemyProto.name = "enemyHori"
            enemyProto.position.x = CGFloat(-self.frame.size.width / 2 - enemyProto.size.width / 2)
            enemyProto.position.y = CGFloat(arc4random_uniform(UInt32(self.frame.size.height - enemyProto.size.width))) - self.frame.size.height / 2 + enemyProto.size.height / 2
            enemyProto.physicsBody = SKPhysicsBody(circleOfRadius : enemyProto.size.height/2)
            enemyProto.physicsBody?.categoryBitMask = UInt32(1)
            enemyProto.physicsBody?.collisionBitMask = 0
            enemyProto.addGlow()
            addChild(enemyProto)
        }
        //reverse vertical enemy
        else if kicker >= 11 && kicker < 12 && GameScene.score > 50 {
            enemyProto = SKSpriteNode(imageNamed: "enemyReverse")
            enemyProto.name = "enemyReverse"
            enemyProto.position.x = CGFloat(arc4random_uniform(UInt32(self.frame.size.width - enemyProto.size.width))) - self.frame.size.width / 2 + enemyProto.size.width / 2
            enemyProto.position.y = CGFloat(-self.frame.size.height / 2 - enemyProto.size.height / 2)
            enemyProto.physicsBody = SKPhysicsBody(circleOfRadius : enemyProto.size.height/2)
            enemyProto.physicsBody?.categoryBitMask = UInt32(1)
            enemyProto.physicsBody?.collisionBitMask = 0
            enemyProto.addGlow()
            addChild(enemyProto)
        }
        //normal border vertical enemy
        else if kicker >= 12 && kicker < 13 {
            enemyProto = SKSpriteNode(imageNamed: "enemy")
            enemyProto.name = "enemy"
            //picks int between 0 and 1; 0 = left border, 1 = right border
            let borderSpawnSide = arc4random_uniform(UInt32(2))
            if borderSpawnSide == 0 {
                enemyProto.position.x = CGFloat(-self.frame.size.width/2 + enemyProto.size.width/2)
            }
            else if borderSpawnSide == 1 {
                enemyProto.position.x = CGFloat(self.frame.size.width/2 - enemyProto.size.width/2)
            }
            enemyProto.position.y = CGFloat(self.frame.size.height / 2 + enemyProto.size.height / 2)
            enemyProto.physicsBody = SKPhysicsBody(circleOfRadius : enemyProto.size.height/2)
            enemyProto.physicsBody?.categoryBitMask = UInt32(1)
            enemyProto.physicsBody?.collisionBitMask = 0
            enemyProto.addGlow()
            addChild(enemyProto)
        }
    }
    
    //changes enemy speed based on score
    func updateEnemySpeed() {
        if GameScene.score <= 0 {
            enemySpeed = enemySpeeds[0]
        }
        else if GameScene.score > 25 {
            enemySpeed = enemySpeeds[1]
        }
        else if GameScene.score > 50 {
            enemySpeed = enemySpeeds[2]
        }
        else if GameScene.score > 75 {
            enemySpeed = enemySpeeds[3]
        }
        else if GameScene.score > 100 {
            enemySpeed = enemySpeeds[4]
        }
    }

/////////////////////////////////--- TOUCH ---////////////////////////////////////////////////////////////////////////////
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
            if (child.position.y < -self.size.height / 2 - 50 && child.name != "enemyReverse") || child.position.x > self.size.width / 2 + 50 || (child.position.y > self.size.height / 2 + 50 && child.name != "enemy") {
                child.removeFromParent()
            }
        }
    }
    
    //checks to see if enemy is out of bounds and adds to score if so
    func checkEnemyBounds() {
        for child in children {
            if child.position.y < -self.size.height / 2 - 50 && (child.name == "enemy" || child.name == "wall") {
                GameScene.score += 1;
                scoreText.text = String(GameScene.score)
            }
            else if child.position.x > self.size.width / 2 + 50 && child.name == "enemyHori" {
                GameScene.score += 1;
                scoreText.text = String(GameScene.score)
            }
            else if child.position.y > self.size.height / 2 + 50 && child.name == "enemyReverse" {
                GameScene.score += 1;
                scoreText.text = String(GameScene.score)
                print("chode")
            }
        }
    }

    //after collision
    func afterCollision() {
        //GameViewController().saveHighscore(number: GameScene.score)
        let menuScene = SKScene(fileNamed: "GameEnd")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
    }
    
/////////////////////////////////--- MISC ---////////////////////////////////////////////////////////////////////////////

    
}
