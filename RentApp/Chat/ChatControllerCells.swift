//
//  ChatControllerCells.swift
//  RentApp
//
//  Created by Егор Бамбуров on 16/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

protocol chatConttrollerCellDelegate {
    func didTapShowChatLog(messages: Messages)
}

class ChatControllerCell: UICollectionViewCell {
    var delegate: chatConttrollerCellDelegate?
    var messages: Messages? {
        didSet {
            setUpNameAndUserProfileImage()
            lastMessageLabel.text = messages?.text
        }
    }
    
    func setUpNameAndUserProfileImage() {
        
        guard let uid = messages?.chatPartneId() else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshoot) in
        let dictionary = snapshoot.value as? [String: Any]
        guard let userName = dictionary?["userName"] as? String else {return}
        guard let userProfileImageURL = dictionary?["profileImgaeUrl"] as? String else {return}
        guard let url = URL(string: userProfileImageURL) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
        if let err = err {
        print(err)
        }
        guard let data = data else {return}
        let profileImage = UIImage(data: data)
        DispatchQueue.main.async {
        self.profileImageView.image = profileImage
        }
        }).resume()
            DispatchQueue.main.async {
                self.usernameLabel.text = userName
            }
        }) { (err) in
        print(err)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(lastMessageLabel)
        addSubview(showChatLogControllerBtn)
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 150, height: 15)
        lastMessageLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 9, paddingLeft: 4, paddingBottom: 8, paddingRight: 0, width: 150, height: 0)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 6, paddingLeft: 8, paddingBottom: 7, paddingRight: 0, width: 50, height: 0)
        showChatLogControllerBtn.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    var users = [Users]()
    func fetchUser() {
        guard let uid = messages?.toId else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshoot) in
            guard let dictionaries = snapshoot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                var users = Users(dictionary: dictionary)
                users.id = uid
                self.users.append(users)
            })
        }) { (err) in
            print(err)
        }
    }
    
    let profileImageView: UIImageView = {
       let iv = UIImageView()
       iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50/2
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.clipsToBounds = true
       return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var showChatLogControllerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(handleshowChatlogController), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleshowChatlogController() {
        guard let messages = messages else {return}
        delegate?.didTapShowChatLog(messages: messages)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
