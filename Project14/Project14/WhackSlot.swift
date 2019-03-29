
//
//  WhackSlot.swift
//  Project14
//
//  Created by Angel Vázquez on 3/28/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import SpriteKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        createEmitter(named: "Mud", at: CGPoint(x: 0, y: -60), lifetime: hideTime)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [unowned self] in
            self.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in
            self.isVisible = false
        }
        
        createEmitter(named: "Smoke", at: charNode.position)
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    
    func createEmitter(named name: String, at position: CGPoint, lifetime: TimeInterval = 2) {
        if let emitter = SKEmitterNode(fileNamed: name) {
            emitter.position = position
            addChild(emitter)
            
            let wait = SKAction.wait(forDuration: lifetime)
            let fadeOut = SKAction.fadeOut(withDuration: lifetime)
            let sequence = SKAction.sequence([SKAction.group([wait, fadeOut]), SKAction.removeFromParent()])
            emitter.run(sequence)
        }
    }
}
