//
//  HomeController.swift
//  Login Page
//
//  Created by Macbook on 24/12/22.
//

import UIKit
import FirebaseFirestore

class HomeController: UIViewController, UISearchBarDelegate {
    
    var delegate: HomeControllerDelegate?
    var ref = RemainderViewController()
    var addButton: UIBarButtonItem!
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let searchBar = UISearchBar()
    var isInSearchMode:Bool?
    var isSearching = false
    
    var isListView = false
    var toggleButton = UIBarButtonItem()
    var searchBarNav = UIBarButtonItem()
    
    let db = Firestore.firestore()
    var noteArray = [Note]()
    lazy var filteredNotes = [Note]()
    
        
    var updatedCount = 10
    var lastDocument: QueryDocumentSnapshot?
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .darkGray
        //        configureNavigationBar()
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        filteredNotes = noteArray
        configureSearchBar()
      
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didAddButton), for: .touchUpInside)
        
        toggleButton = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(butonTapped(sender:)))
        searchBarNav = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        loadingInitialData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        floatingButton.frame = CGRect(x: view.frame.size.width-70, y: view.frame.size.height-100, width: 60, height: 60)
        
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func didAddButton(){
        let container = NoteViewController()
        let newVC = UINavigationController(rootViewController: container)
        newVC.modalPresentationStyle = .fullScreen
        present(newVC, animated: true)
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Home Screen"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(handleMenuToggle))
    }
    
    func loadingInitialData(){
        noteArray.removeAll()
        let initialQuary = db.collection("Notes").whereField("isDeleted", isEqualTo: false)
            .order(by: "noteTitle")
            .limit(to: 10)
        initialQuary.getDocuments { quarySnapshot, error in
            guard let snapshot = quarySnapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }
            
            self.lastDocument = snapshot.documents.last
            snapshot.documents.forEach { document in
                let noteObject = document.data()
                let first = noteObject["noteTitle"] as? String ?? ""
                let second = noteObject["noteDescription"] as? String ?? ""
                let id = noteObject["id"] as? String ?? ""
                let date = noteObject["date"] as? Date
                _ = noteObject["isRemaider"] as? Bool
                let note = Note(title: first , note: second, id: id, date: date, isRemainder: false)
                self.noteArray.append(note)
            }
            self.collectionView.reloadData()
        }
    }
    
    func gettingMoreData(){
        guard let lastDocument = lastDocument else {return}
        let moreQuary = db.collection("Notes").whereField("isDeleted", isEqualTo: false)
            .order(by: "noteTitle").start(afterDocument: lastDocument)
            .limit(to: 10)
        moreQuary.getDocuments { quarySnapshot, error in
            guard let snapshot = quarySnapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }
            var listNote = [Note]()
            self.lastDocument = snapshot.documents.last
            snapshot.documents.forEach { document in
                let noteObject = document.data()
                let first = noteObject["noteTitle"] as? String ?? ""
                let second = noteObject["noteDescription"] as? String ?? ""
                let id = noteObject["id"] as? String ?? ""
                let date = noteObject["date"] as? Date
                let note = Note(title: first , note: second, id: id, date: date, isRemainder: false)
                
                listNote.append(note)
                self.updatedCount = self.updatedCount + 1
                print("updating notes \(self.updatedCount)")
            }
            self.noteArray.append(contentsOf: listNote)
        }
    }
    
    func configureSearchBar(){
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        
        showSearchBarButton(shouldShow: true)
        
    }
    
    @objc func handleShowSearchBar() {
        
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow{
            navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(butonTapped(sender:))),UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))]
        } else {
            navigationItem.rightBarButtonItems = nil
        }
    }
    
    @objc func butonTapped(sender: UIBarButtonItem) {
        if isListView {
            toggleButton = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(butonTapped(sender:)))
            isListView = false
        } else {
            toggleButton = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(butonTapped(sender:)))
            isListView = true
        }
     
        self.navigationItem.setRightBarButtonItems([toggleButton,searchBarNav], animated: true)
        self.collectionView.reloadData()
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            isSearching = false
        } else {
            isSearching = true
            filteredNotes = noteArray.filter({ $0.title!.lowercased().contains(searchText.lowercased())
            })
        }
        self.collectionView.reloadData()
    }
}

extension HomeController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredNotes.count
        }else{
            return noteArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        if isSearching {
            cell.namelbl.text = filteredNotes[indexPath.row].title
            cell.agelbl.text = filteredNotes[indexPath.row].note
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemCyan.cgColor
        }else{
            cell.namelbl.text = noteArray[indexPath.row].title
            cell.agelbl.text = noteArray[indexPath.row].note
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemCyan.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        if isListView {
            return CGSize(width: width, height: 120)
        }else {
            return CGSize(width: (width - 15)/2, height: (width - 15)/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Selected index \(indexPath.section) and row: \(indexPath.row)")
        let container = UpdateViewController()
        container.field1 = noteArray[indexPath.row].title
        container.field2 = noteArray[indexPath.row].note
        container.idField = noteArray[indexPath.row].id
        
        
        present(UINavigationController(rootViewController: container), animated: true)
        
        container.completion = { noteid in
            self.db.collection("Notes").document(container.idField).delete() { (err) in
                if  err != nil {
                    print("Error removing document: \(String(describing: err))")
                } else {
                    print("Document successfully removed!")
                   
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == noteArray.count-1{
            gettingMoreData()
        }
        self.perform(#selector(loadTable), with: nil, afterDelay: 0.6)
    }
    @objc func loadTable() {
        self.collectionView.reloadData()
    }
}
