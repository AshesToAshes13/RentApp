//
//  UserProfileHeader.swift
//  RentApp
//
//  Created by Егор Бамбуров on 11/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase


class UserProfileHeader: UICollectionViewCell , UITextViewDelegate{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTextField()
        fetchUser()
        backgroundColor = UIColor.white
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = UIColor.lightGray
        addSubview(bottomSeparator)
        bottomSeparator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0.5)
        nameLabel.delegate = self
        emailLabel.delegate = self
        phoneNumberLabel.delegate  = self
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    let nameLabel: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.tintColor = UIColor.black
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.layer.borderWidth = 0
        return tv
    }()
    
    let emailLabel: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.tintColor = UIColor.black
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.layer.borderWidth = 0
        return tv
    }()
    
    let phoneNumberLabel: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.tintColor = UIColor.black
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.layer.borderWidth = 0
        return tv
    }()
    
    lazy var editButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Изменить", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        return btn
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 90 / 2
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    @objc func handleEditProfile() {
        if case editButton.titleLabel?.text = "Изменить" {
        nameLabel.isEditable = true
            nameLabel.layer.borderWidth = 0.5
        emailLabel.isEditable = true
            emailLabel.layer.borderWidth = 0.5
        phoneNumberLabel.isEditable = true
            phoneNumberLabel.layer.borderWidth = 0.5
            
        editButton.setTitle("Сохранить", for: .normal)
        } else if case editButton.titleLabel?.text = "Сохранить" {
            nameLabel.isEditable = false
            nameLabel.layer.borderWidth = 0
            emailLabel.isEditable = false
            emailLabel.layer.borderWidth = 0
            phoneNumberLabel.isEditable = false
            phoneNumberLabel.layer.borderWidth = 0
            editButton.setTitle("Изменить", for: .normal)
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let email = emailLabel.text else {return}
            guard let phoneNumber = phoneNumberLabel.text else {return}
            guard let userName = nameLabel.text else {return}
            let userValues = ["email": email, "phoneNumber": phoneNumber, "userName": userName]
            Database.database().reference().child("users").child(uid).updateChildValues(userValues)
        }
    }
    
    func setUpTextField() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel, phoneNumberLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        
        addSubview(stackView)
        addSubview(profileImageView)
        addSubview(editButton)
        editButton.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 250, height: 30)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 90, height: 90)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 200, height: 90)
        
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: Any]
            guard let userName = dictionary?["userName"] as? String else {return}
            guard let email = dictionary?["email"] as? String else {return}
            guard let phoneNumber = dictionary?["phoneNumber"] as? String else {return}
            guard let imageProfileUrl = dictionary?["profileImgaeUrl"] as? String else {return}
            guard let url = URL(string: imageProfileUrl) else {return}
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
                guard let data = data else {return}
                let profileImage = UIImage(data: data)
                DispatchQueue.main.async {
                    self.profileImageView.image = profileImage
                    self.nameLabel.text = userName
                    self.emailLabel.text = email
                    self.phoneNumberLabel.text = phoneNumber
                }
            }).resume()
            
        }) { (err) in
            print("Failed to fetch", err)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Lol")
    }
}
