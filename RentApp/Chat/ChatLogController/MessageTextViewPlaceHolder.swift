//
//  MessageTextViewPlaceHolder.swift
//  RentApp
//
//  Created by Егор Бамбуров on 17/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit

class MessageTextViewPlaceHolder: UITextView , UITextViewDelegate{
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
        label.text = "Сообщение"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
