//
//  GameScene.swift
//  Project17
//
//  Created by Angel Vázquez on 4/3/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //  MARK: Enemies
    var possibleEnemies = ["ball", "hammer", "tv"]
    
    var isGameOver = false {
        didSet {
            if isGameOver {
                gameOver()
            }
        }
    }
    
    var gameTimer: Timer?
    
    var enemyCount = 0
    var enemyInterval: Double = 1 {
        didSet {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            formatter.minimumSignificantDigits = 2
            let str = formatter.string(from: enemyInterval as NSNumber) ?? String(enemyInterval)
            enemySpeedLabel.text = "Enemies created every \(str) seconds"
        }
    }
    
    var enemySpeedLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "Starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        enemySpeedLabel = SKLabelNode(fontNamed: "Chalkduster")
        enemySpeedLabel.fontSize = 18
        enemySpeedLabel.text = "Enemies created every second"
        enemySpeedLabel.position = CGPoint(x: 650, y: 16)
        enemySpeedLabel.horizontalAlignmentMode = .left
        addChild(enemySpeedLabel)
        
        score = 0
        
        //  CGVector.zero
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: enemyInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        
        enemyCount += 1
        if enemyCount.isMultiple(of: 20) {
            enemyInterval -= 0.1
            gameTimer?.invalidate()
            
            gameTimer = Timer.scheduledTimer(timeInterval: enemyInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
        
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        sprite.name = "enemy"
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children where node.position.x < -300 {
            node.removeFromParent()
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard isGameOver == false else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver && !touches.isEmpty {
            isGameOver = true
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        explosion.run(SKAction.sequence([.wait(forDuration: 2), .removeFromParent()]))
        
        isGameOver = true
    }
    
    func gameOver() {
        
        for node in children where node.name == "enemy" {
            node.removeFromParent()
        }
        
        player.run(SKAction.sequence([.fadeOut(withDuration: 0.5), .removeFromParent()]))
        
        gameTimer?.invalidate()
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        addChild(gameOver)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let groupOne = SKAction.group([scaleUp, fadeIn])
        let scaleDown = SKAction.scale(to: 1, duration: 0.5)
        let sequence = SKAction.sequence([groupOne, scaleDown])
        gameOver.run(sequence)
    }
    
}
