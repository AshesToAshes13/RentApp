//
//  ModeratingController.swift
//  RentApp
//
//  Created by Егор Бамбуров on 09/02/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase


class ModeratingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        navigationItem.title = "Модерация"
        updateAds()
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        navigationController?.navigationBar.tintColor = UIColor.black
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleUpdateAds), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.register(ModeratingAdsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    @objc func handleUpdateAds() {
        updateAds()
        ads.removeAll()
    }
    
    func updateAds() {
        fetchAds()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ModeratingAdsCell
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
    
    var ads = [Ads]()
    func fetchAds() {
        Database.database().reference().child("users").observeSingleEvent(of: .value) { (snapshoot) in
            guard let dictionaries = snapshoot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
               let userId = key
                
                let ref = Database.database().reference().child("All_Ads").child(userId)
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
                    self.collectionView?.reloadData()
                }) { (err) in
                    print(err)
                }
            })
        }
    }
}
