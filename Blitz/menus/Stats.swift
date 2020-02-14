//
//  Stats.swift
//  Blitz
//
//  Created by Keith C on 4/10/19.
//  Copyright © 2019 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class Stats: SKScene {
    
    var pageNum = 0
    let levelsPer = 10
    
    var hiscore : String = ""
    let font = "AvenirNext-Bold"
    
    
    override func didMove(to view: SKView) {
        
        //stes hiscore if not nil
        if UserDefaults.standard.object(forKey: "hiscore") as? String != nil {
            hiscore = UserDefaults.standard.object(forKey: "hiscore") as! String
        }
        else {
            hiscore = "0"
        }
        
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
        
        //draws attempts and successes for each level
        drawPlayedSuccess()
        
        //draws data from endless mode
        drawEndlessModeData()
    }
    
    
    //main draw functions
    func drawNewLabel(text: String, name: String, fontname: String, fontcolor: SKColor, pos: CGPoint, fontsize: Int, zpos: Int) {
        let newItem = SKLabelNode()
        newItem.text = text
        newItem.name = name
        newItem.fontName = fontname
        newItem.fontColor = fontcolor
        newItem.position = pos
        newItem.fontSize = CGFloat(fontsize)
        newItem.zPosition = CGFloat(zpos)
        addChild(newItem)
    }
    func drawNewBackground(numX: Int, yStart: Int, yInc: Int, fillcolor: SKColor, alpha: CGFloat, strokecolor: SKColor, zpos: Int) {
        let newItem = SKShapeNode(rect:CGRect(x: numX - 50,y: yStart - yInc - 18,width:100,height:60), cornerRadius: 25)
        newItem.zPosition = CGFloat(zpos)
        newItem.fillColor = fillcolor.withAlphaComponent(alpha)
        newItem.strokeColor = strokecolor
        newItem.name = "titleLevelBackground"
        addChild(newItem)
    }
    
    //draws all endless mode data
    func drawEndlessModeData() {
        let titleX = 180
        let titleY = 575
        let hiscoreX = 180
        let hiscoreY = 320
        
        drawNewLabel(text: "ENDLESS", name: "endlessTitle", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: titleX, y: titleY), fontsize: 60, zpos: 4)
        drawNewLabel(text: "HISCORE", name: "scoreText", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: hiscoreX, y: hiscoreY + 125), fontsize: 50, zpos: 4)
        drawNewLabel(text: String(hiscore), name: "hiscoreTitle", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: hiscoreX, y: hiscoreY), fontsize: 140, zpos: 4)
        let hiscoreBackground = SKShapeNode(rect:CGRect(x: hiscoreX - 150, y: hiscoreY - 20, width:300,height:200), cornerRadius: 25)
        hiscoreBackground.zPosition = 4
        hiscoreBackground.fillColor = Colors.blitzLightGray
        hiscoreBackground.strokeColor = SKColor.black
        hiscoreBackground.name = "hiscoreBackground"
        addChild(hiscoreBackground)
        
    }
    
    
    //draws all played/success data
    func drawPlayedSuccess() {
        var yStart = 475
        let numX = -300
        let playedShapeX = -180
        let successShapeX = -60
        let playedTextX = -180
        let successTextX = -60
        let yInc = 75
        
        //levels title label
        drawNewLabel(text: "LEVELS", name: "title", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: -180, y: yStart + 100), fontsize: 60, zpos: 4)
        //background for lvl trys wins
        drawNewBackground(numX: numX, yStart: yStart, yInc: (-yInc/4), fillcolor: Colors.blitzLightGray, alpha: 1, strokecolor: SKColor.black, zpos: 4)
        drawNewBackground(numX: playedShapeX, yStart: yStart, yInc: (-yInc/4), fillcolor: Colors.blitzYellow, alpha: 0.8, strokecolor: SKColor.black, zpos: 4)
        drawNewBackground(numX: successShapeX, yStart: yStart, yInc: (-yInc/4), fillcolor: Colors.blitzCyan, alpha: 1, strokecolor: SKColor.black, zpos: 4)
        //labels fro lvl trys wins
        drawNewLabel(text: "LVL", name: "titleLevel", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: numX, y: yStart + (yInc/4) - 5), fontsize: 50, zpos: 4)
        drawNewLabel(text: "TRYS", name: "titlePlayed", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: playedTextX, y: yStart + (yInc/4)), fontsize: 35, zpos: 4)
        drawNewLabel(text: "WINS", name: "titleSuccess", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: successTextX, y: yStart + (yInc/4)), fontsize: 35, zpos: 4)
        //labels for timeplayed
        drawNewLabel(text: "TIME IN LEVELS: ", name: "timePlayed", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: CGFloat(-180), y: CGFloat(-545)), fontsize: 35, zpos: 4)
        var timePlayedString = "0s"
        if UserDefaults.standard.object(forKey: "lvlTime") != nil {
            let minutes = Int((floor((UserDefaults.standard.object(forKey: "lvlTime") as! Double)/60) * 100.0) / 100.0)
            let seconds = Int((floor((UserDefaults.standard.object(forKey: "lvlTime") as! Double) - Double(minutes * 60)) * 100.0) / 100.0)
            timePlayedString = String(minutes) + "m " + String(seconds) + "s"
            //timePlayedString = String(round(UserDefaults.standard.object(forKey: "lvlTime") as! Double * 100.0) / 100.0) + "s"
        }
        drawNewLabel(text: timePlayedString, name: "timePlayed", fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: CGFloat(-180), y: CGFloat(-600)), fontsize: 50, zpos: 4)
        
        
        //@@@@@@@@@@ CHANGE FROM HARDCODED LEVELS
        //LevelSelect.levels-1
        for i in 1 + (pageNum * levelsPer)...10 + (pageNum * levelsPer) {
            
            //draws lvl trys wins backgrounds
            drawNewBackground(numX: numX, yStart: yStart, yInc: yInc, fillcolor: Colors.blitzLightGray, alpha: 1, strokecolor: SKColor.black, zpos: 4)
            drawNewBackground(numX: playedShapeX, yStart: yStart, yInc: yInc, fillcolor: Colors.blitzYellow, alpha: 0.8, strokecolor: SKColor.black, zpos: 4)
            drawNewBackground(numX: successShapeX, yStart: yStart, yInc: yInc, fillcolor: Colors.blitzCyan, alpha: 1, strokecolor: SKColor.black, zpos: 4)
            //
            drawNewLabel(text: String(i), name: "numText" + String(i), fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: numX, y: yStart - yInc - 5), fontsize: 50, zpos: 4)
            var playedLabelText = "0"
            if UserDefaults.standard.object(forKey: "played" + String(i)) == nil {
                playedLabelText = "0"
            }
            else {
                playedLabelText = String(UserDefaults.standard.object(forKey: "played" + String(i)) as! Int)
            }
            drawNewLabel(text: playedLabelText, name: "playedText" + String(i), fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: playedTextX, y: yStart - yInc), fontsize: 35, zpos: 4)
            var successLabelText = "0"
            if UserDefaults.standard.object(forKey: "success" + String(i)) == nil {
                successLabelText = "0"
            }
            else {
                successLabelText = String(UserDefaults.standard.object(forKey: "success" + String(i)) as! Int)
            }
            drawNewLabel(text: successLabelText, name: "successText" + String(i), fontname: font, fontcolor: SKColor.white, pos: CGPoint(x: successTextX, y: yStart - yInc), fontsize: 35, zpos: 4)
            yStart -= yInc
        }
        
    }
    
  
    //any touch on the game menu starts the game/switches scene to GameScene
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
            else if atPoint(touchLocation).name == "rightButton" {
                //goes to next page of level stats
                //removes
                if (pageNum + 1) * levelsPer < LevelSelect.levels {
                    //vibrate
                    AudioServicesPlaySystemSound(1519)
                    for child in children {
                        if child.name?.prefix(3) == "num" || child.name?.prefix(6) == "played" || child.name?.prefix(7) == "success" || child.name?.prefix(5) == "title" {
                            child.removeFromParent()
                        }
                    }
                    pageNum += 1
                    drawPlayedSuccess()
                }
            }
            else if atPoint(touchLocation).name == "leftButton" {
                //"" prev page
                if pageNum * levelsPer > 0 {
                    //vibrate
                    AudioServicesPlaySystemSound(1519)
                    for child in children {
                        if child.name?.prefix(3) == "num" || child.name?.prefix(6) == "played" || child.name?.prefix(7) == "success" || child.name?.prefix(5) == "title" {
                            child.removeFromParent()
                        }
                    }
                    pageNum -= 1
                    drawPlayedSuccess()
                }
            }
            else if atPoint(touchLocation).name == "tutButton" {
                //vibrate
                AudioServicesPlaySystemSound(1519)
                let gameScene = SKScene(fileNamed: "Tutorial")
                gameScene!.scaleMode = .aspectFill
                view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: TimeInterval(0.3)))
            }
        }
    }
    
}

