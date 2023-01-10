//
//  TrashViewController.swift
//  Login Page
//
//  Created by Macbook on 10/01/23.
//

import UIKit
import FirebaseFirestore

class TrashViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet var table: UITableView!
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var noteArray = [Note]()
    let db = Firestore.firestore()
    var lastDocument: QueryDocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource  = self
        view.addSubview(tableView)
        navigationItem.title = "Remainder"
        navigationItem.title = "Trash"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteItem))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingInitialData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func loadingInitialData(){
       print("Load data")
        noteArray.removeAll()
        let initialQuary = db.collection("Notes").whereField("isRemaider", isEqualTo: false)
            .order(by: "noteTitle")
            .limit(to: 10)
        initialQuary.getDocuments { quarySnapshot, error in
            guard let snapshot = quarySnapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }
          
            self.lastDocument = snapshot.documents.last
            print(" Count \(snapshot.documents.count)")
            snapshot.documents.forEach { document in
                print("Hello")
                let noteObject = document.data()
                let first = noteObject["noteTitle"] as? String ?? ""
                let second = noteObject["noteDescription"] as? String ?? ""
                let id = noteObject["id"] as? String ?? ""
                let date = noteObject["date"] as? Date
                let isRemainder = noteObject["isRemaider"] as? Bool
                let note = Note(title: first , note: second, id: id, date: date, isRemainder: false)
                self.noteArray.append(note)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func deleteItem() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let date = noteArray[indexPath.row].date
        let formatter = DateFormatter()
        cell.detailTextLabel?.text = formatter.string(from: date!)
        cell.textLabel?.text = noteArray[indexPath.row].title
        return cell
    }

}
