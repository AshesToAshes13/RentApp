//
//  MessageInputAccessoryVIew.swift
//  RentApp
//
//  Created by Егор Бамбуров on 17/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase



class MessageInputAccessoryVIew: UIView , UITextViewDelegate {
    var users: Users?
    var messages: Messages?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        autoresizingMask = .flexibleHeight
        
        addSubview(messageImputTextView)
        addSubview(sendButton)
        addSubview(lineSeparatorView)
        
        messageImputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 6, paddingBottom: 6, paddingRight: 54, width: 0, height: 0)
        sendButton.anchor(top: topAnchor, left: messageImputTextView.rightAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft:0, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        messageImputTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    let messageImputTextView: MessageTextViewPlaceHolder = {
        let tv = MessageTextViewPlaceHolder()
        tv.layer.borderWidth = 0.5
        tv.layer.cornerRadius = 5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.isScrollEnabled = false
        tv.keyboardAppearance = UIKeyboardAppearance.dark
        return tv
    }()
    
    
    
    let lineSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleSend() {
        if users?.id != nil {
            if messageImputTextView.text.count > 0 {
                guard let text = messageImputTextView.text else {return}
                guard let toId = users?.id else {return}
                guard let fromId = Auth.auth().currentUser?.uid else {return}
                let creationDate = Date().timeIntervalSince1970
                let value = ["toId": toId, "fromId": fromId, "message_text": text, "creation_date": creationDate] as [AnyHashable: Any]
                let ref = Database.database().reference().child("messages")
                let childRef = ref.childByAutoId()
                childRef.updateChildValues(value) { (err, red) in
                    if let err = err {
                        print(err)
                    }
                    let userMessagesRef = Database.database().reference().child("user_messages").child(fromId)
                    let messageId = childRef.key
                    userMessagesRef.updateChildValues([messageId: 1])
                    let recipentUserMessagesRef = Database.database().reference().child("user_messages").child(toId)
                    recipentUserMessagesRef.updateChildValues([messageId: 1])
                    self.messageImputTextView.text = nil
                    self.messageImputTextView.showPlaceHolderLabel()
                }
            } else { }
        } else {
            if messageImputTextView.text.count > 0 {
                guard let text = messageImputTextView.text else {return}
                guard let toId = messages?.chatPartneId() else {return}
                guard let fromId = Auth.auth().currentUser?.uid else {return}
                let creationDate = Date().timeIntervalSince1970
                let value = ["toId": toId, "fromId": fromId, "message_text": text, "creation_date": creationDate] as [AnyHashable: Any]
                let ref = Database.database().reference().child("messages")
                let childRef = ref.childByAutoId()
                childRef.updateChildValues(value) { (err, red) in
                    if let err = err {
                        print(err)
                    }
                    let userMessagesRef = Database.database().reference().child("user_messages").child(fromId)
                    let messageId = childRef.key
                    userMessagesRef.updateChildValues([messageId: 1])
                    let recipentUserMessagesRef = Database.database().reference().child("user_messages").child(toId)
                    
                    recipentUserMessagesRef.updateChildValues([messageId: 1])
                    self.messageImputTextView.text = nil
                    self.messageImputTextView.showPlaceHolderLabel()
                }
            } else {}
        }
    }
    
    override var intrinsicContentSize: CGSize { return .zero }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
