//
//  CategoryUIView.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/16.
//

import UIKit

protocol CategoryUIViewDelegate: class {
    func categoryView(_ view: CategoryUIView, didTappedItem model: Category)
}

class CategoryUIView: UIView {
    
    private var mainCollectionView: UICollectionView?
    weak var delegate: CategoryUIViewDelegate?
    
    private var viewModel: CategoryViewModel?
    
    private var models: [Category] = [Category]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCollectionView()
        if let collectionView = mainCollectionView {
            addSubview(collectionView)
        }
        
        viewModel = CategoryViewModel(delegate: self)
        viewModel?.fetchAllCategory()
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
        mainCollectionView?.isPagingEnabled = true
        mainCollectionView?.register(CategoryItemCollectionViewCell.self, forCellWithReuseIdentifier: CategoryItemCollectionViewCell.identifier)
    }
}

// MARK:- Collection Delegate

extension CategoryUIView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = (self.width - 6) / 4
        let itemHeigh: CGFloat = self.height / 3
        return CGSize(width: itemWidth, height: itemHeigh)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCollectionViewCell.identifier,
                                                      for: indexPath) as! CategoryItemCollectionViewCell
        let model = models[indexPath.row]
        cell.configure(with: model)
        
        cell.didTappedBtnAction = { [weak self] (model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.categoryView(strongSelf, didTappedItem: model)
        }
        return cell
    }
}

// MARK:- ViewModel Delegate

extension CategoryUIView: CategoryViewModelDelegate {
    func categoryView(_ viewModel: CategoryViewModel, fetchAllCategory categories: [Category]) {
        self.models = categories
        DispatchQueue.main.async {
            self.mainCollectionView?.reloadData()
        }
    }
}



