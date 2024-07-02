//
//  GameScene.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 27/06/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var person_walk_1: SKSpriteNode!
        
        override func didMove(to view: SKView) {
            // Pastikan untuk memanggil method super
            super.didMove(to: view)
            
            // Ambil node background dari .sks jika ada
            if let backgroundNode = self.childNode(withName: "lorong") as? SKSpriteNode {
                backgroundNode.zPosition = -1  // Pastikan background berada di belakang
            }
            
            // Ambil node person dari .sks jika ada, jika tidak buat baru
            if let personNode = self.childNode(withName: "person_walk_1") as? SKSpriteNode {
                person_walk_1 = personNode
            } else {
                let personTexture = SKTexture(imageNamed: "person_walk_1")
                person_walk_1 = SKSpriteNode(texture: personTexture)
                person_walk_1.name = "person_walk_1"
                person_walk_1.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
                self.addChild(person_walk_1)
            }
            
            // Mulai animasi gerakan person
            startMoving()
        }
        
        private func startMoving() {
            // Define movement action
            let moveRight = SKAction.moveBy(x: 100, y: 0, duration: 1)
            let moveLeft = SKAction.moveBy(x: -100, y: 0, duration: 1)
            let sequence = SKAction.sequence([moveRight, moveLeft])
            let repeatAction = SKAction.repeatForever(sequence)
            
            // Run the movement action
            person_walk_1.run(repeatAction)
        }


    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
