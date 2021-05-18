//
//  CategoryItemCollectionViewCell.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/16.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CategoryItemCollectionViewCell"
    
    private let categoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(categoryButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryButton.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with model: String) {
        categoryButton.setTitle("\(model)", for: .normal)
    }
}
