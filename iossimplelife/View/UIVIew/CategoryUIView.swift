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
    private var viewModel: CategoryViewModel?
    private var models: [Category] = [Category]()
    private var selectedModel: Category = Category()
    
    weak var delegate: CategoryUIViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCollectionView()
        if let collectionView = mainCollectionView {
            addSubview(collectionView)
        }

        viewModel = CategoryViewModel(delegate: self)
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
    
    public func configure(with predicate: NSPredicate?) {
        viewModel?.fetchAllCategory(predicate: predicate)
    }
}

// MARK:- Collection Delegate

extension CategoryUIView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.width - 6) / 4,
                      height: self.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCollectionViewCell.identifier,
                                                      for: indexPath) as! CategoryItemCollectionViewCell
        let model = models[indexPath.row]
        cell.configure(with: model, selected: selectedModel)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedModel = models[indexPath.row]
        
        DispatchQueue.main.async {
            self.mainCollectionView?.reloadData()
        }
        delegate?.categoryView(self, didTappedItem: selectedModel)
    }
}

// MARK:- ViewModel Delegate

extension CategoryUIView: CategoryViewModelDelegate {
    
    func categoryView(_ viewModel: CategoryViewModel, fetchAllCategory categories: [Category]) {
        models = categories
        
        if categories.count > 0 {
            selectedModel = categories[0]  // dafault selected
            delegate?.categoryView(self, didTappedItem: selectedModel)
        }
        
        DispatchQueue.main.async {
            self.mainCollectionView?.reloadData()
        }
    }
}



