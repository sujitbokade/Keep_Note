//
//  HomeViewController.swift
//  Login Page
//
//  Created by Macbook on 16/12/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrdata = ["Notes", "Remainder", "Archive" ,"Trash", "Setting"]
    var arrimg = [#imageLiteral(resourceName: "Notes"), #imageLiteral(resourceName: "Remainder"), #imageLiteral(resourceName: "352019_archive_icon"), #imageLiteral(resourceName: "trash0 2"), #imageLiteral(resourceName: "settings-3110") ]
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideBar: UITableView!
    
    var isSideViewOpen: Bool = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SideBarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SideBarTableViewCell
        cell.label.text = arrdata[indexPath.row]
        cell.img.image = arrimg[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideView.isHidden = true
//        sideBar.backgroundColor = .white
        isSideViewOpen = false
    }
    
    @IBAction func menuBtn(_ sender: UIButton) {
        sideBar.isHidden = false
        sideView.isHidden = false
        self.view.bringSubviewToFront(sideView)
        if !isSideViewOpen {
            isSideViewOpen = true
            sideView.frame = CGRect(x: 0, y: 119, width: 0, height: 513)
            sideBar.frame = CGRect(x: 0, y: 0, width: 0, height: 505)

            
//            UIView.setAnimationDelegate(self)
//            UIView.beginAnimations("TableAnimation", context: nil)
            
            UIView.animate(withDuration: 0.3){ [self] in
                self.sideView.frame = CGRect(x: 0, y: 119, width: 241, height: 513)
                sideBar.frame = CGRect(x: 0, y: 0, width: 234, height: 505)
            }
          
            
        } else {
            sideBar.isHidden = true
            sideView.isHidden = true
            isSideViewOpen = false
            sideView.frame = CGRect(x: 0, y: 119, width: 241, height: 513)
            sideBar.frame = CGRect(x: 0, y: 0, width: 234, height: 505)
//            UIView.setAnimationDuration(0.3)
            
            UIView.animate(withDuration: 0.3){
                self.sideView.frame = CGRect(x: 0, y: 119, width: 0, height: 513)
                self.sideBar.frame = CGRect(x: 0, y: 0, width: 0, height: 505)
            }
//            UIView.setAnimationDelegate(self)
//            UIView.beginAnimations("TableAnimation", context: nil)
            
         }
    }
}
