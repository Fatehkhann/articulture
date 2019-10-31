//
//  Extensions.swift
//  Articulture
//
//  Created by Zarrar Company on 16/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension String {
    var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension Int {
    func penniesToFormatedCurrency() -> String {
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        return "$0.00"
    }
}

