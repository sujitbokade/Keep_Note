//
//  RemainderViewController.swift
//  Login Page
//
//  Created by Macbook on 05/01/23.
//
import UserNotifications
import UIKit
import FirebaseFirestore
import SwipeCellKit

class RemainderViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    let db = Firestore.firestore()
    var lastDocument: QueryDocumentSnapshot?
    
   
    var remainderID: String = ""
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var noteArray = [Note]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource  = self
        view.addSubview(tableView)
        navigationItem.title = "Remainder"
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingInitialData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func didTapAdd() {
        let container = AddRemainderViewController()
        let newVC = UINavigationController(rootViewController: container)
        present(newVC, animated: true)
        container.complition = { title, body , date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = Note(title: title, note: body, id: "id", date: date, isRemainder: false)
                self.noteArray.append(new)
                self.tableView.reloadData()
                
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day , .hour ,.minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "something", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if error != nil {
                        print("Something wrong!")
                    }
                }
            }
        }
    }
    
    func loadingInitialData(){
        
       print("Load data")
        noteArray.removeAll()
        let initialQuary = db.collection("Notes").whereField("isRemaider", isEqualTo: true)
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
}

extension RemainderViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        let date = noteArray[indexPath.row].date
        let formatter = DateFormatter()
        cell.detailTextLabel?.text = formatter.string(from: date!)
        cell.textLabel?.text = noteArray[indexPath.row].title
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        remainderID = self.noteArray[indexPath.row].id
       
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] action, indexPath in
            
            self.updateModel(at: indexPath)
          
        }
        return [deleteAction]
    }
    
    
    func updateModel(at indexPath: IndexPath){
        
        print("Update Model")
            let userData:[String : Any] = [
                "isRemaider": false,
                "id": remainderID
            ]
            
        db.collection("Notes").document(remainderID).updateData(userData)
            { (error) in
                if error != nil{
                    print("Remainder ID \(String(describing: self.remainderID))")
                    print("Erroe \(String(describing: error?.localizedDescription))")
                }
                else {
                    print("succesfully updated")
                    self.dismiss(animated: true,completion: nil)
                }
            }
        }
        
    }



