//
//  CartItemCell.swift
//  Articulture
//
//  Created by Zarrar Company on 30/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit


protocol CardCellDelegate: class {
    func itemRemoved(product: Product)
}

class CartItemCell: UITableViewCell {

    //Outlets
    @IBOutlet var productImage: RoundedImageView!
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var trashButton: UIButton!
    
    var product: Product!
    
    weak var cartItemDelegate: CardCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(product: Product, delegate: CardCellDelegate) {
        self.product = product
        cartItemDelegate = delegate
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productLabel.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageURL) {
            productImage.kf.setImage(with: url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        cartItemDelegate?.itemRemoved(product: product)
    }
}
