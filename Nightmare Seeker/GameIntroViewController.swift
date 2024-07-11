//
//  GameIntroViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 10/07/24.
//

import UIKit
import SpriteKit

class GameIntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToGame(_ sender: Any) {
            if let gameplay = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
                navigationController?.pushViewController(gameplay, animated: true)
            } else {
                print("GameViewController not found")
            }
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
