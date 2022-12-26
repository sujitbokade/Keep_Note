//
//  HomeController.swift
//  Login Page
//
//  Created by Macbook on 24/12/22.
//

import UIKit

class HomeController: UIViewController {
    
    var delegate: HomeControllerDelegate?
    var addButton: UIBarButtonItem!
    
    private let floatingButton: UIButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            button.layer.cornerRadius = 30
        button.backgroundColor = .systemCyan
            
            let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize:30 , weight: .medium ))
            button.setImage(image, for: .normal)
            button.tintColor = .systemYellow
            button.setTitleColor(.white, for: .normal)
    
            button.layer.shadowRadius = 9
            button.layer.shadowOpacity = 0.6
            return button
        }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didAddButton), for: .touchUpInside)
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func didAddButton(){
            let container = NoteViewController()
            let newVC = UINavigationController(rootViewController: container)
            present(newVC, animated: true)
        }
   
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            floatingButton.frame = CGRect(x: view.frame.size.width-80, y: view.frame.size.height-100, width: 60, height: 60)
            
        }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Home Screen"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(handleMenuToggle))
    }
}
