//
//  ViewController.swift
//  ArticultureAdmin
//
//  Created by Zarrar Company on 13/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin"
        navigationItem.leftBarButtonItem?.isEnabled = false
        let addCategoryButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryButton
    }

    @objc func addCategory() {
        performSegue(withIdentifier: Segues.toAddEditCategory, sender: self)
    }
}

