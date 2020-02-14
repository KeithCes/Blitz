//
//  LevelSelect.swift
//  Arc
//
//  Created by Keith C on 1/2/19.
//  Copyright © 2019 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class LevelSelect: SKScene, SKPhysicsContactDelegate {
    
    static let levels = 100
    static var levelsLeftover = 0
    static var levelsCurrent = 20
    static var levelsMax = 20
    
    let titles = ["Basic Vertical", "Basic Horizontal", "Static", "No Friction", "Reverse Vertical", "untitled"]
    var title = SKLabelNode()
    
    static var pageNum = 0
    
    
/////////////////////////////////--- CREATE ---////////////////////////////////////////////////////////////////////////////
    
    //sets vars
    override func didMove(to view: SKView) {
        
        //builds levels list if it doesnt exist
        //FIXED BUG, should work as intended
        if UserDefaults.standard.object(forKey: "levels") == nil || (UserDefaults.standard.object(forKey: "levels") as! [Bool]).count < LevelSelect.levels {
            var cnt = 0
            if UserDefaults.standard.object(forKey: "levels") != nil {
                cnt = (UserDefaults.standard.object(forKey: "levels") as! [Bool]).count
            }
            let arrLoops = LevelSelect.levels - cnt
            var arr = [Bool]()
            for _ in 0...arrLoops-1 {
                arr.append(false)
            }
            var newArr = [Bool]()
            if UserDefaults.standard.object(forKey: "levels") != nil {
                newArr = UserDefaults.standard.object(forKey: "levels") as! [Bool] + arr
            }
            UserDefaults.standard.set(newArr, forKey: "levels")
        }
        
        //sets levels current back the max amount (ex: current end at 21-40 is 40, we want it to be 20 so we
        //subtract the max amount (40-20) ez
        LevelSelect.levelsCurrent -= LevelSelect.levelsMax
        
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
        
        //makes scene physical
        physicsWorld.contactDelegate = self
        
        //draws title
        initializeTitle()
        
        
        
        
        makeLevels(startNum: LevelSelect.levelsCurrent, endNum: LevelSelect.levelsCurrent + LevelSelect.levelsMax)
        
        
        while (UserDefaults.standard.object(forKey: "levels") as? [Bool])!.count < LevelSelect.levels {
            var newArr = UserDefaults.standard.object(forKey: "levels") as! [Bool]
            newArr.append(false)
            UserDefaults.standard.set(newArr, forKey: "levels")
        }
        
        
    }
    
    //title
    func initializeTitle() {
        for child in children {
            if child.name == "title" || child.name == "titleBackGround" {
                child.removeFromParent()
            }
        }
        
        GameScene.score = 0
        
        //initializes title text
        title.text = titles[LevelSelect.pageNum]
        title.name = "title"
        title.fontName = "AvenirNext-Bold"
        title.fontColor = SKColor.white
        title.position = CGPoint(x: 0, y: self.size.height/2 - 110)
        title.fontSize = 50
        title.zPosition = 4
        addChild(title)
        
        let titleSize = title.text!.count
        let titleWidth = 30 * titleSize
        let titleX = -(titleWidth/2)
        
        //draws the title background
        let titleBackGround = SKShapeNode(rect:CGRect(x: titleX ,y: Int(self.size.height / 2 - 130) ,width:titleWidth,height:80), cornerRadius: 25)
        titleBackGround.name = "titleBackGround"
        titleBackGround.zPosition = 4
        titleBackGround.fillColor = Colors.blitzCyan
        titleBackGround.strokeColor = SKColor.black
        addChild(titleBackGround)
    }


    
    
    //any touch on the game menu starts the game/switches scene to GameScene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            for i in 0...LevelSelect.levels-1 {
                if atPoint(touchLocation).name == "button" + String(i+1) {
                    //vibrate
                    AudioServicesPlaySystemSound(1519)
                    let gameScene = SKScene(fileNamed: String(i+1))!
                    gameScene.scaleMode = .aspectFill
                    view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
                    
                }
                else if atPoint(touchLocation).name == "label" + String(i+1) {
                    //vibrate
                    AudioServicesPlaySystemSound(1519)
                    let gameScene = SKScene(fileNamed: String(i+1))!
                    gameScene.scaleMode = .aspectFill
                    view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
                    
                }
            }
            if atPoint(touchLocation).name == "backButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "GameMenu")
                gameScene!.scaleMode = .aspectFill
                view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
            else if atPoint(touchLocation).name == "rightButton" {
                //goes to next page of levels
                if LevelSelect.levelsCurrent < LevelSelect.levels {
                    //vibrate
                    AudioServicesPlaySystemSound(1519)
                    for child in children {
                        if child.name?.prefix(6) == "button" || child.name?.prefix(5) == "label" {
                            child.removeFromParent()
                        }
                    }
                    makeLevels(startNum: LevelSelect.levelsCurrent, endNum: LevelSelect.levelsCurrent + LevelSelect.levelsMax)
                    
                    LevelSelect.pageNum += 1
                    initializeTitle()
                }
            }
            else if atPoint(touchLocation).name == "leftButton" {
                //"" prev page of levels
                if LevelSelect.levelsCurrent > LevelSelect.levelsMax {
                    //vibrate
                    AudioServicesPlaySystemSound(1519)
                    for child in children {
                        if child.name?.prefix(6) == "button" || child.name?.prefix(5) == "label" {
                            child.removeFromParent()
                        }
                    }
                    LevelSelect.levelsCurrent -= LevelSelect.levelsMax * 2
                    makeLevels(startNum: LevelSelect.levelsCurrent, endNum: LevelSelect.levelsCurrent + LevelSelect.levelsMax)
                    
                    LevelSelect.pageNum -= 1
                    initializeTitle()
                }
            }
        }
    }
    
    //loops through levels and prints
    func makeLevels(startNum: Int, endNum: Int) {
        
        let buttonHeight = CGFloat(165)
        let buttonWidth = CGFloat(165)
        let rowButtons = 4
        let whiteSpace = CGFloat(5)
        var yVal = CGFloat(500)
        //just an absolute mess of an equation but it centers all the levels
        let xVal = CGFloat(0 - self.size.width + (self.size.width - (CGFloat(whiteSpace * CGFloat(rowButtons)) + (buttonWidth * CGFloat(rowButtons))))) / 2
        let yValStatic = CGFloat(500)
        
        for i in startNum...endNum {
            
            if i < endNum {
                if i % rowButtons == 0 {
                    yVal -= buttonHeight + whiteSpace
                }
                
                //makes buttons for each level
                let buttonX = CGFloat(i % rowButtons) * (buttonWidth + whiteSpace) + xVal
                let buttonY = yVal
                
                let levelButton = SKShapeNode(rect:CGRect(x:buttonX, y: buttonY, width: buttonWidth, height: buttonHeight), cornerRadius: 25)
                levelButton.name = "button" + String(i+1)
                levelButton.zPosition = 4
                
                let levelComplete = UserDefaults.standard.object(forKey: "levels") as? [Bool] ?? [Bool]()
                if levelComplete.isEmpty == true || levelComplete[i] == false {
                    levelButton.fillColor = Colors.blitzGray
                }
                else {
                    levelButton.fillColor = Colors.blitzYellow.withAlphaComponent(0.7)
                }
                levelButton.strokeColor = SKColor.black
                
                //gives enemies physics
                levelButton.physicsBody = SKPhysicsBody(rectangleOf : CGSize(width: buttonWidth, height: buttonHeight))
                levelButton.physicsBody?.categoryBitMask = UInt32(1)
                levelButton.physicsBody?.collisionBitMask = 0
                
                
                //labels all levels with corresponding level labels
                let levelLabels = SKLabelNode()
                levelLabels.text = String(i+1)
                levelLabels.name = "label" + String(i+1)
                levelLabels.fontName = "AvenirNext-Bold"
                levelLabels.fontColor = Colors.blitzCyan
                levelLabels.position = CGPoint(x: buttonX + buttonWidth / 2, y: (buttonY + buttonHeight / 2) - 25)
                levelLabels.fontSize = 75
                levelLabels.zPosition = 4
                
                //adds both buttons and labels
                addChild(levelButton)
                addChild(levelLabels)
                LevelSelect.levelsCurrent += 1
            }
            else {
                //if theres been the max amount of levels produced reset the yVal and calc the leftover
                yVal = yValStatic
                LevelSelect.levelsLeftover = LevelSelect.levels - i
            }
        }
    }
}
