//
//  GameScene.swift
//  Project11
//
//  Created by Angel Vázquez on 3/17/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
            box.position = location
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            addChild(box)
        }
    }
}
