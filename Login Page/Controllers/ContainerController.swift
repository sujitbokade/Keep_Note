//
//  ContainerController.swift
//  Login Page
//
//  Created by Macbook on 24/12/22.
//

import UIKit
import FirebaseAuth

class ContainerController: UIViewController {
    
    var menuController: MenuController!
    var centreController: UIViewController!
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    func configureHomeController() {
        let homeController = HomeController()
        centreController = UINavigationController(rootViewController: homeController)
        homeController.delegate = self
        view.addSubview(centreController.view)
        addChild(centreController)
        centreController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            print("Add Menu Controller")
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centreController.view.frame.origin.x = self.centreController.view.frame.width - 80
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseInOut, animations: {
                self.centreController.view.frame.origin.x = 0
            }) { [self](_) in
                guard let menuOption = menuOption else{return}
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .Notes:
           print("Notes")
        case .Remainders:
            print("Remainder")
            let container = RemainderViewController()
            let newVC = UINavigationController(rootViewController: container)
            present(newVC, animated: true)
            
        case .Create_label:
            print("Label")
        case .Archive:
            print("Archive")
        case .Trash:
            print("Trash")
        case .Setting:
            print("Setting")
        case .Logout:
            print("LogOut")
            do {
                try Auth.auth().signOut()
                let scene = UIApplication.shared.connectedScenes.first
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginTableViewController")
                    let nav = UINavigationController(rootViewController: loginViewController)
                    sd.window?.rootViewController = nav
                }
                
            } catch {
                print("error \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}

