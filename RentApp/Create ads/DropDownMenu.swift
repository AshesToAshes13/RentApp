//
//  DropDownMenu.swift
//  RentApp
//
//  Created by Егор Бамбуров on 20/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit

class DropDownMenu: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.setTitle("Город", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
