//
//  ProductsVC.swift
//  Articulture
//
//  Created by Zarrar Company on 24/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController, ProductCellDelegate, ProductCellDelegateForCart {
    //Outlets
    @IBOutlet var tableView: UITableView!
    
    //Variables
    var products = [Product]()
    var category: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    var showFavorites: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupTableView()
        
        tableView.register(UINib(nibName: identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: identifiers.ProductCell)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setProductsListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        products.removeAll()
        tableView.reloadData()
    }
    
    func addedToCart(product: Product) {
        print("About to add in cart")
        StripeCart.addItemToCart(item: product)
    }
    
    func setProductsListeners() {
        let ref: Query!
        if showFavorites {
            ref = db.collection("users").document(UserService.user.id).collection("favorites")
        } else {
            ref = db.products(category: category.id)
        }
        listener = ref.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snapshot?.documentChanges.forEach({ (documentChange) in
                let data = documentChange.document.data()
                let product = Product.init(data: data)
                
                switch documentChange.type {
                case .added:
                    self.onDocAdded(change: documentChange, product: product)
                case .modified:
                    self.onDocModified(change: documentChange, product: product)
                case .removed:
                    self.onDocRemoved(change: documentChange)
                @unknown default:
                    return
                }
            })
        })
        
    }

    func productFavorited(product: Product) {
        UserService.favoriteSelected(product: product)
        guard let index = products.firstIndex(of: product) else {
            return
        }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}


extension ProductsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiers.ProductCell, for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row], delegate: self, cartDelegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let product = products[indexPath.row]
        vc.product = product
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    func onDocAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath.init(row: newIndex, section: 0)], with: .fade)
//        tableView.reloadData()
    }
    
    func onDocModified(change: DocumentChange, product: Product) {
        if change.oldIndex == change.newIndex {
            let index = Int(change.newIndex)
            products[index] = product
//            tableView.reloadItems(at: [IndexPath.init(item: index, section: 0)])
            tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
        } else {
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
//            tableView.moveItem(at: IndexPath.init(item: oldIndex, section: 0), to: IndexPath.init(item: newIndex, section: 0))
            tableView.moveRow(at: IndexPath.init(row: oldIndex, section: 0), to: IndexPath.init(row: newIndex, section: 0))
        }
    }
    
    func onDocRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
//        tableView.deleteItems(at: [IndexPath.init(item: oldIndex, section: 0)])
        tableView.deleteRows(at: [IndexPath.init(row: oldIndex, section: 0)], with: .left)
    }
    
}
