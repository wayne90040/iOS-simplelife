//
//  MainMoneyUIView.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import UIKit

class MainMoneyUIView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "$0"
        return label
    }()
    
    private var title: String = ""
    private var value: String = ""
    var isLeft: Bool = true
    
    init(title: String, isLeft: Bool) {
        self.title = title
        self.isLeft = isLeft
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isLeft {
            titleLabel.frame = CGRect(x: 15, y: 0, width: width, height: height / 2)
            valueLabel.frame = CGRect(x: 15, y: height / 2, width: width, height: height / 2)
        }
        else {
            titleLabel.frame = CGRect(x: 0, y: 0, width: width - 15, height: height / 2)
            valueLabel.frame = CGRect(x: 0, y: height / 2, width: width - 15, height: height / 2)
            titleLabel.textAlignment = .right
            valueLabel.textAlignment = .right
        }
    }
    
    public func configure(with title: String, value: String) {
        
        self.title = title
        self.value = value
    }
    
    private func setupView() {
        titleLabel.text = title
        addSubviews(titleLabel, valueLabel)
    }
}
