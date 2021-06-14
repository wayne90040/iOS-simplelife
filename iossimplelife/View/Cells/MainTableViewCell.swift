//
//  MainTableViewCell.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/30.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    static let identifier: String = "MainTableViewCell"
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(iconImage, titleLabel, valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImage.frame = CGRect(x: 10, y: 10, width: contentView.height - 20, height: contentView.height - 20)
        titleLabel.frame = CGRect(x: iconImage.right + 15,
                                  y: 0,
                                  width: 60,
                                  height: contentView.height)
        
        valueLabel.frame = CGRect(x: contentView.right - 60 - 10 ,
                                  y: 0,
                                  width: 60,
                                  height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImage.image = nil
        titleLabel.text = nil
        valueLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(with model: Record, _ type: SegmentedStyle) {
        
        iconImage.image = UIImage(named: model.imageUrl ?? "")
        if let note = model.note, !note.isEmpty {
            titleLabel.text = note
        } else {
            titleLabel.text = model.category
        }
        
        titleLabel.sizeToFit()
        valueLabel.sizeToFit()
        
        switch type {
        case .cost:
            valueLabel.text = "-\(model.price ?? "")"
            valueLabel.textColor = .red
            valueLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        case .deposit:
            valueLabel.text = model.price
            valueLabel.textColor = .green
        }
    }
}
