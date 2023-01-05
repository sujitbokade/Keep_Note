//
//  AddRemainderViewController.swift
//  Login Page
//
//  Created by Macbook on 05/01/23.
//

import UIKit

class AddRemainderViewController: UIViewController, UITextFieldDelegate {
    
    let titleField: UITextField = UITextField(frame: CGRect(x: 10, y: 100, width: 400, height: 60))
    let bodyField: UITextField = UITextField(frame: CGRect(x: 10, y: 180, width: 400, height: 60))
    let datePicker: UIDatePicker = UIDatePicker()
    
    public var complition: ((String, String, Date) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancleButton))
        
        view.backgroundColor = .white
        displayTitleField()
        displayDatePicker()
        displayDescriptionField()
        
    }
    
    @objc func didTapSaveButton(){
        if let titleField = titleField.text, !titleField.isEmpty,
           let descText = bodyField.text, !descText.isEmpty {
            let targetDate = datePicker.date
            complition?(titleField,descText,targetDate)
            
        }
    }
    @objc func cancleButton(){
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func displayTitleField(){
          titleField.placeholder = "enter title.."
          titleField.borderStyle = UITextField.BorderStyle.line
          titleField.backgroundColor = UIColor.white
          titleField.textColor = UIColor.blue
          self.view.addSubview(titleField)
       }
    
       func displayDescriptionField(){
           bodyField.placeholder = "enter description..."
           bodyField.borderStyle = UITextField.BorderStyle.line
           bodyField.backgroundColor = UIColor.white
           bodyField.textColor = UIColor.blue
           self.view.addSubview(bodyField)
        }

       func displayDatePicker(){
           datePicker.frame = CGRect(x: 10, y: 260, width: self.view.frame.width, height: 100)
           datePicker.timeZone = NSTimeZone.local
           datePicker.backgroundColor = UIColor.white
           self.view.addSubview(datePicker)
       }
}
