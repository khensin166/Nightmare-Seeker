//
//  GameSettingViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 01/07/24.
//

import UIKit
import AVFoundation

class GameSettingViewController: UIViewController {

    var playerVidio: AVPlayer?
    
    
//    cek music playet nya tadi ada dimana
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var muteButton: UIButton!
    var isMute = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitApplication(_ sender: Any) {
        exit(0)
    }
    
    @IBAction func changeMuteButton(_ sender: Any) {
        if !isMute {
            muteButton.setImage(UIImage(systemName: "speaker.slash.circle.fill"), for: .normal)
            (sender as? UIButton)?.setTitle("Mute", for: .normal)
            isMute = true
            appDelegate.music?.stop()
        } else {
            muteButton.setImage(UIImage(systemName: "speaker.circle.fill"), for: .normal)
            (sender as? UIButton)?.setTitle("Play", for: .normal)
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
