//
//  GameScene.swift
//  Nightmare-Seekers
//
//  Created by Foundation-024 on 02/07/24.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var character: SKSpriteNode!
    var bgDark: SKSpriteNode!
    var motionManager: CMMotionManager!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Ambil node "character" dari sks atau buat manual
        bgDark = self.childNode(withName: "//bgDark") as? SKSpriteNode
        if let existingChar = self.childNode(withName: "//character") as? SKSpriteNode {
            character = existingChar
        } else {
            character = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
            character.zPosition = 10 // Pastikan ini berada di depan bg
            addChild(character)
        }
        
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.contactTestBitMask = character.physicsBody?.collisionBitMask ?? 0
        
        // Mulai membaca data accelerometer
        startAccelerometer()
    }
    
    func startAccelerometer() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is not available")
            return
        }
        
        motionManager.startAccelerometerUpdates(to: .main) { (accelerometerData, error) in
            guard let acceleration = accelerometerData?.acceleration else {
                print("Failed to get accelerometer data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Update position based on accelerometer data
            self.updatePositionWith(acceleration: acceleration)
        }
    }
    
    func updatePositionWith(acceleration: CMAcceleration) {
        // Adjust these values as needed for sensitivity and direction
        let moveSpeed: CGFloat = 100.0 // Kecepatan gerakan, sesuaikan dengan kebutuhan
        let maxXPosition: CGFloat = frame.size.width / 2 - character.size.width / 2 // Batas posisi X agar tidak keluar dari layar
        
        // Calculate new position based on accelerometer data
        let newX = character.position.x + CGFloat(acceleration.x * moveSpeed)
        
        // Limit orang node's X position within screen bounds
        let adjustedX = max(-maxXPosition, min(maxXPosition, newX))
        
        // Calculate the amount to move bgDark based on character's movement
        let bgDarkMoveAmount = character.position.x - adjustedX
        
        // Update bgDark position
        bgDark.position.x -= bgDarkMoveAmount
        
        // Set the new position
        character.position.x = adjustedX
    }
    
    func showGameOver() {
        
    }
}
