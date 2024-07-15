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
    var scoreLabel: SKLabelNode!
    var homeLabel: SKLabelNode!
    
    var score: Int = 0
    
    override func didMove(to view: SKView) {
        restartLabel = self.childNode(withName: "//restartLabel") as? SKLabelNode
        restartLabel.fontName = "CS Roger Inner"
        
        scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        scoreLabel.fontName = "CS Roger Inner"
        
        homeLabel = self.childNode(withName: "//homeLabel") as? SKLabelNode
        homeLabel.fontName = "CS Roger Inner"
        
        // Setup observer for game over notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleGameOver(notification:)), name: NSNotification.Name("GameOver"), object: nil)
    }
    
    @objc func handleGameOver(notification: NSNotification) {
            if let userInfo = notification.userInfo, let score = userInfo["score"] as? Int {
                self.score = score
                // Display the score on the scoreLabel
                scoreLabel.text = "Your Score: \(score)"
            }
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
                    return
                }
                let location = touch.location(in: self)
                
                if self.atPoint(location) == restartLabel {
                    restartGame()
                } else if self.atPoint(location) == homeLabel {
                    goHome()
                }
    }
    
    func restartGame() {
        if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            scene.scaleMode = .aspectFill
            scene.isPaused = true
            
            let transition = SKTransition.fade(withDuration: 1)
            view?.presentScene(scene, transition: transition)
            
            NotificationCenter.default.post(name: NSNotification.Name("GameRestart"), object: nil)
        }
    }
    
    func goHome() {
            NotificationCenter.default.post(name: NSNotification.Name("GoHome"), object: nil)
        }
    
    
    deinit {
            // Remove observer when the scene is deallocated
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("GameOver"), object: nil)
        }
}

