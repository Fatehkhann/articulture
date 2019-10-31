//
//  Product.swift
//  Articulture
//
//  Created by Zarrar Company on 24/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var product_description: String
    var imageURL: String
    var timeStamp: Timestamp
    var stock: Int
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.price = Double(data["price"] as? Int ?? 0)
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
        self.category = data["category"] as? String ?? ""
        self.product_description = data["product_description"] as? String ?? ""
    }
    
    init(name: String, category: String, id: String, price: Double, product_description: String, imageURL: String, timeStamp: Timestamp, stock: Int) {
        self.name = name
        self.id = id
        self.imageURL = imageURL
        self.price = price
        self.timeStamp = timeStamp
        self.stock = stock
        self.category = category
        self.product_description = product_description
    }
    
    
    static func modelToData(product: Product) -> [String: Any] {
        let data: [String: Any] = [
            "name": product.name,
            "id": product.id,
            "price": product.price,
            "product_description": product.product_description,
            "category": product.category,
            "timeStamp": product.timeStamp,
            "imageURL": product.imageURL,
            "stock": product.stock
        ]
        
        return data
    }
}

extension Product: Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return (lhs.id == rhs.id && rhs.name == lhs.name)
    }
}
