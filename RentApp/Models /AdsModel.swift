//
//  AdsModel.swift
//  RentApp
//
//  Created by Егор Бамбуров on 30/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import Foundation

struct Ads {
    var id: String?
    
    let mainImageUrl: String
    let objectType: String
    let dealType: String
    let city: String
    let neigborhood: String
    let square: String
    let cost: String
    let anotherAdsImages: String
    let discription: String
    let creatorUid : String
    let creationDate : Date
    let isModerated : String
    let isFutured: String
    
    init(dictionary: [String: Any]) {
        self.mainImageUrl = dictionary["Main_image_URl"] as? String ?? ""
        self.city = dictionary["City"] as? String ?? ""
        self.dealType = dictionary["Deal_type"] as? String ?? ""
        self.neigborhood = dictionary["Neighborhood"] as? String ?? ""
        self.objectType = dictionary["Objetc"] as? String ?? ""
        self.square = dictionary["Square"] as? String ?? ""
        self.cost = dictionary["Cost"] as? String ?? ""
        self.anotherAdsImages = dictionary["Another_Images"] as? String ?? ""
        self.discription = dictionary["Discription"] as? String ?? ""
        self.creatorUid = dictionary["Creators_Uid"] as? String ?? ""
        self.isModerated = dictionary["isModerated"] as? String ?? ""
        self.isFutured = dictionary["isFeatured"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["Creation_Date"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
