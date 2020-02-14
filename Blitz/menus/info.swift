//
//  Info.swift
//  Blitz
//
//  Created by Keith C on 6/9/19.
//  Copyright © 2019 Keith C. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class Info : SKScene {
    
    //sets vars
    override func didMove(to view: SKView) {
        //scales scene size to screen size
        scene!.scaleMode = .aspectFit
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
        }
    }
}
