//
//  ViewController.swift
//  Articulture
//
//  Created by Zarrar Company on 13/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
        present(viewController, animated: true)
    }


}

