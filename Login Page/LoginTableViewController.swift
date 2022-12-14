//
//  LoginTableViewController.swift
//  Login Page
//
//  Created by Macbook on 13/12/22.
//

import UIKit

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        if let signVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(signVC, animated: true)
        }
    }
    @IBAction func loginButton(_ sender: UIButton) {
        if let email = txtEmail.text, let password = txtPassword.text {
            if !email.validateEmailId() {
                Alert.showAlertEmail(on: self)
                
            } else if !password.validatePassword() {
                Alert.showAlertForPassword(on: self)
            }
        }
    }
}
