//
//  AnotherAdsImagesModel.swift
//  RentApp
//
//  Created by Егор Бамбуров on 31/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import Foundation


struct AnotherImages {
    
    var id: String?
    let imageUrl: String
    let creationDate : Date
    init(dictionary: [String: Any]) {
        
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        let secondsFrom1970 = dictionary["Creation_Date"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
