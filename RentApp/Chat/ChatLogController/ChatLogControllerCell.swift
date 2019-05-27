//
//  ChatLogControllerCell.swift
//  RentApp
//
//  Created by Егор Бамбуров on 17/02/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class ChatLogControllerCell: UICollectionViewCell {
    
    var messages: Messages? {
        didSet {
            messagesTextView.text = messages?.text
            if messages?.fromId == Auth.auth().currentUser?.uid { } else {
                guard let uid = messages?.fromId else {return}
                let userRef = Database.database().reference().child("users").child(uid)
                userRef.observeSingleEvent(of: .value, with: { (snapshoot) in
                    let dictionary = snapshoot.value as? [String: Any]
                    guard let imageProfileUrl = dictionary?["profileImgaeUrl"] as? String else {return}
                    guard let url = URL(string: imageProfileUrl) else {return}
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
                        guard let data = data else {return}
                        let profileImage = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.userPrfileImageView.image = profileImage
                        }
                    }).resume()
                }, withCancel: nil)
                
            }
        }
    }
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(bubbleView)
        addSubview(messagesTextView)
        addSubview(userPrfileImageView)
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.height)
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4)
        bubbleRightAnchor?.isActive = false
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: userPrfileImageView.rightAnchor, constant: 2)
        bubbleLeftAnchor?.isActive = false
        messagesTextView.anchor(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        messagesTextView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 0).isActive = true
//        messagesTextView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 0).isActive = true
//        messagesTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 0).isActive = true
        messagesTextView.heightAnchor.constraint(lessThanOrEqualTo: bubbleView.heightAnchor).isActive = true
        
        userPrfileImageView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 2, paddingBottom: 2, paddingRight: 0, width: 32, height: 32)
    }
    
    let messagesTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.white
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let userPrfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 32/2
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
