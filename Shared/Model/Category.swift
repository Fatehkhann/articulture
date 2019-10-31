//
//  Catagory.swift
//  Articulture
//
//  Created by Zarrar Company on 24/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imgURL: String
    var isActive: Bool = true
    var timeStamp: Timestamp
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imgURL = data["imgURL"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    init(name: String, id: String, imgURL: String, isActive: Bool = true, timeStamp: Timestamp) {
        self.name = name
        self.id = id
        self.imgURL = imgURL
        self.isActive = isActive
        self.timeStamp = timeStamp
    }
    
    static func modelToData(category: Category) -> [String: Any] {
        let data: [String: Any] = [
            "name": category.name,
            "id": category.id,
            "isActive": category.isActive,
            "timeStamp": category.timeStamp,
            "imgURL": category.imgURL
        ]

        return data
    }
}
