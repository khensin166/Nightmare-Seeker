//
//  GameScene.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 27/06/24.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var player: SKSpriteNode?
    var Hantu: SKSpriteNode?
    
    let xPositions = [-100, 100]
    
    var playerPosition = 1
    
    let motionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        Hantu = self.childNode(withName: "//Hantu") as? SKSpriteNode
        player = self.childNode(withName: "//player") as? SKSpriteNode
        
        repeatedlySpawnhantu()
        
        startMonitoringAcceleration()
    }
    
    func repeatedlySpawnhantu() {
        let spawnAction = SKAction.run {
            self.spawnHantu()
        }
        
        let waitAction = SKAction.wait(forDuration: 0.5)
        
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnHantu() {
        let newHantu = Hantu?.copy() as! SKSpriteNode
        newHantu.position = CGPoint(x: xPositions[Int.random(in: 0...1)], y: 700)
        
        addChild(newHantu)
        
        moveHantu(node: newHantu)
    }
    
    func moveHantu(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -700, duration: 2)
        node.run(moveDownAction)
    }
    
    func startMonitoringAcceleration() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
                if let acceleration = data?.acceleration {
                    self?.updatePlayerPosition(with: acceleration)
                }
            }
        }
    }
    
    func updatePlayerPosition(with acceleration: CMAcceleration) {
        guard let player = player else { return }
        
        let currentXPosition = player.position.x
        let newXPosition = currentXPosition + CGFloat(acceleration.x * 100)
        
        let clampedXPosition = min(max(newXPosition, CGFloat(xPositions[0])), CGFloat(xPositions[1]))
        
        player.position = CGPoint(x: clampedXPosition, y: player.position.y)
    }
}

