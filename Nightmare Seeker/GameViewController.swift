//
//  GameViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 27/06/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var skView: SKView?
    var gameScene: GameScene?
    
    @IBOutlet weak var modalViews: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  setup observer
        //  using notificationCenter jika ingin 1 to many
        NotificationCenter.default.addObserver(self, selector: #selector(hidePauseButton), name: NSNotification.Name("GameOver"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPauseButton), name: NSNotification.Name("GameRestart"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goHome), name: NSNotification.Name("GoHome"), object: nil)
        
        
        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        skView = self.view as? SKView
        
        if let view = skView {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                gameScene = scene as? GameScene
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func pauseButton(_ sender: Any) {
        if let view = skView, let scene = view.scene as? GameScene {
                    scene.isPaused = true
                    scene.stopAccelerometer()  // Stop accelerometer updates
                    scoreLabel.text = "Your Score: \(scene.score)"
                    modalViews.isHidden = false
            hidePauseButton()
            
            scene.score
                }
    }
    
    @IBAction func ResumeButton(_ sender: Any) {
        if let view = skView, let scene = view.scene as? GameScene {
                    scene.isPaused = false
                    scene.startAccelerometer()
                    modalViews.isHidden = true
            
            showPauseButton()
                }
    }
    @IBAction func backHome(_ sender: Any) {
        goHome()
    }
    
    @objc func hidePauseButton() {
        pauseButton.isHidden = true
    }
    
    @objc func showPauseButton(){
        pauseButton.isHidden = false
    }
    
    @objc func goHome() {
            if let gameplay = storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
                UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: gameplay)
            } else {
                print("MainMenuViewController not found")
            }
        }
    
}
