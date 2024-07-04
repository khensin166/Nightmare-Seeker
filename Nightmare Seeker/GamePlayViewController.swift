//
//  GamePlayViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 01/07/24.
//

import UIKit
import SpriteKit

    class GamePlayViewController: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.setHidesBackButton(true, animated: true)
        
            
        }
        
        override var prefersStatusBarHidden: Bool {
            return true
        }
}
