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
    
    static func showAlertForPassword(on vc: UITableViewController) {
        showBasicAlertController(on: vc, with: "Alert", message: "Please Enter Valid Password")
    }
}
