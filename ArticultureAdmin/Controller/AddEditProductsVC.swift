//
//  AddEditProductsVC.swift
//  ArticultureAdmin
//
//  Created by Zarrar Company on 28/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class AddEditProductsVC: UIViewController {
    
    //Outlets
    @IBOutlet var productName: UITextField!
    @IBOutlet var productPrice: UITextField!
    @IBOutlet var productDetail: UITextView!
    @IBOutlet var productImage: RoundedImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var addProductButton: RoundedButton!
    
    //Varibales
    var productToEdit: Product?
    var selectedCategory: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tap)
        
        if let product = productToEdit {
            addProductButton.setTitle("Save changes", for: .normal)
            productName.text = product.name
            productPrice.text = "\(product.price)"
            productDetail.text = product.product_description
            if let url = URL(string: product.imageURL) {
                productImage.contentMode = .scaleAspectFill
                productImage.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped() {
        launchImagePicker()
    }
    
    @IBAction func addProductClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImage()
    }
    
    func uploadImage() {
        guard let name = productName.text, name.isNotEmpty,
        let description = productDetail.text, description.isNotEmpty,
            let price = productPrice.text, price.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Plese enter product name, description and price")
                activityIndicator.stopAnimating()
                return
        }
        
        guard let imageData = productImage.image?.jpegData(compressionQuality: 0.2) else {
            simpleAlert(title: "Error", msg: "Please upload an image")
            activityIndicator.stopAnimating()
            return
        }
        
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        imageRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            imageRef.downloadURL(completion: { (url, _error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to get image URL")
                    return
                }
                guard let imgURL = url else { return }
                self.addProduct(url: imgURL.absoluteString)
            })
        }
    }
    
    func addProduct(url: String) {
        let productRef: DocumentReference!
        guard let price = productPrice.text else { return }
        guard let doublePrice = Double(price) else { return }
        var product = Product.init(name: productName.text!, category: selectedCategory.id, id: "", price: doublePrice, product_description: productDetail.text, imageURL: url, timeStamp: Timestamp(), stock: 2)
        
        if let _product = productToEdit {
            productRef = Firestore.firestore().collection("products").document(productToEdit!.id)
            product.id = _product.id
        } else {
            productRef = Firestore.firestore().collection("products").document()
            product.id = productRef.documentID
        }
        
        productRef.setData(Product.modelToData(product: product), merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Error while saving document")
            }
            self.activityIndicator.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        activityIndicator.stopAnimating()
        simpleAlert(title: "Error", msg: msg)
    }
}


extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImage.contentMode = .scaleAspectFill
        productImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
