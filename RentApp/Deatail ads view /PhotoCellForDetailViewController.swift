//
//  PhotoCellForDetailViewController.swift
//  RentApp
//
//  Created by Егор Бамбуров on 16/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase


class PhotoCellForDetailViewController: UICollectionViewCell , UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var anotherAdsImages = [AnotherImages]()
    var ads: Ads? {
        didSet {
            guard let anotherImagesID = ads?.anotherAdsImages else {return}
            let ref = Database.database().reference().child("Another_Ad_images").child(anotherImagesID)
            ref.observeSingleEvent(of: .value, with: { (snapshoot) in
                guard let dictionaries = snapshoot.value as? [String: Any] else {return}
                dictionaries.forEach({ (key, value) in
                    guard let dictionary = value as? [String: Any] else {return}
                    var anotherAdsImages = AnotherImages(dictionary: dictionary)
                    anotherAdsImages.id = key
                    self.anotherAdsImages.append(anotherAdsImages)
                })
                self.anotherAdsImages.sort(by: { (ai1, ai2) -> Bool in
                    ai1.creationDate.compare(ai2.creationDate) == .orderedDescending
                })
                self.photosCollectionView.reloadData()
            }) { (err) in
                print(err)
            }
        }
    }
    
    let photoCellId = "photoCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: photoCellId)
        addSubview(photosCollectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[v0]-4-|", options: NSLayoutConstraint.FormatOptions() , metrics: nil, views: ["v0" : photosCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v0]-304-|", options: NSLayoutConstraint.FormatOptions() , metrics: nil, views: ["v0" : photosCollectionView]))
        
    }
    
    let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anotherAdsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellId, for: indexPath) as! PhotoCell
        cell.anotherImages = anotherAdsImages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
