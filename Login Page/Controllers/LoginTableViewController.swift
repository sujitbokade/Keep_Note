//
//  LoginTableViewController.swift
//  Login Page
//
//  Created by Macbook on 13/12/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore



class LoginTableViewController: UITableViewController {
    
    let signInConfig = GIDConfiguration(clientID: "682593169353-iisvevtflho596173h3laamsisb8drh8.apps.googleusercontent.com")
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var passEyeButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    var dbref = Firestore.firestore()
    
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
                
            } else if password.isEmpty {
                Alert.showAlertForPassword(on: self)
            } else {
                
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    
                    if error != nil {
                        Alert.showAlertForLogin(on: self)
                    } else {
                        if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContainerController") as? ContainerController {
                            self.navigationController?.pushViewController(homeViewController, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func googleSignInButton(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            let emailAddress = signInResult?.user.profile?.email
            print("Google SignIn Successfully")
            
            guard
                let accessToken = signInResult?.user.accessToken,
                let idToken = signInResult?.user.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            let dataSave: [String: Any] = ["email":emailAddress as Any]
            self.dbref.collection("users").addDocument(data: dataSave)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("authentication error \(error.localizedDescription)")
                }
                else{
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationC")
                    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    @IBAction func btnEyeClicked(_ sender: UIButton) {
        txtPassword.isSecureTextEntry.toggle()
        passEyeButton.alpha = 0
        let eyeButton = txtPassword.isSecureTextEntry ?
        UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        passEyeButton.setImage(eyeButton, for: .normal)
        UIView.animate(withDuration: 0.4){[weak self] in
            guard let self = self else{return}
            self.passEyeButton.alpha = 1
        }
    }
}
