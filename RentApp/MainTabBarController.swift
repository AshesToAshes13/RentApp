//
//  MainTabBarController.swift
//  RentApp
//
//  Created by Егор Бамбуров on 11/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let logincontroller = LoginController()
                let navControoler = UINavigationController(rootViewController: logincontroller)
                self.present(navControoler, animated: true, completion: nil)
            }
        }
        setUpViewControllers()
    }
    
    func setUpViewControllers() {
        
        // all ads controller
        guard let feedChosen = UIImage(named: "feed_chosen") else {return}
        guard let feedUnchosen = UIImage(named: "feed_unchosen") else {return}
        let allAdsNavController = templaeteNavController(selectedImage: feedChosen, unselectedImage: feedUnchosen, rootViewController: AllAdsController(collectionViewLayout: UICollectionViewFlowLayout()))
        // featured ads controller
        guard let starChosen = UIImage(named: "StarSelected1") else {return}
        guard let starUnchosen = UIImage(named: "StarUnSelected") else {return}
       let featuredAdsNavController = templaeteNavController(selectedImage: starChosen, unselectedImage: starUnchosen, rootViewController: FeaturedAdsController(collectionViewLayout: UICollectionViewFlowLayout()))
        // chat controller
        guard let chatButtonChosen = UIImage(named: "СhatButtonSellected") else {return}
        guard let chatButtonUnchosen = UIImage(named: "СhatButtonUnSellected") else {return}
        let chatNavController = templaeteNavController(selectedImage: chatButtonChosen, unselectedImage: chatButtonUnchosen, rootViewController: ChatController(collectionViewLayout: UICollectionViewFlowLayout()))
        // create ads controller
        guard let plusChosen = UIImage(named: "plus_unselected") else {return}
        guard let plusUnChosen = UIImage(named: "plus_unselected") else {return}
        let createAdsNavController = templaeteNavController(selectedImage: plusChosen, unselectedImage: plusUnChosen, rootViewController: CreateAdsController(collectionViewLayout: UICollectionViewFlowLayout()))
        // profile controller
        guard let profileChosen = UIImage(named: "profile_selected") else {return}
        guard let profileUnchosen = UIImage(named: "profile_unselected") else {return}
        let userProfileNavController = templaeteNavController(selectedImage: profileChosen, unselectedImage: profileUnchosen, rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.tintColor = UIColor.black
        viewControllers = [allAdsNavController,
                           featuredAdsNavController,
                           createAdsNavController,
                           chatNavController,
                           userProfileNavController]
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templaeteNavController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
