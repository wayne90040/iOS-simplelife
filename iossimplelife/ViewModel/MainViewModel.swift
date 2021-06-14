//
//  MainViewModel.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import Foundation

protocol MainViewModelDelegate: class {
    func mainView(_ viewModel: MainViewModel, deleteRecord success: Bool)
    func mainView(_ viewModel: MainViewModel, fetchRecord dates: [[String: String]], records: [String: [Record]])
}

class MainViewModel {
    
    private let coreDataStore = CoreDataStore()
    weak var delegate: MainViewModelDelegate?
    
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
    }

    public func fetchRecordOfDate() {
        var recordsOfDate = [String: [Record]]()
        guard let datesOfRecord = coreDataStore.fetchDatesOfRecords() else {
            return
        }
        
        datesOfRecord.forEach() { dateDic in
            guard let dateString = dateDic["date"] else { return }
            
            let result = coreDataStore.fetchRecordOfDate(dateString: dateString)
            recordsOfDate[dateString] = result
        }
        
        delegate?.mainView(self, fetchRecord: datesOfRecord, records: recordsOfDate)
    }
    
    public func deleteRecord(record: Record) {
        coreDataStore.deleteRecord(record: record) { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.mainView(strongSelf, deleteRecord: success)
        }
    }
}
