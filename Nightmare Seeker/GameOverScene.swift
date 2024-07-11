//
//  GameOverScene.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 08/07/24.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    var restartLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        restartLabel = self.childNode(withName: "//restartLabel") as? SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        
        if self.atPoint(location) == restartLabel {
            restartGame()
        }
    }
    
    func restartGame() {
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            
            let transition = SKTransition.doorway(withDuration: 1)
            view?.presentScene(scene, transition: transition)
            
            NotificationCenter.default.post(name: NSNotification.Name("GameRestart"), object: nil)
        }
    }
}

