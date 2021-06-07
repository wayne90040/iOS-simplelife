//
//  CategoryViewModel.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/20.
//

import Foundation

protocol CategoryViewModelDelegate: class {
    func categoryView(_ viewModel: CategoryViewModel, fetchAllCategory categories: [Category])
}

class CategoryViewModel {
    
    private let coreDataStore = CoreDataStore()
    private weak var delegate: CategoryViewModelDelegate?
    
    init(delegate: CategoryViewModelDelegate) {
        self.delegate = delegate
    }
    
    public func fetchAllCategory(predicate: NSPredicate?){
        delegate?.categoryView(self, fetchAllCategory: coreDataStore.fetchCategories(predicate: predicate))
    }
}
