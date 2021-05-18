//
//  NumberButton.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/10.
//

import UIKit

@IBDesignable
class NumberButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setButton()
    }
    
    private func setButton() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = width / 2
        clipsToBounds = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        tintColor = UIColor.black
    }
}

extension NumberButton {
    func normalBackground() {
        backgroundColor = UIColor.black
        titleLabel?.tintColor = UIColor.white
    }
    
    func selectedBackground() {
        backgroundColor = UIColor.green
        titleLabel?.tintColor = UIColor.white
    }
}
