//
//  UpdateViewController.swift
//  Login Page
//
//  Created by Macbook on 27/12/22.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class UpdateViewController: UIViewController {
    
    let textField: UITextField = {
        let noteTitle = UITextField()
        noteTitle.placeholder = "Enter here"
        noteTitle.textAlignment = .left
        noteTitle.translatesAutoresizingMaskIntoConstraints = false
        return noteTitle
    }()
    
    let noteField: UITextField = {
        let note = UITextField()
        note.placeholder = "Enter here"
        note.textAlignment = .left
        note.backgroundColor = .white
        note.translatesAutoresizingMaskIntoConstraints = false
        return note
    }()
    
    lazy var notelbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Hello"
        label.numberOfLines = 0
        return label
    }()
    
    var field1: String! = nil
    var field2: String! = nil
    
    let db = Firestore.firestore()
    
    var idField: String! = nil
    
    public var completion: ((String) -> Void)?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("note id \(String(describing: idField))")
        view.addSubview(textField)
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        textField.becomeFirstResponder()
        
        view.addSubview(noteField)
        noteField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        noteField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        noteField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        
        textField.text = field1
        noteField.text = field2
        
        view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(handleUpdateButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteItem))
    }
    
    @objc func handleUpdateButton(){
        updateData()
        
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc func deleteItem(){
        
        do {
            completion!(idField)
        }
        dismiss(animated: true,completion: nil)
        
    }
    
    func updateData(){
        
        if let titleField = textField.text, let descField = noteField.text {
            
            let newDocumnetId = db.collection("USER").document()
            let userData = [
                "noteTitle": titleField,
                "noteDescription": descField,
                "id": idField!
            ] as [String : Any]
            
            db.collection("USER").document("AReQaBrU1QP5j3bjNaj6").updateData(userData)
            { (error) in
                if error != nil{
                    print("Erroe \(String(describing: error?.localizedDescription))")
                }
                else {
                    print("succesfully updated")
                    
                    
                }
            }
        }
    }
}
