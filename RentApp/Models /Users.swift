//
//  Users.swift
//  RentApp
//
//  Created by Егор Бамбуров on 09/02/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import Foundation

struct Users {
    var id: String?
    let isModerator : String
    let userName: String
    let phoneNumber: String
    let profileImage: String
    
    init(dictionary: [String: Any]) {
        self.isModerator = dictionary["isModerator"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.profileImage = dictionary["profileImgaeUrl"] as? String ?? ""
    }
}
