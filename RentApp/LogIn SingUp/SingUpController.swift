//
//  ViewController.swift
//  RentApp
//
//  Created by Егор Бамбуров on 10/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class SingUpController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.white
        setupInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        emailTextField.delegate = self
        phoneTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        let atrributedTitle = NSMutableAttributedString(string: "Уже зарагистрированны?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        atrributedTitle.append(NSAttributedString(string: "Войдите", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        btn.setAttributedTitle(atrributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleAlreadyHaveAccount() {
        let logInController = LoginController()
        navigationController?.pushViewController(logInController, animated: true)
    }
    
    let dismissContainer: UIView = {
        let cont = UIView()
        cont.backgroundColor = UIColor.red
        
        return cont
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Номер Телефона"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .phonePad
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "Пароль"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return btn
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.isEmpty == false && (phoneTextField.text?.count)! > 10 && nameTextField.text?.isEmpty == false && (passwordTextField.text?.count)! > 7
        if isFormValid {
            singUpButton.isEnabled = true
            singUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            singUpButton.isEnabled = false
            singUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let singUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Зарегестрироваться", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(handleSingup), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    @objc func handleSingup() {
        guard let email = emailTextField.text, !email.isEmpty else {return}
        guard let password = passwordTextField.text, !password.isEmpty else {return}
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {return}
        guard let userName = nameTextField.text , !userName.isEmpty else {return}
        guard let profileImage = self.plusPhotoButton.imageView?.image else {return}
        guard let uploadData = profileImage.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        
        Auth.auth().createUser(withEmail: email, password: password) { (user , error: Error?) in
            if let err = error {
                print("Failed", err)
                return
            }
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                storageRef.downloadURL(completion: { (downloadUrl, err) in
                    guard let profileImgaeUrl = downloadUrl?.absoluteString else {return}
                    guard let uid = user?.user.uid else {return}
                    let userValues = ["email": email, "phoneNumber": phoneNumber, "userName": userName, "profileImgaeUrl": profileImgaeUrl, "isModerator": "0"]
                    let values = [uid : userValues]
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to add user to db", err)
                            return
                        }
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        mainTabBarController.setUpViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, phoneTextField, nameTextField, passwordTextField, singUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20
            , paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 250)
    }
}

