//
//  SearchContainerView.swift
//  RentApp
//
//  Created by Егор Бамбуров on 22/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit

class SearchContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.red
        
    }
    
    let searchButton: UIButton = {
        
        return btn
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
