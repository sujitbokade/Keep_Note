//
//  RemainderViewController.swift
//  Login Page
//
//  Created by Macbook on 05/01/23.
//
import UserNotifications
import UIKit

class RemainderViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var models = [Remainder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource  = self
        view.addSubview(tableView)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test", style: .done, target: self, action: #selector(test))
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
                let new = Remainder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.tableView.reloadData()
                
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day , .hour ,.minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if error != nil {
                        print("Something wrong!")
                    }
                }
            }
        }
    }
    
    @objc func test() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge, .sound]) { success, error in
            if success {

                self.scheduleTest()
            }
            else if let error = error{
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func scheduleTest(){
            
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.sound = .default
        content.body = "Remainder Notification"
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day , .hour ,.minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("Something went wrong")
            }
        }
    }
}

extension RemainderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        let formatter = DateFormatter()
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
}

struct Remainder {
    let title: String
    let date: Date
    let identifier: String
}
