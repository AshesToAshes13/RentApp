//
//  ModeratigAdsCell.swift
//  RentApp
//
//  Created by Егор Бамбуров on 10/02/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class ModeratingAdsCell: UICollectionViewCell {
    
    var ads: Ads? {
        didSet {
            guard let mainImageUrl = ads?.mainImageUrl else {return}
            guard let url = URL(string: mainImageUrl) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print(err)
                    return
                }
                guard let mainImageData = data else {return}
                let mainImage = UIImage(data: mainImageData)
                DispatchQueue.main.async {
                    let dealType = "Сдать"
                    
                    if case dealType = self.ads?.dealType {
                        self.priceLabel.text = (self.ads?.cost)! + " ₽ в месяц"
                    } else {
                        self.priceLabel.text = (self.ads?.cost)! + " ₽"
                    }
                    self.photoImageView.image = mainImage
                    self.objectLabel.text = self.ads?.objectType
                    self.dealLabel.text = self.ads?.dealType
                    self.squareLabele.text = (self.ads?.square)! + " кв/м"
                    self.cityLabel.text = self.ads?.city
                    self.neighborhoodLabel.text = self.ads?.neigborhood
                }
                }.resume()
            let onModerated = "0"
            let successfullModerated = "1"
            let unSuccessfullModerated = "2"
            if case onModerated = ads?.isModerated {
                backgroundColor = UIColor.white
            }
            if case successfullModerated = ads?.isModerated {
                backgroundColor = UIColor.init(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.1)
            }
            if case unSuccessfullModerated = ads?.isModerated {
                backgroundColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.1)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 125, paddingRight: 0, width: 0, height: 0)
        setupSeparatorsInCell()
        setupLabels()
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let objectLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let dealLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let costValueLabele: UILabel = {
        let label = UILabel()
        label.text = "₽"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let squareValueLabele: UILabel = {
        let label = UILabel()
        label.text = "кв/м"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let squareLabele: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let neighborhoodLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func setupLabels() {
        let dealAndOblectstackView = UIStackView(arrangedSubviews: [dealLabel, objectLabel])
        dealAndOblectstackView.distribution = .fillEqually
        dealAndOblectstackView.axis = .horizontal
        dealAndOblectstackView.spacing = 4
        
        let costAndCostValueStackView = UIStackView(arrangedSubviews: [priceLabel, costValueLabele])
        costAndCostValueStackView.distribution = .fillEqually
        costAndCostValueStackView.axis = .horizontal
        costAndCostValueStackView.spacing = 0
        
        let squareAndSquareValueStackView = UIStackView(arrangedSubviews: [squareLabele, squareValueLabele])
        squareAndSquareValueStackView.distribution = .fillEqually
        squareAndSquareValueStackView.axis = .horizontal
        squareAndSquareValueStackView.spacing = 0
        
        let costAndSquareStackView = UIStackView(arrangedSubviews: [costAndCostValueStackView, squareAndSquareValueStackView])
        costAndSquareStackView.distribution = .fillEqually
        costAndSquareStackView.axis = .horizontal
        costAndSquareStackView.spacing = 4
        
        let cityAndNeighborhoodStackView = UIStackView(arrangedSubviews: [cityLabel, neighborhoodLabel])
        cityAndNeighborhoodStackView.distribution = .fillEqually
        cityAndNeighborhoodStackView.axis = .horizontal
        cityAndNeighborhoodStackView.spacing = 4
        
        let allDataStackView = UIStackView(arrangedSubviews: [dealLabel, objectLabel, priceLabel, squareLabele, cityLabel, neighborhoodLabel])
        allDataStackView.distribution = .fillEqually
        allDataStackView.axis = .vertical
        allDataStackView.spacing = 4
        
        addSubview(allDataStackView)
        allDataStackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        
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
