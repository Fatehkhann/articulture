//
//  RegisterVC.swift
//  Articulture
//
//  Created by Zarrar Company on 16/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import FirebaseAuth

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
            return
        }
        activityIndicator.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.activityIndicator.stopAnimating()
            self?.dismiss(animated: true, completion: nil)
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
