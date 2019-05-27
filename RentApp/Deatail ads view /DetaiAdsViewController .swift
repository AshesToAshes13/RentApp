//
//  DetaiAdsViewController .swift
//  RentApp
//
//  Created by Егор Бамбуров on 16/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase


class DetailAdsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let imageCellId = "imageCellId"
    let cellId2 = "cellId2"
    var ads: Ads? {
        didSet {
            let dealType = "Сдать"
            if case dealType = ads?.dealType {
                costTextView.text = (ads?.cost)! + " ₽ в месяц"
            } else {
                costTextView.text = (ads?.cost)! + " ₽"
            }
            objectTextView.text = ads?.objectType
            dealTextView.text = ads?.dealType
            cityTextView.text = ads?.city
            neighborhoodTextView.text = ads?.neigborhood
            squareTextView.text = (ads?.square)! + " кв/м"
            discriptionTextView.text = ads?.discription
            fetchUser()
        }
    }
    var users = [Users]()
    func fetchUser() {
        guard let uid = ads?.creatorUid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshoot) in
            guard let dictionaries = snapshoot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
                var users = Users(dictionary: dictionaries)
                users.id = uid
                self.creatorName.text = "Имя:" + users.userName
                self.creatorPhoneNumber.text = "Номер:" + users.phoneNumber
                self.users.append(users)
            })
        }) { (err) in
            print(err)
        }
    }
    
    var messages: Messages?
    
    func setUpBtn() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: Any]
            guard let isModerator = dictionary?["isModerator"] as? String else {return}
            let moderator = "1"
            if case isModerator = moderator {
                self.acceptButton.isHidden = false
                self.cancelButton.isHidden = false
            } else  {
                if case uid = self.ads?.creatorUid {
                    self.setDeleteAdsButton()
                    self.changeAdsValueButton.isHidden = false
                    
                    let onModerated = "0"
                    let successfullModerated = "1"
                    let unSuccessfullModerated = "2"
                    if case onModerated = self.ads?.isModerated {
                        self.moderatingStateLabel.text = "Объявление на модерации."
                        self.moderatingStateLabel.isHidden = true
                        self.changeAdsValueButton.backgroundColor = UIColor.white
                        self.changeAdsValueButton.isEnabled = false
                        self.changeAdsValueButton.titleLabel?.textColor = UIColor.lightGray
                    }
                    if case successfullModerated = self.ads?.isModerated {
                        self.moderatingStateLabel.text = "Объявление прошло модерацию."
                        self.moderatingStateLabel.isHidden = true
                        self.changeAdsValueButton.backgroundColor = UIColor.init(red: 0/255, green: 255/255, blue:0/255 , alpha: 0.1)
                        
                    }
                    if case unSuccessfullModerated = self.ads?.isModerated {
                        self.moderatingStateLabel.text = "Объявление не прошло модерацию, удалите объявление."
                        self.moderatingStateLabel.isHidden = true
                        self.changeAdsValueButton.backgroundColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.1)
                        self.changeAdsValueButton.isEnabled = false
                    }
                } else {
                    self.setAdToFeatureButton()
                    self.startChatButton.isHidden = false
                    let inFutured = "1"
                    if case inFutured = self.ads?.isFutured {
                        self.setDeleteFromFeatureButton()
                    }

                }
            }
            
        }) { (err) in
            print("Failed to fetch", err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        collectionView.register(PhotoCellForDetailViewController.self, forCellWithReuseIdentifier: imageCellId)
        navigationItem.title = "Объявление"
        setUpBtn()
        ifValueEqualToNil()
        fetchUser()
        let objectAndDealStackView = UIStackView(arrangedSubviews: [objectTextView, dealTextView])
        objectAndDealStackView.axis = .horizontal
        objectAndDealStackView.spacing = 4
        objectAndDealStackView.distribution = .fillEqually
        
        let cityAndNeigborhoodStackView = UIStackView(arrangedSubviews: [cityTextView, neighborhoodTextView])
        cityAndNeigborhoodStackView.axis = .horizontal
        cityAndNeigborhoodStackView.spacing = 4
        cityAndNeigborhoodStackView.distribution = .fillEqually
        
        let squareTextViewAndLabelStackView = UIStackView(arrangedSubviews: [squareTextView,squareLabel])
        squareTextViewAndLabelStackView.axis = .horizontal
        squareTextViewAndLabelStackView.spacing = 2
        squareTextViewAndLabelStackView.distribution = .fillEqually
        
        let costLabelAndTextViewStackView = UIStackView(arrangedSubviews: [costTextView,costLabel])
        costLabelAndTextViewStackView.axis = .horizontal
        costLabelAndTextViewStackView.spacing = 2
        costLabelAndTextViewStackView.distribution = .fillEqually
        
        let costAndSquareStackView = UIStackView(arrangedSubviews: [squareTextView,costTextView])
        costAndSquareStackView.axis = .horizontal
        costAndSquareStackView.spacing = 4
        costAndSquareStackView.distribution = .fillEqually
        
        let textDataStackView = UIStackView(arrangedSubviews: [objectAndDealStackView,cityAndNeigborhoodStackView,costAndSquareStackView])
        textDataStackView.axis = .vertical
        textDataStackView.spacing = 4
        textDataStackView.distribution = .fillEqually
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, creatorName])
        nameStackView.axis = .horizontal
        nameStackView.spacing = -1
        nameStackView.distribution = .fill
        
        let numberStackView = UIStackView(arrangedSubviews: [phoneNumberLabel, creatorPhoneNumber])
        numberStackView.axis = .horizontal
        numberStackView.spacing = -1
        numberStackView.distribution = .fill
        
        let nameAndNumberStackView = UIStackView(arrangedSubviews: [creatorName,creatorPhoneNumber])
        nameAndNumberStackView.axis = .horizontal
        nameAndNumberStackView.spacing = 4
        nameAndNumberStackView.distribution = .fillEqually
        
        collectionView.addSubview(imageSeparator)
        collectionView.addSubview(textDataStackView)
        collectionView.addSubview(textDataSeparator)
        collectionView.addSubview(discriptionTextView)
        collectionView.addSubview(discriptionSeparator)
        collectionView.addSubview(nameAndNumberStackView)
        collectionView.addSubview(userDataSeparator)
        collectionView.addSubview(startChatButton)
        collectionView.addSubview(changeAdsValueButton)
        collectionView.addSubview(acceptButton)
        collectionView.addSubview(cancelButton)
        collectionView.addSubview(moderatingStateLabel)
        imageSeparator.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 250, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0.5)
        textDataStackView.anchor(top: imageSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: view.frame.width - 8, height: 113)
        textDataSeparator.anchor(top: textDataStackView.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0.5)
        discriptionTextView.anchor(top: textDataSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: view.frame.width - 8, height: 80)
        discriptionSeparator.anchor(top: discriptionTextView.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0.5)
        nameAndNumberStackView.anchor(top: discriptionSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: view.frame.width - 8, height: 30)
        userDataSeparator.anchor(top: nameAndNumberStackView.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0.5)
        startChatButton.anchor(top: userDataSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 6, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: collectionView.frame.width - 50 , height: 40)
        changeAdsValueButton.anchor(top: userDataSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 6, paddingLeft: 25, paddingBottom: 6, paddingRight: 25, width: collectionView.frame.width - 50, height: 40)
        moderatingStateLabel.anchor(top: userDataSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 2, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: collectionView.frame.width - 50, height: 20)
        acceptButton.anchor(top: userDataSeparator.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 2, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: collectionView.frame.width - 50, height: 25)
        cancelButton.anchor(top: acceptButton.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 2, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: collectionView.frame.width - 50, height: 25)
    }
    

    let objectTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()

    
    let dealTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let cityTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let neighborhoodTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let costTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = "₽"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let moderatingStateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    let squareTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let squareLabel: UILabel = {
        let label = UILabel()
        label.text = "кв/м"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let discriptionTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        return tv
    }()
    
    let creatorName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя: "
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let creatorPhoneNumber: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер: "
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let imageSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let textDataSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let discriptionSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let userDataSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let startChatButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Написать сообщение", for: .normal)
        btn.addTarget(self, action: #selector(handleStartChat), for: .touchUpInside)
        btn.tintColor = UIColor.black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.isHidden = true
        return btn
    }()
    
    let changeAdsValueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Изменить", for: .normal)
        btn.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
        btn.tintColor = UIColor.black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.isHidden = true
        return btn
    }()
    
    
    let acceptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Разрешить", for: .normal)
        btn.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        btn.tintColor = UIColor.black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.isHidden = true
        return btn
    }()
    
    @objc func handleAccept() {
        guard let adId = ads?.id else {return}
        guard let uid = ads?.creatorUid else {return}
        let creationDate = Date().timeIntervalSince1970
        let values = ["Main_image_URl": ads?.mainImageUrl as Any, "Creators_Uid": ads?.creatorUid as Any, "Objetc": ads?.objectType as Any, "Deal_type": ads?.dealType as Any, "City": ads?.city as Any, "Neighborhood": ads?.neigborhood as Any, "Square": ads?.square as Any, "Cost": ads?.cost as Any, "Discription": ads?.discription as Any,"Another_Images": ads?.anotherAdsImages as Any, "Creation_Date": creationDate] as [String : Any]
        Database.database().reference().child("Ads").child(adId).updateChildValues(values) { (err, reff) in
            if let err = err {
                print(err)
            }
            let isModerated = "1"
            let value = ["isModerated": isModerated]
            Database.database().reference().child("All_Ads").child(uid).child(adId).updateChildValues(value, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print(err)
                }
            })
        }
    }
    
    let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Запретить", for: .normal)
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        btn.tintColor = UIColor.black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.isHidden = true
        return btn
    }()
    
    @objc func handleCancel() {
        guard let adId = ads?.id else {return}
        guard let uid = ads?.creatorUid else {return}
        let isModerated = "2"
        let value = ["isModerated": isModerated]
        Database.database().reference().child("All_Ads").child(uid).child(adId).updateChildValues(value, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
            }
        })
    }
    
    func setAdToFeatureButton() {
        guard let image = UIImage(named: "StarUnSelected")?.withRenderingMode(.alwaysOriginal) else {return}
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(hadleAdTofeatured))
    }
    
    @objc func hadleAdTofeatured() {
        print("Truing to ad to featured ads")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let AdId = ads?.id else {return}
        let creationDate = Date().timeIntervalSince1970
        let values = ["Main_image_URl": ads?.mainImageUrl as Any, "Creators_Uid": ads?.creatorUid as Any, "Objetc": ads?.objectType as Any, "Deal_type": ads?.dealType as Any, "City": ads?.city as Any, "Neighborhood": ads?.neigborhood as Any, "Square": ads?.square as Any, "Cost": ads?.cost as Any, "Discription": ads?.discription as Any,"Another_Images": ads?.anotherAdsImages as Any, "Creation_Date": creationDate, "isFeatured": "1"] as [String : Any]
        Database.database().reference().child("Feature_ads").child(uid).child(AdId).updateChildValues(values) { (err, ref) in
            if let err = err {
                print(err)
            }
            
        }
    }
    
    func setDeleteFromFeatureButton() {
        guard let image = UIImage(named: "StarSelected2")?.withRenderingMode(.alwaysOriginal) else {return}
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleRemoveFromFuture))
    }
    
    @objc func handleRemoveFromFuture() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let adId = ads?.id else {return}
        Database.database().reference().child("Feature_ads").child(uid).child(adId).removeValue()
    }
    
    func setDeleteAdsButton() {
        guard let image = UIImage(named: "delete_button")?.withRenderingMode(.alwaysOriginal) else {return}
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(hadleDeleteAds))
    }
    
    @objc func hadleDeleteAds() {
        let alertController = UIAlertController(title: "Удалить объявление?", message: "\nВы действительно хотите удалить обявление?\n", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Удалить", style: .cancel, handler: { (_) in
            guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let AdId = self.ads?.id else {return}
            guard let AnotherImagesId = self.ads?.anotherAdsImages else {return}
            Database.database().reference().child("All_Ads").child(uid).child(AdId).removeValue { (err, ref) in
                if let err = err {
                    print(err)
                }
                Database.database().reference().child("Another_Ad_images").child(AnotherImagesId).removeValue(completionBlock: { (err, ref) in
                    if let err = err {
                        print(err)
                    }
                    Database.database().reference().child("Ads").child(AdId).removeValue()
                    Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshoot) in
                        guard let dictionaries = snapshoot.value as? [String: Any] else {return}
                        dictionaries.forEach({ (key, values) in
                            let uid = key
                            Database.database().reference().child("Feature_ads").child(uid).child(AdId).removeValue()
                        })
                    }, withCancel: { (err) in
                        print(err)
                    })
                    
                })
            }
        }))
        alertController.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleChange() {
        if case changeAdsValueButton.titleLabel?.text = "Изменить" {
            startChanging()
        } else if case changeAdsValueButton.titleLabel?.text = "Сохранить" {
            endChanging()
        }
    }
    
    func startChanging() {
        changeAdsValueButton.setTitle("Сохранить", for: .normal)
        costTextView.isEditable = true
    }
    
    func endChanging() {
        changeAdsValueButton.setTitle("Изменить", for: .normal)
        costTextView.isEditable = false
    }
    
    @objc func handleStartChat() {
        let indexPath = 1
        let chatController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.users = users[indexPath]
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! PhotoCellForDetailViewController
        cell.ads = ads
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // for se height = 568
        // for 6,7,8 height = 667
        // for 6+,7+,8+ height = 736
        // for x height = 812
        // for xs max height = 896
        // image height = 250 - 4 from frame
        let height = collectionView.frame.height
        print(height)
        return CGSize(width: collectionView.frame.width, height: 550)
    }
    
    
    func ifValueEqualToNil() {
        if case discriptionTextView.text.isEmpty = true {
            adWasDeleted()
        } else {
        }
    }
    
    func adWasDeleted() {
        let alertController = UIAlertController(title: "Объявление было удаленно!", message: "\nУдалите объявление из избанного\n", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
            // delet ads from futured if they delete from db
            }))
        present(alertController, animated: true, completion: nil)
        }
    
    
    }

