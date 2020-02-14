//
//  SKSpriteNode+AddGlow.swift
//  Arc
//
//  Created by Keith C on 12/30/18.
//  Copyright © 2018 Keith C. All rights reserved.
//

import Foundation
import SpriteKit

//thanks to some guy on stackoverflow for this one
extension SKSpriteNode {
    
    //adds a glow effect to SKSpriteNode
    func addGlow(radius: Float = 60) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
}
