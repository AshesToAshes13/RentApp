//
//  Messages.swift
//  RentApp
//
//  Created by Егор Бамбуров on 15/02/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import Foundation
import Firebase

struct Messages {
    
    var id: String?
    
    let toId: String
    let fromId: String
    let text: String
    let creationDate : Date
    
    func chatPartneId() -> String? { return fromId == Auth.auth().currentUser?.uid ? toId : fromId }
    
    init(dictionary: [String: Any]) {
        
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.text = dictionary["message_text"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creation_date"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
