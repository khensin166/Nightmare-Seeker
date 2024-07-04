//
//  MainMenuViewController.swift
//  Nightmare Seeker
//
//  Created by Foundation-014 on 27/06/24.
//

import UIKit

class MainMenuViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet weak var muteButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    
    var isMute = false
    
    @IBOutlet var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
//        sets the size blur view to screen
        blurView.bounds = self.view.bounds
        
//        set width = 90% of screen
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.22)
        
        // Set corner radius and border
            popUpView.layer.cornerRadius = 10
            popUpView.layer.borderWidth = 2
            popUpView.layer.borderColor = UIColor.black.cgColor
            
            // If you want to apply shadow
            popUpView.layer.shadowColor = UIColor.black.cgColor
            popUpView.layer.shadowOpacity = 0.5
            popUpView.layer.shadowOffset = CGSize(width: 0, height: 2)
            popUpView.layer.shadowRadius = 4
        
        // Initially hide popUpView
//                popUpView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopUp(_:)))
                blurView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        guard let username = usernameField.text, !username.isEmpty else {
            // Username field is empty, show an alert or a message to the user
            showAlert(message: "Please enter your username")
            return
        }

        // Username is not empty, proceed with the action
        animateOut(desiredView: popUpView)
        animateOut(desiredView: blurView)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        
//        attach our desired
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.5, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
        
    }
    
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 1, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()})
    }
    
    @IBAction func showUsername(_ sender: Any) {
        animateIn(desiredView: blurView)
        animateIn(desiredView: popUpView)
        usernameField.becomeFirstResponder()
    }
    
    @objc func handleTapOutsidePopUp(_ sender: UITapGestureRecognizer) {
            if !popUpView.frame.contains(sender.location(in: self.view)) {
                animateOut(desiredView: popUpView)
                animateOut(desiredView: blurView)
            }
        }
    
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
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
