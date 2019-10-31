//
//  CategoryCell.swift
//  Articulture
//
//  Created by Zarrar Company on 24/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 5
    }
    
    func configureCell(category: Category) {
        categoryLabel.text = category.name
        if let url = URL(string: category.imgURL) {
            let placeHolder = UIImage(named: "placeholder")
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            categoryImage.kf.indicatorType = .activity
            categoryImage.kf.setImage(with: url, placeholder: placeHolder, options: options)
        }
    }

}
