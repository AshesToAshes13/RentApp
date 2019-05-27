//
//  AllAds.swift
//  RentApp
//
//  Created by Егор Бамбуров on 11/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class AllAdsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        navigationItem.title = "Объявления"
        collectionView.register(AllAdsCell.self , forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        setupNavBarItems()
        setUpForModerator()
        updateAds()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleUpdateAds), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func handleUpdateAds() {
        updateAds()
        ads.removeAll()
    }
    
    func updateAds() {
        fetchAds()
    }
    
    func setupNavBarItems() {
        let image = UIImage(named: "search_selected")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(handleShowSearch))
    }
    
    func setupLeftBarItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Модерация", style: .done, target: self, action: #selector(handlePresentModerController))
    }
    
    @objc func handlePresentModerController() {
        let moderController = ModeratingController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(moderController, animated: true)
    }
    
    func setUpForModerator() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: Any]
            guard let isModerator = dictionary?["isModerator"] as? String else {return}
            let moderator = "1"
            if case isModerator = moderator {
                self.setupLeftBarItem()
            }
            
        }) { (err) in
            print("Failed to fetch", err)
        }
    }
    
    let searchContainer: UIView = {
        let searchContainerView = UIView()
        searchContainerView.backgroundColor = UIColor.white
        return searchContainerView
    }()
    
    
    @objc func handleShowSearch() {
        view.addSubview(searchContainer)
        searchContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        searchContainer.isHidden = false
        setUpViews()
    }
    
    lazy var cityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Город"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var neighborhoodTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Район"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var objectTypeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Офис, квартира..."
        tf.backgroundColor = UIColor.white
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var dealTypeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Сдать/Продать"
        tf.backgroundColor = UIColor.white
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var costFromTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Цена от"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var costToTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Цена до"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var squareFromTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Площадь от"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var squareToTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Площадь до"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    let costTfsSeparator: UILabel = {
        let label = UILabel()
        label.text = "-"
        return label
    }()
    
    let squareTfsSeparator: UILabel = {
        let label = UILabel()
        label.text = "-"
        return label
    }()
    
    public func setUpViews() {
        let dealAndObectTfsStackView = UIStackView(arrangedSubviews: [dealTypeTextField, objectTypeTextField])
        dealAndObectTfsStackView.axis = .horizontal
        dealAndObectTfsStackView.distribution = .fillEqually
        dealAndObectTfsStackView.spacing = 5
        
        let cityAndNeighborhoodTfsStackView = UIStackView(arrangedSubviews: [cityTextField, neighborhoodTextField])
        cityAndNeighborhoodTfsStackView.axis = .horizontal
        cityAndNeighborhoodTfsStackView.distribution = .fillEqually
        cityAndNeighborhoodTfsStackView.spacing = 5
        
        let costStackView = UIStackView(arrangedSubviews: [costFromTextField,costToTextField])
        costStackView.axis = .horizontal
        costStackView.distribution = .fillEqually
        costStackView.spacing = 5
        
        let squareStackView = UIStackView(arrangedSubviews: [squareFromTextField,squareToTextField])
        squareStackView.axis = .horizontal
        squareStackView.distribution = .fillEqually
        squareStackView.spacing = 5
        
        let buttonsStackView = UIStackView(arrangedSubviews: [searchButton, cancelButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 5
        
        let stackView = UIStackView(arrangedSubviews: [dealAndObectTfsStackView,cityAndNeighborhoodTfsStackView,buttonsStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        searchContainer.addSubview(stackView)
        stackView.anchor(top: searchContainer.topAnchor, left: searchContainer.leftAnchor, bottom: searchContainer.bottomAnchor, right: searchContainer.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 15, width: 0, height: 0)
    }
    
    let searchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Поиск", for: .normal)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 5
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return btn
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Отмена", for: .normal)
        btn.backgroundColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.1)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleSearch() {
        if dealTypeTextField.text?.isEmpty == false {
            self.ads = self.ads.filter({ (ads) -> Bool in
                return ads.dealType.lowercased().contains(dealTypeTextField.text!.lowercased())
            })
        }
        if objectTypeTextField.text?.isEmpty == false {
            self.ads = self.ads.filter { (ads) -> Bool in
                return ads.objectType.lowercased().contains(objectTypeTextField.text!.lowercased())
            }
        }
        if cityTextField.text?.isEmpty == false {
            self.ads = self.ads.filter({ (ads) -> Bool in
                return ads.city.lowercased().contains(cityTextField.text!.lowercased())
            })
        }
        if neighborhoodTextField.text?.isEmpty == false {
            self.ads = self.ads.filter({ (ads) -> Bool in
                return ads.neigborhood.lowercased().contains(neighborhoodTextField.text!.lowercased())
            })
        }
        
        self.collectionView.reloadData()
        searchContainer.isHidden = true
    }
    
    @objc func handleCancel() {
        searchContainer.isHidden = true
        dealTypeTextField.text = nil
        objectTypeTextField.text = nil
        cityTextField.text = nil
        neighborhoodTextField.text = nil
        updateAds()
        ads.removeAll()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return ads.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AllAdsCell
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.ads = ads[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewAdsControoler = DetailAdsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        detailViewAdsControoler.ads = ads[indexPath.item]
        navigationController?.pushViewController(detailViewAdsControoler, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 15) / 2
        
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    var filtredAds = [Ads]()
    var ads = [Ads]()
    func fetchAds() {
                let ref = Database.database().reference().child("Ads")
                ref.observeSingleEvent(of: .value, with: { (snapshoot) in
                    self.collectionView.refreshControl?.endRefreshing()
                    guard let dictionaries = snapshoot.value as? [String: Any] else {return}
                    dictionaries.forEach({ (key, value) in
                        guard let dictionary = value as? [String: Any] else {return}
                        var ads = Ads(dictionary: dictionary)
                        ads.id = key
                        self.ads.append(ads)
                    })
                    self.ads.sort(by: { (a1, a2) -> Bool in
                        return a1.creationDate.compare(a2.creationDate) == .orderedDescending
                    })
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                })
             }
}
