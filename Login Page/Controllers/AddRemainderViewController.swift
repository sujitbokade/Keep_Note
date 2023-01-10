//
//  AddRemainderViewController.swift
//  Login Page
//
//  Created by Macbook on 05/01/23.
//

import UIKit
import FirebaseFirestore

class AddRemainderViewController: UIViewController, UITextFieldDelegate {
    
    let titleField: UITextField = UITextField(frame: CGRect(x: 10, y: 100, width: 400, height: 60))
    let bodyField: UITextField = UITextField(frame: CGRect(x: 10, y: 180, width: 400, height: 60))
    let datePicker: UIDatePicker = UIDatePicker()
    
    public var complition: ((String, String, Date) -> Void)?
   
    let remainderRef = Firestore.firestore().collection("Notes").document()
    
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
            let userData:[String : Any] = [
                "noteTitle": titleField,
                "noteDescription": descText,
                "id": remainderRef.documentID,
                "date": Timestamp(date: Date()),
                "isRemaider": true  
            ]
            
            print(datePicker.date)
            remainderRef.setData(userData) {
                (error:Error?) in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("Remainder is created with id: \(String(describing: self.remainderRef.documentID))")
                    let targetDate = self.datePicker.date
                    self.complition?(titleField,descText,targetDate)
                    self.dismiss(animated: true, completion: nil)
                }
            }
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
           datePicker.frame = CGRect(x: 10, y: 260, width: self.view.frame.width, height: 200)
           datePicker.timeZone = NSTimeZone.local
           datePicker.backgroundColor = UIColor.white
           self.view.addSubview(datePicker)
       }
}
