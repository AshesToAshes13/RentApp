//
//  VipAdsCell.swift
//  RentApp
//
//  Created by Егор Бамбуров on 14/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class VipAdsCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 60, paddingRight: 0, width: 0, height: 0)
        setupLabels()
        setupSeparatorsInCell()
        
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.red
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let objectLabel: UILabel = {
        let label = UILabel()
        label.text = "Офис/Квартиру"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let dealLabel: UILabel = {
        let label = UILabel()
        label.text = "Сдать/Купить"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "8000000"
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func setupLabels() {
        let stackView = UIStackView(arrangedSubviews: [dealLabel, objectLabel, priceLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 4, paddingBottom: 2, paddingRight: 0, width: 180, height: 0)
    }
    
    func setupSeparatorsInCell() {
        
        let photoSeparator = UIView()
        photoSeparator.backgroundColor = UIColor.lightGray
        
        addSubview(photoSeparator)
        
        photoSeparator.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
