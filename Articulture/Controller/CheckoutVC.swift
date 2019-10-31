//
//  CheckoutVC.swift
//  Articulture
//
//  Created by Zarrar Company on 30/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController {
    //Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var paymentMethodButton: UIButton!
    @IBOutlet var shippingtMethodButton: UIButton!
    @IBOutlet var subTotal: UILabel!
    @IBOutlet var processingFee: UILabel!
    @IBOutlet var shippingAndHandling: UILabel!
    @IBOutlet var total: UILabel!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    //Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setBillingDetails()
    }
    
    
    fileprivate func setBillingDetails() {
        subTotal.text = StripeCart.subTotal.penniesToFormatedCurrency()
        processingFee.text = StripeCart.processingFees.penniesToFormatedCurrency()
        shippingAndHandling.text = StripeCart.shippingFees.penniesToFormatedCurrency()
        total.text = StripeCart.total.penniesToFormatedCurrency()
    }
    
    fileprivate func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: identifiers.CartItemCell, bundle: nil), forCellReuseIdentifier: identifiers.CartItemCell)
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
    }
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource, CardCellDelegate {
    func itemRemoved(product: Product) {
        if let index = StripeCart.cartItems.firstIndex(of: product) {
            StripeCart.removeItemFromCart(item: product)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
            setBillingDetails()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartItem = StripeCart.cartItems[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiers.CartItemCell, for: indexPath) as? CartItemCell {
            cell.configureCell(product: cartItem, delegate: self)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
