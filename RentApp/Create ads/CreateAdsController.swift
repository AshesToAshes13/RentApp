//
//  CreateAdsController.swift
//  RentApp
//
//  Created by Егор Бамбуров on 13/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class CreateAdsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        navigationItem.title = "Создание"
        
        let imagesStackView = UIStackView(arrangedSubviews: [anotherAdImage1,anotherAdImage2,anotherAdImage3,anotherAdImage4,anotherAdImage5])
        imagesStackView.axis = .horizontal
        imagesStackView.spacing = 1
        imagesStackView.distribution = .fillEqually
        
        let objectTfAndDealTfStackView = UIStackView(arrangedSubviews: [objectTextField,dealTextField])
        objectTfAndDealTfStackView.axis = .horizontal
        objectTfAndDealTfStackView.spacing = 4
        objectTfAndDealTfStackView.distribution = .fillEqually
        
        let cityTfAndneighbordhoodTfStackview = UIStackView(arrangedSubviews: [cityTextField,neighbordhoodTextField])
        cityTfAndneighbordhoodTfStackview.axis = .horizontal
        cityTfAndneighbordhoodTfStackview.spacing = 4
        cityTfAndneighbordhoodTfStackview.distribution = .fillEqually
        
        let squareTdAndCostTfStackView = UIStackView(arrangedSubviews: [squareTextField, costTextField])
        squareTdAndCostTfStackView.axis = .horizontal
        squareTdAndCostTfStackView.spacing = 4
        squareTdAndCostTfStackView.distribution = .fillEqually
        
        let allTfsStackView = UIStackView(arrangedSubviews: [objectTfAndDealTfStackView,cityTfAndneighbordhoodTfStackview,squareTdAndCostTfStackView])
        allTfsStackView.axis = .vertical
        allTfsStackView.spacing = 4
        allTfsStackView.distribution = .fillEqually
        
        collectionView.addSubview(mainAdImagePicker)
        collectionView.addSubview(imagesStackView)
        collectionView.addSubview(imageStackViewSeparator)
        collectionView.addSubview(allTfsStackView)
        collectionView.addSubview(allTfsStackViewSeparator)
        collectionView.addSubview(discriptionTextView)
        collectionView.addSubview(discriptionTvSeparator)
        collectionView.addSubview(publickButton)
        
        mainAdImagePicker.anchor(top: collectionView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 200)
        imagesStackView.anchor(top: mainAdImagePicker.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width/5)
        imageStackViewSeparator.anchor(top: imagesStackView.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 0, paddingRight: 2, width: 0, height: 0.5)
        
        allTfsStackView.anchor(top: imageStackViewSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: view.frame.width - 8, height: 128)
        allTfsStackViewSeparator.anchor(top: allTfsStackView.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 2, paddingBottom: 0, paddingRight: 2, width: 0, height: 0.5)
        
        discriptionTextView.anchor(top: allTfsStackViewSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: view.frame.width - 8, height: 80)
        discriptionTvSeparator.anchor(top: discriptionTextView.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 2, paddingBottom: 0, paddingRight: 2, width: 0, height: 0.5)
        
        publickButton.anchor(top: discriptionTvSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: collectionView.safeAreaLayoutGuide.bottomAnchor, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 35, paddingBottom: 0, paddingRight: 35, width: view.frame.width - 70, height: 40)
    }
    
    let objectTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Офис, квартира..."
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    let dealTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Сдать/Продать"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    let cityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Город"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    let neighbordhoodTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Район"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    let squareTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Площадь"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        tf.keyboardType = .numberPad
        return tf
    }()
    
    let costTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Цена"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        tf.keyboardType = .numberPad
        return tf
    }()
    
    let discriptionTextView: AdDiscriptionTvPlaceHolder = {
        let tv = AdDiscriptionTvPlaceHolder()
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    let publickButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Опубликовать", for: .normal)
        btn.addTarget(self, action: #selector(handlePublick), for: .touchUpInside)
        btn.tintColor = UIColor.darkGray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        return btn
    }()
    
    let imageStackViewSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let allTfsStackViewSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let discriptionTvSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    
    @objc func handlePublick() {
        let formIsValid = mainAdImagePicker.isEnabled == false && objectTextField.text?.isEmpty == false && dealTextField.text?.isEmpty == false && cityTextField.text?.isEmpty == false && neighbordhoodTextField.text?.isEmpty == false && squareTextField.text?.isEmpty == false && costTextField.text?.isEmpty == false && discriptionTextView.text.isEmpty == false
        
        if formIsValid {
            publicAd()
        } else {
            if mainAdImagePicker.isEnabled == true {
                let image = UIImage(named: "plus_photo_unselected")?.withRenderingMode(.alwaysOriginal)
                mainAdImagePicker.setImage(image, for: .normal)
            } else {
                
            }
            if objectTextField.text?.isEmpty == true {
                objectTextField.layer.borderWidth = 1
                objectTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                objectTextField.layer.borderWidth = 0.5
                objectTextField.layer.borderColor = UIColor.lightGray.cgColor
            }
            if dealTextField.text?.isEmpty == true {
                dealTextField.layer.borderWidth = 1
                dealTextField.layer.borderColor = UIColor.red.cgColor
            }else {
                dealTextField.layer.borderWidth = 0.5
                dealTextField.layer.borderColor = UIColor.lightGray.cgColor
            }
            if cityTextField.text?.isEmpty == true {
                cityTextField.layer.borderWidth = 1
                cityTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                cityTextField.layer.borderWidth = 0.5
                cityTextField.layer.borderColor = UIColor.lightGray.cgColor
            }
            if neighbordhoodTextField.text?.isEmpty == true {
                neighbordhoodTextField.layer.borderWidth = 1
                neighbordhoodTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                neighbordhoodTextField.layer.borderWidth = 0.5
                neighbordhoodTextField.layer.borderColor = UIColor.lightGray.cgColor
            }
            if squareTextField.text?.isEmpty == true {
                squareTextField.layer.borderWidth = 1
                squareTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                squareTextField.layer.borderWidth = 0.5
                squareTextField.layer.borderColor = UIColor.lightGray.cgColor
            }
            if costTextField.text?.isEmpty == true {
                costTextField.layer.borderWidth = 1
                costTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                costTextField.layer.borderWidth = 0.5
                costTextField.layer.borderColor = UIColor.lightGray.cgColor
            }
            if discriptionTextView.text.isEmpty == true {
                discriptionTextView.layer.borderWidth = 1
                discriptionTextView.layer.borderColor = UIColor.red.cgColor
            } else {
                discriptionTextView.layer.borderWidth = 0
            }
        }
    }
    
    
    let mainAdImagePicker: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleChoseMainImage), for: .touchUpInside)
        return btn
    }()
    
    let anotherAdImage1: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleChoseImage1), for: .touchUpInside)
        return btn
    }()
    
    let anotherAdImage2: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleChoseImage2), for: .touchUpInside)
        return btn
    }()
    
    let anotherAdImage3: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleChoseImage3), for: .touchUpInside)
        return btn
    }()
    
    let anotherAdImage4: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleChoseImage4), for: .touchUpInside)
        return btn
    }()
    
    let anotherAdImage5: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleChoseImage5), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleChoseMainImage() {
        flag = 1
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleChoseImage1() {
        flag = 2
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleChoseImage2() {
        flag = 3
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleChoseImage3() {
        flag = 4
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleChoseImage4() {
        flag = 5
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleChoseImage5() {
        flag = 6
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if flag == 1 {
                mainAdImagePicker.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                mainAdImagePicker.isEnabled = false
            } else if flag == 2 {
                anotherAdImage1.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage1.isEnabled = false
            } else if flag == 3 {
                anotherAdImage2.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage2.isEnabled = false
            } else if flag == 4 {
                anotherAdImage3.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage3.isEnabled = false
            } else if flag == 5 {
                anotherAdImage4.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage4.isEnabled = false
            } else if flag == 6 {
                anotherAdImage5.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage5.isEnabled = false
            }
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if flag == 1 {
                mainAdImagePicker.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
                mainAdImagePicker.isEnabled = false
            } else if flag == 2 {
                anotherAdImage1.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage1.isEnabled = false
            } else if flag == 3 {
                anotherAdImage2.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage2.isEnabled = false
            } else if flag == 4 {
                anotherAdImage3.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage3.isEnabled = false
            } else if flag == 5 {
                anotherAdImage4.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage4.isEnabled = false
            } else if flag == 6 {
                anotherAdImage5.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
                anotherAdImage5.isEnabled = false
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func publicAd() {
        if mainAdImagePicker.isEnabled == true {
            let alertController = UIAlertController(title: "Изображение не выбранно", message: "\nВыберите главное изображение\n", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alertController, animated: true, completion: nil)
            
        } else if mainAdImagePicker.isEnabled == false{
            
            guard let mainImage = mainAdImagePicker.imageView?.image else {return}
            guard let uploadData = mainImage.jpegData(compressionQuality: 1) else {return}
            guard let creatorsUid = Auth.auth().currentUser?.uid else {return}
            guard let object = objectTextField.text else {return}
            guard let dealType = dealTextField.text else {return}
            guard let city = cityTextField.text  else {return}
            guard let neighbordhood = neighbordhoodTextField.text else {return}
            guard let square = squareTextField.text else {return}
            guard let cost = costTextField.text else {return}
            guard let discription = discriptionTextView.text else {return}
            let creationDate = Date().timeIntervalSince1970
            let filename = NSUUID().uuidString
            let AnotherImagesID = NSUUID().uuidString
            let image = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal)
            let isModerated = "0"
            let storagaRef = Storage.storage().reference().child("Ads_Photos").child(filename)
            storagaRef.putData(uploadData, metadata: nil) { (metadata, err) in
                if let err = err {
                    print(err)
                }
                storagaRef.downloadURL(completion: { (downLoadUrl, err) in
                    if let err = err {
                        print(err)
                    }
                    guard let mainAdImageURL = downLoadUrl?.absoluteString else {return}
                    
                    let values = ["Main_image_URl": mainAdImageURL, "Creators_Uid": creatorsUid, "Objetc": object, "Deal_type": dealType, "City": city, "Neighborhood": neighbordhood, "Square": square, "Cost": cost, "Discription": discription,"Another_Images": AnotherImagesID, "Creation_Date": creationDate,"isModerated": isModerated] as [String : Any]
                    Database.database().reference().child("All_Ads").child(creatorsUid).childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print(err)
                        }
                        
                        self.objectTextField.text = nil
                        self.dealTextField.text = nil
                        self.cityTextField.text = nil
                        self.neighbordhoodTextField.text = nil
                        self.squareTextField.text = nil
                        self.costTextField.text = nil
                        self.discriptionTextView.text = nil
                        self.discriptionTextView.showPlaceHolderLabel()
                        let creationDateMainImage = Date().timeIntervalSince1970
                        let imageValue = ["imageUrl": mainAdImageURL, "Creation_Date": creationDateMainImage] as [String : Any]
                        
                        Database.database().reference().child("Another_Ad_images").child(AnotherImagesID).childByAutoId().updateChildValues(imageValue, withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err)
                            }
                        })
                    })
                })
                self.mainAdImagePicker.setImage(image, for: .normal)
                self.mainAdImagePicker.isEnabled = true
            }
            
            if anotherAdImage1.isEnabled == true {
            } else if anotherAdImage1.isEnabled == false {
                guard let mainImage = anotherAdImage1.imageView?.image else {return}
                guard let uploadData = mainImage.jpegData(compressionQuality: 1) else {return}
                let filename = NSUUID().uuidString
                
                let storagaRef1 = Storage.storage().reference().child("Ads_Photos").child(filename)
                storagaRef1.putData(uploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        print(err)
                    }
                    
                    storagaRef1.downloadURL(completion: { (image1Url, err) in
                        if let err = err {
                            print(err)
                        }
                        guard let image1Url = image1Url?.absoluteString else {return}
                        let creationDateImage1 = Date().timeIntervalSince1970
                        let values = ["imageUrl": image1Url, "Creation_Date": creationDateImage1] as [String : Any]
                        Database.database().reference().child("Another_Ad_images").child(AnotherImagesID).childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err)
                            }
                        })
                    })
                    
                    self.anotherAdImage1.setImage(image, for: .normal)
                    self.anotherAdImage1.isEnabled = true
                }
            }
            
            if anotherAdImage2.isEnabled == true {
                
            } else if anotherAdImage2.isEnabled == false {
                
                guard let mainImage = anotherAdImage2.imageView?.image else {return}
                guard let uploadData = mainImage.jpegData(compressionQuality: 1) else {return}
                let filename = NSUUID().uuidString
                
                let storagaRef2 = Storage.storage().reference().child("Ads_Photos").child(filename)
                storagaRef2.putData(uploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        print(err)
                    }
                    storagaRef2.downloadURL(completion: { (image2URL, err) in
                        if let err = err {
                            print(err)
                        }
                        guard let image2url = image2URL?.absoluteString else {return}
                        let creationDateImage2 = Date().timeIntervalSince1970
                        let values = ["imageUrl": image2url, "Creation_Date": creationDateImage2] as [String : Any]
                        Database.database().reference().child("Another_Ad_images").child(AnotherImagesID).childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err)
                            }
                        })
                    })
                    self.anotherAdImage2.setImage(image, for: .normal)
                    self.anotherAdImage2.isEnabled = true
                }
            }
            
            if anotherAdImage3.isEnabled == true {
                
            } else if anotherAdImage3.isEnabled == false {
                guard let mainImage = anotherAdImage3.imageView?.image else {return}
                guard let uploadData = mainImage.jpegData(compressionQuality: 1) else {return}
                let filename = NSUUID().uuidString
                
                let storagaRef3 = Storage.storage().reference().child("Ads_Photos").child(filename)
                storagaRef3.putData(uploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        print(err)
                    }
                    
                    storagaRef3.downloadURL(completion: { (image3url, err) in
                        if let err = err {
                            print(err)
                        }
                        guard let image3Url = image3url?.absoluteString else {return}
                        let creationDateImage3 = Date().timeIntervalSince1970
                        let values = ["imageUrl": image3Url, "Creation_Date": creationDateImage3] as [String : Any]
                        Database.database().reference().child("Another_Ad_images").child(AnotherImagesID).childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err)
                            }
                        })
                    })
                    self.anotherAdImage3.setImage(image, for: .normal)
                    self.anotherAdImage3.isEnabled = true
                }
            }
            
            if anotherAdImage4.isEnabled == true {
                
            } else if anotherAdImage4.isEnabled == false {
                
                guard let mainImage = anotherAdImage4.imageView?.image else {return}
                guard let uploadData = mainImage.jpegData(compressionQuality: 1) else {return}
                let filename = NSUUID().uuidString
                
                let storagaRef4 = Storage.storage().reference().child("Ads_Photos").child(filename)
                storagaRef4.putData(uploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        print(err)
                    }
                    
                    storagaRef4.downloadURL(completion: { (image4url, err) in
                        if let err = err {
                            print(err)
                        }
                        guard let image4Url = image4url?.absoluteString else {return}
                        let creationDateImage4 = Date().timeIntervalSince1970
                        let values = ["imageUrl": image4Url, "Creation_Date": creationDateImage4] as [String : Any]
                        Database.database().reference().child("Another_Ad_images").child(AnotherImagesID).childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err)
                            }
                        })
                    })
                    self.anotherAdImage4.setImage(image, for: .normal)
                    self.anotherAdImage4.isEnabled = true
                }
            }
            
            if anotherAdImage5.isEnabled == true {
                
            } else if anotherAdImage5.isEnabled == false {
                
                guard let mainImage = anotherAdImage5.imageView?.image else {return}
                guard let uploadData = mainImage.jpegData(compressionQuality: 1) else {return}
                let filename = NSUUID().uuidString
                
                let storagaRef5 = Storage.storage().reference().child("Ads_Photos").child(filename)
                storagaRef5.putData(uploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        print(err)
                    }
                    storagaRef5.downloadURL(completion: { (image5url, err) in
                        if let err = err {
                            print(err)
                        }
                        guard let image5Url = image5url?.absoluteString else {return}
                        let creationDateImage5 = Date().timeIntervalSince1970
                        let values = ["imageUrl": image5Url, "Creation_Date": creationDateImage5] as [String : Any]
                        Database.database().reference().child("Another_Ad_images").child(AnotherImagesID).childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err)
                            }
                        })
                    })
                    self.anotherAdImage5.setImage(image, for: .normal)
                    self.anotherAdImage5.isEnabled = true
                }
            }
        }
    }
}
