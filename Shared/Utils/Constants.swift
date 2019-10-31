//
//  Constants.swift
//  Articulture
//
//  Created by Zarrar Company on 16/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
}

struct StoryboardID {
    static let LoginVC = "LoginVC"
    static let MainVC = "MainVC"
    
}

struct AppImages {
    static let RedCheck = "red_check"
    static let GreenCheck = "green_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let Placeholder = "placeholder"
}


struct AppColors {
    static let Blue = #colorLiteral(red: 0.1749765358, green: 0.219099089, blue: 0.3706376904, alpha: 1)
    static let Red = #colorLiteral(red: 0.8831495876, green: 0.2054016041, blue: 0.2115704718, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9640623948, green: 0.9671835343, blue: 0.8305851621, alpha: 1)
}

struct identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
    static let CartItemCell = "CartItemCell"
}

struct Segues {
    static let toProductsVC = "toProductsVC"
    static let toAddEditCategory = "toAddEditCategory"
    static let toEditCategory = "toEditCategory"
    static let toAddEditProduct = "toAddEditProduct"
    static let toFavotites = "toFavotites"
}
