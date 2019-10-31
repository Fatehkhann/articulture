//
//  UserService.swift
//  Articulture
//
//  Created by Zarrar Company on 29/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

let UserService = _UserService()

final class _UserService {
    //Variables
    var user = User()
    var favorites = [Product]()
    var auth = Auth.auth()
    var db = Firestore.firestore()
    
    var favListener: ListenerRegistration? = nil
    var userListener: ListenerRegistration? = nil
    
    var isGuest: Bool {
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else {
            return
        }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            self.user = User.init(data: data)
        })
        
        let favRefs = userRef.collection("favorites")
        favListener = favRefs.addSnapshotListener({ (favSnapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            favSnapshot?.documents.forEach({ (queryDocumentSnap) in
                let favorite = Product.init(data: queryDocumentSnap.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        favListener?.remove()
        favListener = nil
        user = User()
        favorites.removeAll()
    }
    
    func favoriteSelected(product: Product) {
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        if favorites.contains(product) {
            favorites.removeAll{ $0 == product }
            favsRef.document(product.id).delete()
        } else {
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
        }
    }
}
