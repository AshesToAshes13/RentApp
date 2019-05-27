//
//  AdDiscriptionTvPlaceHolder.swift
//  RentApp
//
//  Created by Егор Бамбуров on 28/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit

class AdDiscriptionTvPlaceHolder: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 5, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleTextChange() {
        placeHolderLabel.isHidden = !self.text.isEmpty
    }
    
    func showPlaceHolderLabel() {
        placeHolderLabel.isHidden = false
    }
    
    fileprivate let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавьте описание"
        label.textColor = UIColor.rgb(red: 192, green: 192, blue: 192)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
