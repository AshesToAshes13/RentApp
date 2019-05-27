//
//  PhotoCellContoller.swift
//  RentApp
//
//  Created by Егор Бамбуров on 22/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class PhotoCell: UICollectionViewCell {
    
    var anotherImages: AnotherImages? {
        didSet {
            guard let imageUrl = anotherImages?.imageUrl else {return}
            guard let url = URL(string: imageUrl) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print(err)
                }
                guard let image = data else {return}
                let imageView = UIImage(data: image)
                DispatchQueue.main.async {
                    self.adsImageView.image = imageView
                }
            }.resume()
         }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(adsImageView)
        
        adsImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 1, paddingBottom: 0, paddingRight: 1, width: 0, height: 0)
    }
    
    let adsImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
