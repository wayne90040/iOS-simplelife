//
//  MainViewModel.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import Foundation

protocol MainViewModelDelegate: class {
    func mainView(_ viewModel: MainViewModel, fetchAllRecords records: [Record])
}

class MainViewModel {
    private let coreDataStore = CoreDataStore()
    weak var delegate: MainViewModelDelegate?
    
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
    }
    
    public func fetchAllRecords(){
        delegate?.mainView(self, fetchAllRecords: coreDataStore.fetchAllRecords())
    }
}
