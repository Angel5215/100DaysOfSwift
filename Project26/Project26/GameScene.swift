//
//  GameScene.swift
//  Project26
//
//  Created by Angel Vázquez on 4/27/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import SpriteKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case player = 1     // 0000 0000 0000 0000 0000 0000 0000 0001
    case wall = 2       // 0000 0000 0000 0000 0000 0000 0000 0010
    case star = 4       // 0000 0000 0000 0000 0000 0000 0000 0100
    case vortex = 8     // 0000 0000 0000 0000 0000 0000 0000 1000
    case finish = 16    // 0000 0000 0000 0000 0000 0000 0001 0000
    case portal = 32    // 0000 0000 0000 0000 0000 0000 0010 0000
}

class GameScene: SKScene {
    
    // MARK: - Player properties
    var player: SKSpriteNode!
    
    //  MARK: - Accelerometer properties
    var motionManager: CMMotionManager!
    
    //  MARK: - Game properties
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var activePortals = [Character: [SKNode]]()
    
    var isGameOver = false
    
    // MARK: - Scene life cycle
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.name = "always"
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = .zero
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.name = "always"
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        physicsWorld.contactDelegate = self
        
        loadLevel(named: "level1")
        createPlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }

    
    // MARK: - Level creation
    func loadLevel(named levelName: String) {
        guard let levelURL = Bundle.main.url(forResource: "\(levelName)", withExtension: "txt") else {
            fatalError("Could not find \(levelName) in the app bundle.")
        }
        
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load \(levelName) from the app bundle.")
        }
        
        let lines = levelString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: 64 * column + 32, y: 64 * row + 32)
                createNode(forLetter: letter, at: position)
            }
        }
    }
    
    func createNode(forLetter letter: Character, at position: CGPoint) {
        switch letter {
        case "x": // Wall
            createBlock(at: position)
        case "v": // Vortex
            createVortex(at: position)
        case "s": // Star
            createStar(at: position)
        case "f": // Finish
            createFinish(at: position)
        case "p", "q", "w":
            createPortal(at: position, ofType: letter)
        case " ": // Level empty space
            break
        default:
            fatalError("Unknown level letter: \(letter)")
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    func createBlock(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func createVortex(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func createStar(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func createFinish(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func createPortal(at position: CGPoint, ofType type: Character) {
        let node = SKSpriteNode(imageNamed: "portal")
        node.name = "portal-\(type)"
        
        
        let rotate = SKAction.rotate(byAngle: .pi, duration: 1)
        let sequence = SKAction.sequence([.scale(to: 0.7, duration: 0.5), .scale(to: 1, duration: 0.5)])
        let group = SKAction.group([sequence, rotate])
        node.run(SKAction.repeatForever(group))
        
        addPortal(node, ofType: type)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.portal.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        node.position = position
        addChild(node)
    }
    
    func addPortal(_ portal: SKNode, ofType type: Character) {
        if var array = activePortals[type] {
            array.append(portal)
        } else {
            activePortals[type] = [portal]
        }
    }
    
    //  MARK: - Simulator-only
    var lastTouchPosition: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
}

//  MARK: - Collision handling
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            activePortals.removeAll(keepingCapacity: true)
            for child in children where child.name != "always" {
                child.removeFromParent()
            }
            loadLevel(named: "level2")
            createPlayer()
        }
    }
}
