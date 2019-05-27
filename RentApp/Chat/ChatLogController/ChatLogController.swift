//
//  ChatLogController.swift
//  RentApp
//
//  Created by Егор Бамбуров on 16/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

extension UICollectionViewController {
    func handleDismiss() {
        let Tap: UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(hadleDismissKeyboard))
        collectionView.addGestureRecognizer(Tap)
    }
    
    @objc func hadleDismissKeyboard() {
        collectionView.endEditing(true)
    }
}
//ошибка в съезжающихся
class ChatLogController : UICollectionViewController, UICollectionViewDelegateFlowLayout , UITextViewDelegate {
    
    var users: Users?
    
    var messages: Messages?
    
    let cellId = "cellId"
    
    func setupDataIfUsernameIsNil() {
        if users?.userName != nil {
            navigationItem.title = users?.userName
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let userMessagesRef = Database.database().reference().child("user_messages").child(uid)
            userMessagesRef.observe(.childAdded) { (snapshoot) in
                let messageId = snapshoot.key
                let messagesRef = Database.database().reference().child("messages").child(messageId)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String : Any] else {return}
                    var messag = Messages(dictionary: dictionary)
                    messag.id = messageId
                    if messag.chatPartneId() == self.users?.id {
                        self.message.append(messag)
                        self.message.sort(by: { (m1, m2) -> Bool in
                            return m2.creationDate.compare(m1.creationDate) == .orderedDescending
                        })
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            }
        } else {
            guard let uid = messages?.chatPartneId() else {return}
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshoot) in
                let dictionary = snapshoot.value as? [String: Any]
                guard let userName = dictionary?["userName"] as? String else {return}
                self.navigationItem.title = userName
            }) { (err) in
                print(err)
            }
        }
    }
    var message = [Messages]()
    func fetchMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let usermessagesRef = Database.database().reference().child("user_messages").child(uid)
        usermessagesRef.observe(.childAdded, with: { (snapshoot) in
            let messageId = snapshoot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                var message = Messages(dictionary: dictionary)
                message.id = messageId
                if message.chatPartneId() == self.messages?.chatPartneId() {
                    self.message.append(message)
                    self.message.sort(by: { (m1, m2) -> Bool in
                        return m2.creationDate.compare(m1.creationDate) == .orderedDescending
                    })
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tabBarController?.tabBar.isHidden = true
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatLogControllerCell.self, forCellWithReuseIdentifier: cellId)
        setupDataIfUsernameIsNil()
        setUpMessages()
        self.handleDismiss()
        
    }
    
    
    
    
    func handleUpdate() {
        message.removeAll()
        setUpMessages()
    }
    
    func setUpMessages() {
        fetchMessages()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogControllerCell
        let message = self.message[indexPath.item]
        cell.messages = message
        cell.bubbleWidthAnchor?.constant = estimatetFrameForText(text: message.text).width + 32
        setupCell(cell: cell, message: message)
        return cell
    }
    
    func setupCell(cell: ChatLogControllerCell, message: Messages) {
        DispatchQueue.main.async {
            if message.fromId == Auth.auth().currentUser?.uid {
                cell.bubbleView.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
                cell.bubbleRightAnchor?.isActive = true
                cell.userPrfileImageView.isHidden = true
            } else {
                cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
                cell.messagesTextView.textColor = UIColor.black
                cell.bubbleLeftAnchor?.isActive = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = view.frame.width
            var height: CGFloat = 80
            let text = message[indexPath.item].text
            height = estimatetFrameForText(text: text).height + 28
            return CGSize(width: width, height: height)
        
    }
    
    private func estimatetFrameForText(text: String) -> CGRect{
       let size = CGSize(width: 200, height: 1000)
       let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
       return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    lazy var containerView: MessageInputAccessoryVIew = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let messageImputAccessoryView = MessageInputAccessoryVIew(frame: frame)
        messageImputAccessoryView.users = users
        messageImputAccessoryView.messages = messages
        return messageImputAccessoryView
    }()
    
    override var inputAccessoryView: UIView? {
        get { return containerView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false 
    }
}
