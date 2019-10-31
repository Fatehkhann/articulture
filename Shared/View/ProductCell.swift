//
//  ProductCell.swift
//  Articulture
//
//  Created by Zarrar Company on 25/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: class {
    func productFavorited(product: Product)
}

protocol ProductCellDelegateForCart: class {
    func addedToCart(product: Product)
}


class ProductCell: UITableViewCell {

    @IBOutlet var productImage: RoundedImageView!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    weak var delegate: ProductCellDelegate?
    weak var delegateForCart: ProductCellDelegateForCart?
    
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate, cartDelegate: ProductCellDelegateForCart) {
        self.product = product
        self.delegate = delegate
        self.delegateForCart = cartDelegate
        
        productTitle.text = product.name
        productPrice.text = "\(product.price)"
        if let url = URL(string: product.imageURL) {
            let placeHolder = UIImage(named: AppImages.Placeholder)
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url, placeholder: placeHolder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if UserService.favorites.contains(product) {
            favoriteButton.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: AppImages.EmptyStar), for: .normal)
        }
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    @IBAction func addToCart(_ sender: Any) {
        delegateForCart?.addedToCart(product: product)
    }
    
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
}
