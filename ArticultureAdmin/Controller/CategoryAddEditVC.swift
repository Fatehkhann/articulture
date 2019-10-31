//
//  CategoryAddEditVC.swift
//  ArticultureAdmin
//
//  Created by Zarrar Company on 27/10/2019.
//  Copyright © 2019 Zarrar Company. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class CategoryAddEditVC: UIViewController {

    @IBOutlet var nameText: UITextField!
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var addCategoryButton: RoundedButton!
    
    
    var categoryToEdit: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
        
        if let category = categoryToEdit {
            nameText.text = category.name
            addCategoryButton.setTitle("Save changes", for: .normal)
            if let url = URL(string: category.imgURL) {
                categoryImage.contentMode = .scaleAspectFill
                categoryImage.kf.setImage(with: url)
            }
        }

    }
    
    @objc func imgTapped() {
        launchImagePicker()
    }
    
    @IBAction func addCategory(_ sender: Any) {
        uploadImageAndThenDocument()
    }
    
    func uploadImageAndThenDocument() {
        guard let image = categoryImage.image,
            let categoryName = nameText.text, categoryName.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Category name and image are required")
                return
        }
        activityIndicator.startAnimating()
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        imageRef.putData(imageData, metadata: metadata) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, message: "Error uploading image")
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, message: "Error retrieving image URL")
                    return
                }
                self.activityIndicator.stopAnimating()
                guard let url = url else { return }
                self.addDocument(url: url.absoluteString)
            })
        }
        
    }
    
    func addDocument(url: String) {
        var docRef: DocumentReference!
        
        var category = Category.init(name: nameText.text!, id: "", imgURL: url, timeStamp: Timestamp())
        
        if let _category = categoryToEdit {
            docRef = Firestore.firestore().collection("categories").document(_category.id)
            category.id = _category.id
        } else {
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        docRef.setData(Category.modelToData(category: category), merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, message: "Error saving category")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func handleError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: message)
        self.activityIndicator.stopAnimating()
    }
    
}

extension CategoryAddEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
