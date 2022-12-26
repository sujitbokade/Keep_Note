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
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                print("Sent...")
            } else {
                print("Failed \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
