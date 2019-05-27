//
//  ChatController.swift
//  RentApp
//
//  Created by Егор Бамбуров on 11/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UICollectionViewController,UICollectionViewDelegateFlowLayout, chatConttrollerCellDelegate {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        navigationItem.title = "Сообщения"
        collectionView.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 2)
        navigationController?.navigationBar.tintColor = UIColor.black
        collectionView.register(ChatControllerCell.self, forCellWithReuseIdentifier: cellId)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleReload), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        setUpMessages()
    }
    
    @objc func handleReload() {
        messagesDictionary.removeAll()
        messages.removeAll()
        setUpMessages()
    }
    
    func setUpMessages() {
        fetchUserMessages()
    }
    var messages = [Messages]()
    var messagesDictionary = [String: Messages]()
    var timer: Timer?
    
    func fetchUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("user_messages").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshoot) in
            
            guard let dic = snapshoot.value as? [String: Any] else {return}
            dic.forEach({ (key, value) in
                let messagesId = key
                let messagesRef = Database.database().reference().child("messages").child(messagesId)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshoot) in
                    guard let dictionaries = snapshoot.value as? [String: Any] else {return}
                    var messages = Messages(dictionary: dictionaries)
                    messages.id = messagesId
                    guard let toId = messages.chatPartneId() else {return}
                    self.messagesDictionary[toId] = messages
                    self.messages = Array(self.messagesDictionary.values)
                    
                    self.messages.sort(by: { (m1, m2) -> Bool in
                        print("1", m1)
                        print("2", m2)
                        return m1.creationDate.compare(m2.creationDate) == .orderedDescending
                    })
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.handleReloadView), userInfo: nil, repeats: false)
                    
                }, withCancel: nil)
            })
        }, withCancel: nil)
    }
    
    @objc func handleReloadView() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatControllerCell
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.delegate = self
        cell.messages = messages[indexPath.item]
        return cell
    }
    
    func didTapShowChatLog(messages: Messages) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.messages = messages
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 4, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
