//
//  AdminProductsVC.swift
//  ArticultureAdmin
//
//  Created by Zarrar Company on 28/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {

    var selectedProduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let newProductButton = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(addProduct))
        
        navigationItem.setRightBarButtonItems([editCategoryButton, newProductButton], animated: false)

    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.toEditCategory, sender: self)
    }
    
    @objc func addProduct() {
        selectedProduct = nil
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.toEditCategory {
            if let destination = segue.destination as? CategoryAddEditVC {
                destination.categoryToEdit = category
            }
        }
    }

}
