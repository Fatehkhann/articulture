//
//  RegisterVC.swift
//  Articulture
//
//  Created by Zarrar Company on 16/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {

    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var passwordImage: UIImageView!
    @IBOutlet var confirmPasswordImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.addTarget(self, action: #selector(passwordFieldChanges(_:)), for: .editingChanged)
        confirmPasswordTF.addTarget(self, action: #selector(passwordFieldChanges(_:)), for: .editingChanged)
        activityIndicator.stopAnimating()
    }
    

    @IBAction func registerClicked(_ sender: Any) {
        guard let email = emailTF.text, email.isNotEmpty,
        let username = usernameTF.text, username.isNotEmpty,
        let password = passwordTF.text, password.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please fill out all fields")
            return
        }
        guard let confirmPass = confirmPasswordTF.text, confirmPass == password else {
            simpleAlert(title: "Error", msg: "Passwords should match!")
            return
        }
        activityIndicator.startAnimating()
        
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//                Auth.auth().handleFireAuthError(error: error, vc: self)
//                return
//            }
//
//            guard let firUser = result?.user else { return }
//            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
//            self.createFirestoreUser(user: artUser)
//        }
        
        guard let authUser = Auth.auth().currentUser else { return}

        let credentials = EmailAuthProvider.credential(withEmail: email, password: password)

        authUser.link(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                self.activityIndicator.stopAnimating()
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            guard let firUser = authResult?.user else { return }
            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
            self.createFirestoreUser(user: artUser)
        }
    }
    
    func createFirestoreUser(user: User) {
        let userRef = Firestore.firestore().collection("users").document(user.id)
        let userData = User.modelToData(user: user)
        userRef.setData(userData) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            } else {
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func passwordFieldChanges(_ textField: UITextField) {
        guard let passText = passwordTF.text else { return }
        if textField == confirmPasswordTF {
            passwordImage.isHidden = false
            confirmPasswordImage.isHidden = false
        } else {
            if passText.isEmpty {
                passwordImage.isHidden = true
                confirmPasswordImage.isHidden = true
                confirmPasswordTF.text = ""
            }
        }
        
        if passwordTF.text == confirmPasswordTF.text {
            passwordImage.image = UIImage(named: AppImages.GreenCheck)
            confirmPasswordImage.image = UIImage(named: AppImages.GreenCheck)
        } else {
            passwordImage.image = UIImage(named: AppImages.RedCheck)
            confirmPasswordImage.image = UIImage(named: AppImages.RedCheck)
        }
    }
}
