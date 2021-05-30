//
//  CategoryItemCollectionViewCell.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/16.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CategoryItemCollectionViewCell"
    private var model: Category = Category()
    var didTappedBtnAction: ((Category) -> ())?
    
    private let categoryButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryButton.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        contentView.addSubview(categoryButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryButton.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
        categoryButton.centerVertically()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with model: Category) {
        self.model = model
        if let imageName = model.imageUrl {
            categoryButton.setImage(UIImage(named: imageName), for: .normal)
        } else {
            categoryButton.setImage(UIImage(systemName: "person"), for: .normal)
        }
        
        categoryButton.setTitle(model.name, for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.titleLabel?.font = .systemFont(ofSize: 14)
        categoryButton.imageView?.contentMode = .scaleAspectFill
    }
    
    @objc func didTappedButton() {
        didTappedBtnAction?(model)
    }
}
