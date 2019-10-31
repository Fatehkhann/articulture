//
//  ForgotPasswordVC.swift
//  Articulture
//
//  Created by Zarrar Company on 21/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordClicked(_ sender: Any) {
        guard let emailText = emailTextField.text, emailText.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please fill the email field")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
