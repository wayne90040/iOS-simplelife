//
//  MainViewModel.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import Foundation

protocol MainViewModelDelegate: class {
    func mainView(_ viewModel: MainViewModel, editStyle style: CoreDateEditStyle, records: [Record])
}

class MainViewModel {
    private let coreDataStore = CoreDataStore()
    weak var delegate: MainViewModelDelegate?
    
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
    }
    
    public func fetchAllRecords(){
        delegate?.mainView(self, editStyle: .read, records: coreDataStore.fetchAllRecords())
    }
    
    public func deleteRecord(record: Record) {
        coreDataStore.deleteRecord(record: record, completion: { [weak self] (success) in
            guard let strongSelf = self else { return }
            
            if success {
                strongSelf.delegate?.mainView(strongSelf, editStyle: .delete, records: strongSelf.coreDataStore.fetchAllRecords())
            } else {
                fatalError("deleteRecord")
            }
        })
    }
}
