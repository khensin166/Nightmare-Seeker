import UIKit
import SpriteKit

class GameFinishScene: SKScene {
    var restartLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var homeLabel: SKLabelNode!
    var menuLabel: SKLabelNode!

    var score: Int = 0

    override func didMove(to view: SKView) {
        restartLabel = self.childNode(withName: "//restartLabel") as? SKLabelNode
        scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        homeLabel = self.childNode(withName: "//homeLabel") as? SKLabelNode
        menuLabel = self.childNode(withName: "//menuLabel") as? SKLabelNode // Connect menuLabel

        // Setup observer for game finish notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleGameFinish(notification:)), name: NSNotification.Name("GameFinish"), object: nil)
    }

    @objc func handleGameFinish(notification: NSNotification) {
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
        } else if self.atPoint(location) == menuLabel { // Check for menuLabel touch
            goToMenuFinishScene() // Change to goToMenuFinishScene
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

    func goHome() {
        NotificationCenter.default.post(name: NSNotification.Name("GoHome"), object: nil)
    }

    func goToMenuFinishScene() {
        if let menuFinishScene = SKScene(fileNamed: "MenuFinishScene") {
            let transition = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(menuFinishScene, transition: transition)
        }
    }

    deinit {
        // Remove observer when the scene is deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("GameFinish"), object: nil)
    }
}

