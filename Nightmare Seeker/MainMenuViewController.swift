//
//  MainMenuViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 27/06/24.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var muteButton: UIButton!
    var isMute = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeButton(_ sender: Any) {
        if !isMute {
            muteButton.setImage(UIImage(systemName: "speaker.slash.circle.fill"), for:.normal)
            isMute = true
        } else {
           muteButton.setImage(UIImage(systemName: "speaker.circle.fill"), for:.normal)
            isMute = false
        }
    }
    
//    IBOutlet
    @IBAction func buttonAction(_ sender: Any) {
        
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
