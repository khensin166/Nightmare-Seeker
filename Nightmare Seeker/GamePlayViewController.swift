//
//  GamePlayViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 01/07/24.
//

import UIKit
import SpriteKit

    class GamePlayViewController: UIViewController {
        
        @IBOutlet var GameOverPopUp: UIView!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.setHidesBackButton(true, animated: true)
        
            
        }
        
        override var prefersStatusBarHidden: Bool {
            return true
        }
        
        
        @IBAction func playAgain(_ sender: Any) {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.doorway(withDuration: 1)
//                view?.presentScene(scene, transition: transition)
            }
        }
    }
