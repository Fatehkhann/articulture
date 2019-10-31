//
//  LoginViewController.swift
//  Articulture
//
//  Created by Zarrar Company on 16/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    @IBOutlet var activictyIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = emailTF.text, email.isNotEmpty,
        let password = passwordTF.text, password.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please fill out all fields")
            return
        }
        activictyIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activictyIndicator.stopAnimating()
                return
            } else {
                self.activictyIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func forgotPwClicked(_ sender: Any) {
        let newViewController = ForgotPasswordVC()
        newViewController.modalPresentationStyle = .overCurrentContext
        newViewController.modalTransitionStyle = .crossDissolve
        present(newViewController, animated: true)
    }
    
    @IBAction func asGuestClicked(_ sender: Any) {
    }
}
