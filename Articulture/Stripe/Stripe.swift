//
//  Stripe.swift
//  Articulture
//
//  Created by Zarrar Company on 31/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    var cartItems = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    var shippingFees = 0
    
    var subTotal: Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees: Int {
        if subTotal == 0 {
            return 0
        }
        let sub = Double(subTotal)
        return Int(sub*stripeCreditCardCut) + flatFeeCents
    }
    
    var total: Int {
        return subTotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
}
