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
            return
        }
        activictyIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                self?.activictyIndicator.stopAnimating()
                return
            } else {
                self?.activictyIndicator.stopAnimating()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: StoryboardID.MainVC)
                self?.present(viewController, animated: true)
            }
        }
    }
    
    @IBAction func forgotPwClicked(_ sender: Any) {
    }
    
    @IBAction func asGuestClicked(_ sender: Any) {
    }
}
