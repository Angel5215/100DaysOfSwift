//
//  GameScene.swift
//  Project11
//
//  Created by Angel Vázquez on 3/17/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var remainingLabel: SKLabelNode!
    
    var remainingBalls = 5 {
        didSet {
            remainingLabel.text = "Balls: \(remainingBalls)"
        }
    }
    
    private enum BallColor: String, CaseIterable {
        case red = "ballRed"
        case blue = "ballBlue"
        case grey = "ballGrey"
        case purple = "ballPurple"
        case yellow = "ballYellow"
        case green = "ballGreen"
        case cyan = "ballCyan"
        
        static let AllColors = BallColor.allCases
        
        static func getRandom() -> String {
            return AllColors.randomElement()?.rawValue ?? "ballRed"
        }
    }

    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let limitLine = SKSpriteNode(color: UIColor(white: 1, alpha: 0.2), size: CGSize(width: size.width, height: 1))
        limitLine.position = CGPoint(x: 512, y: 599.5)
        addChild(limitLine)
        
        for i in 0 ..< 5 {
            makeBouncer(at: CGPoint(x: 256 * i, y: 0))
        }
        
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        remainingLabel = SKLabelNode(fontNamed: "Chalkduster")
        remainingLabel.text = "Balls: \(remainingBalls)"
        remainingLabel.horizontalAlignmentMode = .center
        remainingLabel.position = CGPoint(x: 512, y: 700)
        addChild(remainingLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editingMode = !editingMode
            } else {
                if editingMode {
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    box.name = "box"
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    addChild(box)
                } else if location.y >= 600 && remainingBalls > 0 {
                    let ball = SKSpriteNode(imageNamed: BallColor.getRandom())
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.position = location
                    ball.name = "ball"
                    
                    addChild(ball)
                    
                    remainingBalls -= 1
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool = false) {
        
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 300
            remainingBalls += 1
            
            let color = SKAction.colorize(with: .green, colorBlendFactor: 1, duration: 0.2)
            let scale = SKAction.scale(to: 1.3, duration: 0.2)
            let returnColor = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.2)
            let returnScale = SKAction.scale(to: 1, duration: 0.2)
            let group = SKAction.group([color, scale])
            let returnGroup = SKAction.group([returnColor, returnScale])
            let sequence = SKAction.sequence([group, returnGroup])
            remainingLabel.run(sequence)
            
            
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1500
        }
        
        if object.name == "box" {
            let box = object as! SKSpriteNode
            let points = Int(box.size.width) * Int(box.size.height) / 3
            score += points
            
            remove(box: object)
        }
    }
    
    func destroy(ball: SKNode) {
        
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
            
            //  Removes particles after three seconds
            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
            fireParticles.run(removeAfterDead)
        }
        
        ball.removeFromParent()
    }
    
    func remove(box: SKNode) {
        let scale = SKAction.scale(to: 0.3, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        
        let group = SKAction.group([scale, fadeOut])
        let sequence = SKAction.sequence([group, remove])
        
        box.run(sequence)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
