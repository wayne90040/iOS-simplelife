//
//  CategoryItemCollectionViewCell.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/16.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CategoryItemCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(iconImageView, nameLabel, circleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: (contentView.width - 30) / 2,
                                     y: 5,
                                     width: 30,
                                     height: 30)
        
        nameLabel.frame = CGRect(x: 5, y: iconImageView.bottom + 3, width: contentView.width - 10, height: 20)
        
        circleView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: 10,
                                  height: 10)
        
        circleView.layer.cornerRadius = circleView.width / 2
        circleView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with model: Category, selected: Category) {  // default = 0
        
        if let iconName = model.imageUrl {
            iconImageView.image = UIImage(named: iconName)
        } else {
            iconImageView.image = UIImage(systemName: "person")
        }
        nameLabel.text = model.name
        
        if model.name != selected.name {
            circleView.backgroundColor = UIColor.gray
        } else {
            if model.isCost {
                circleView.backgroundColor = UIColor.red
            } else {
                circleView.backgroundColor = UIColor.green
            }
        }
    }
}
