//
//  GameSettingViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 01/07/24.
//

import UIKit
import AVFoundation

class GameSettingViewController: UIViewController {

   
    
    @IBOutlet weak var muteButton: UIButton!
    var isMute = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func changeMuteStatus(_ sender: Any) {
        if !isMute {
            muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
         isMute = true
            appDelegate.music?.stop()
        } else {
            muteButton.setImage(UIImage(systemName: "speaker.circle.fill"), for: .normal)
            isMute = false
            appDelegate.music?.play()
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
