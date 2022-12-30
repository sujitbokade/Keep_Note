//
//  PasswordRecoverViewController.swift
//  Login Page
//
//  Created by Macbook on 21/12/22.
//

import UIKit
import FirebaseAuth

class PasswordRecoverViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recoverButtonClicked(_ sender: UIButton) {
        let email = userEmail.text!
        
        if email.isEmpty {
            let userMessage: String = "Please Enter Your Email Address"
            displayMessage(userMessage: userMessage)
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                let userMessage: String = "Message was Successfully Sent to you \(email)"
                self.displayMessage(userMessage: userMessage)
            } else {
                print("Failed \(String(describing: error?.localizedDescription))")
                let userMessage: String = "Failed \(String(describing: error?.localizedDescription))"
                self.displayMessage(userMessage: userMessage)
            }
        }
    }
    func displayMessage(userMessage: String){
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}
