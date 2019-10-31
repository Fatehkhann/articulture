//
//  ViewController.swift
//  Articulture
//
//  Created by Zarrar Company on 13/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController {

    // Outlets
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var loginOutBarButton: UIBarButtonItem!
    
    //Variables
    var categories = [Category]()
    var selectedCategory: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        db = Firestore.firestore()
        setupCollectionView()
        
        super.viewDidLoad()
        setupInitialAnonymousUser()
//        setupNavigationBar()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: identifiers.CategoryCell)
    }
    
    func setupInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                }
                print("***** SIGNED IN ANONYMOUSLY *****")
            }
        }
    }
    
    func setupNavigationBar() {
        guard let font = UIFont(name: "Futura", size: 22.0) else { return }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
        loginOutBarButton.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
            ], for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCategoriesListeners()
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutBarButton.title = "Logout"
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        } else {
            loginOutBarButton.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    func setCategoriesListeners() {
        listener = db.categories.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snapshot?.documentChanges.forEach({ (documentChange) in
                let data = documentChange.document.data()
                let category = Category.init(data: data)
                
                switch documentChange.type {
                case .added:
                    self.onDocAdded(change: documentChange, category: category)
                case .modified:
                    self.onDocModified(change: documentChange, category: category)
                case .removed:
                    self.onDocRemoved(change: documentChange)
                @unknown default:
                    return
                }
            })
        })
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
        present(viewController, animated: true)
    }
    
    @IBAction func favoriteBarButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Segues.toFavotites, sender: self)
    }
    
    @IBAction func loginOutButtonTapped(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
                Auth.auth().signInAnonymously { (authResult, error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                    }
                    self.presentLoginController()
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
//        if let _ = Auth.auth().currentUser {
//            do {
//                try Auth.auth().signOut()
//                presentLoginController()
//            } catch {
//                print(error.localizedDescription)
//            }
//        } else {
//            presentLoginController()
//        }
    }
    
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func onDocAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath.init(item: newIndex, section: 0)])
    }
    
    func onDocModified(change: DocumentChange, category: Category) {
        if change.oldIndex == change.newIndex {
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath.init(item: index, section: 0)])
        } else {
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at: IndexPath.init(item: oldIndex, section: 0), to: IndexPath.init(item: newIndex, section: 0))
        }
    }
    
    func onDocRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath.init(item: oldIndex, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width-30) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.toProductsVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toProductsVC {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        } else if segue.identifier == Segues.toFavotites {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
                destination.showFavorites = true
            }
        }
    }
}

// ******** Functions for future reference *************

//    func fetchDocument() {
//        let docRef = db.collection("categories").document("iDGVYaQzq2485nUwDbdT")
//        docRef.addSnapshotListener { (snapshot, error) in
//            guard let data = snapshot?.data() else { return }
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }

//        docRef.getDocument { (snapshot, error) in
//            guard let data = snapshot?.data() else { return }
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
//    }

//    func fetchCollection() {
//        let collectionReference = db.collection("categories")
//        listener = collectionReference.addSnapshotListener { (snapshot, error) in
//            guard let documents = snapshot?.documents else { return }
//            self.categories.removeAll()
//            for document in documents {
//                let data = document.data()
//                let category = Category.init(data: data)
//                self.categories.append(category)
//            }
//            self.collectionView.reloadData()
//        }
//        collectionReference.getDocuments { (snapshot, error) in
//            guard let documents = snapshot?.documents else { return }
//            for document in documents {
//                let data = document.data()
//                let category = Category.init(data: data)
//                self.categories.append(category)
//            }
//            self.collectionView.reloadData()
//        }
//    }
