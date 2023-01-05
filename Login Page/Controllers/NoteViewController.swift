//
//  NoteViewController.swift
//  Login Page
//
//  Created by Macbook on 24/12/22.
//

import UIKit
import FirebaseFirestore
import FirebaseCore


class NoteViewController: UIViewController {
    
    let textField: UITextField = {
        let noteTitle = UITextField()
        noteTitle.placeholder = "Title"
        noteTitle.textAlignment = .left
        noteTitle.translatesAutoresizingMaskIntoConstraints = false
        return noteTitle
    }()
    
    let noteField: UITextField = {
        let note = UITextField()
        note.placeholder = "Note"
        note.textAlignment = .left
        note.backgroundColor = UIColor.white
        note.translatesAutoresizingMaskIntoConstraints = false
        return note
    }()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("note view")
        view.addSubview(textField)
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        textField.becomeFirstResponder()
        
        view.addSubview(noteField)
        noteField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        noteField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        noteField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        
        
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveButton))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelButton))
        
    }
    
    @objc func handleSaveButton() {
        
        if let inputTitle = textField.text , let inputNote = noteField.text {
        
            let noteRef = self.db.collection("USER").document()
            let userData:[String : Any] = [
                "noteTitle": inputTitle,
                "noteDescription": inputNote,
                "id": noteRef.documentID,
                "date": Timestamp(date: Date())
            ]
            
            noteRef.setData(userData) {
                (error:Error?) in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("Document is created with id: \(String(describing: noteRef.documentID))")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func handleCancelButton(){
        self.dismiss(animated: true,completion: nil)
    }
}

