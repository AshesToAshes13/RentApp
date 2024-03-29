//
//  UserProfile.swift
//  RentApp
//
//  Created by Егор Бамбуров on 11/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase




class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.tintColor = UIColor.black
        setupLogOutButton()
        updateAds()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleUpdateAds), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserAdsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    @objc func handleUpdateAds() {
        updateAds()
        ads.removeAll()
    }
    
    func updateAds() {
        fetchAds()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserAdsCell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход", style: .done, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    var ads = [Ads]()
    func fetchAds() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("All_Ads").child(uid)
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
        }) { (err) in
            print(err)
        }
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        present(alertController, animated: true, completion: nil)
        alertController.addAction(UIAlertAction(title: "Выход", style: .destructive, handler: { (_) in
            do{
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            } catch let singOutErr {
                print("Failed to singout", singOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
            print(321)
        }))
    }
    
}
