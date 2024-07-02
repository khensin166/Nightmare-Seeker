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
            
            // Ambil SKView dari storyboard
            guard let skView = self.view as? SKView else {
                print("View dari GamePlayViewController bukan SKView")
                return
            }
            
            // Inisialisasi GameScene
            let scene = GameScene(size: skView.bounds.size)
            
            // Tampilkan scene di SKView
            skView.presentScene(scene)
            
            // Opsional: Pengaturan tambahan untuk SKView
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
        
        override var prefersStatusBarHidden: Bool {
            return true
        }
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
