//
//  ChosenImageCell.swift
//  RentApp
//
//  Created by Егор Бамбуров on 24/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Photos

class ChosenImageCell: UICollectionViewCell {
    
    lazy var imageManager = {return PHCachingImageManager()}
    var assets = [PHAsset]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
