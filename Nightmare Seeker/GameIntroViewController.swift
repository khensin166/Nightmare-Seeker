//
//  GameIntroViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 10/07/24.
//

import UIKit
import SpriteKit

class GameIntroViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure button is connected and not nil
        guard startButton != nil else {
            print("Error: startButton outlet is not connected.")
            return
        }
        
        // Start the blinking animation
        startBlinking()
    }
    
    @IBAction func goToGame(_ sender: Any) {
        if let gameplay = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            navigationController?.pushViewController(gameplay, animated: true)
        } else {
            print("GameViewController not found")
        }
    }
    
    // Function to start blinking animation
    func startBlinking() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        startButton.layer.add(animation, forKey: "blinkAnimation")
    }
}
