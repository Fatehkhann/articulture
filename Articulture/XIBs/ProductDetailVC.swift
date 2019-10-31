//
//  ProductDetailVC.swift
//  Articulture
//
//  Created by Zarrar Company on 27/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    //outlets
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productDescription: UILabel!
    @IBOutlet var bgView: UIVisualEffectView!
    
    //Variables
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTitle.text = product.name
        productDescription.text = product.product_description
        
        if let url = URL(string: product.imageURL) {
            productImage.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCart(_ sender: Any) {
        StripeCart.addItemToCart(item: product)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func keepShopping(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
