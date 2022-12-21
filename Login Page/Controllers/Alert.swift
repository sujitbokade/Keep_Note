//
//  Alert.swift
//  Login Page
//
//  Created by Macbook on 14/12/22.
//

import Foundation
import UIKit

class Alert {
  public static func showBasicAlertController(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertEmail(on vc: UITableViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Please Enter Valid Email")
    }
    static func showAlertSignUpEmail(on vc: UIViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Please Enter Valid Email")
    }
    
    static func showAlertForPassword(on vc: UITableViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Please Enter Password")
    }
    
    static func showAlerForSignUpPassword(on vc: UIViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Please Enter Valid Password")
    }
    
    static func showAlerForSignUpReEnterPassword(on vc: UIViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Please Re-Enter the Password")
    }
    
    static func showAlerForSignUpConfirmPassword(on vc: UIViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Password does not match")
    }
    
    static func showAlerForUser(on vc: UIViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Please Enter Username")
    }
    
    static func showAlertForLogin(on vc: UITableViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Password & EmailId does not Exists")
    }
   
    static func showAlertForSignUp(on vc: UIViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Registered Successfully! ")
    }
}
