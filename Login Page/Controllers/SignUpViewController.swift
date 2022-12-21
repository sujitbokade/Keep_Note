//
//  SignUpViewController.swift
//  Login Page
//
//  Created by Macbook on 14/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signupEmailTxt: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet private weak var imgProfile: UIImageView!
    
    func onGalleryImageAvailable(img: UIImage) {
        imgProfile.image = img
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer: )))
        imgProfile.addGestureRecognizer(tapGesture)
        
    }
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openGallery()
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        if let signupEmail = signupEmailTxt.text, let userTxt = userTextField.text, let password = txtPassword.text, let confirmPassword = txtConfirmPassword.text
        {
            if userTxt.isEmpty {
                Alert.showAlerForUser(on: self)
            } else if !signupEmail.validateEmailId() {
                Alert.showAlertSignUpEmail(on: self )
            } else if !password.validatePassword() {
                Alert.showAlerForSignUpPassword(on: self)
            } else if confirmPassword == "" {
                Alert.showAlerForSignUpReEnterPassword(on: self)
            } else if confirmPassword != password {
                Alert.showAlerForSignUpConfirmPassword(on: self)
            } else {
                Auth.auth().createUser(withEmail: signupEmail, password: password) { result, error in
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["username": userTxt, "uid": result!.user.uid])
                }
            }
            
            Alert.showAlertForSignUp(on: self)
        }
    }
}



