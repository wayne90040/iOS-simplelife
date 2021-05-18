//
//  CategoryUIView.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/16.
//

import UIKit

class CategoryUIView: UIView {
    
    private var mainCollectionView: UICollectionView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCollectionView()
        
        if let collectionView = mainCollectionView {
            addSubview(collectionView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainCollectionView?.frame = bounds
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // The minimum spacing to use between lines of items in the grid.
        layout.minimumLineSpacing = 2
        // The minimum spacing to use between items in the same row.
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        mainCollectionView?.backgroundColor = .systemBackground

        mainCollectionView?.register(CategoryItemCollectionViewCell.self, forCellWithReuseIdentifier: CategoryItemCollectionViewCell.identifier)
    }
}

extension CategoryUIView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = (self.width - 10) / 4
        let itemHeigh: CGFloat = self.height / 3
        return CGSize(width: itemWidth, height: itemHeigh)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCollectionViewCell.identifier,
                                                      for: indexPath) as! CategoryItemCollectionViewCell
        cell.configure(with: "test")
        
        return cell
    }
}


