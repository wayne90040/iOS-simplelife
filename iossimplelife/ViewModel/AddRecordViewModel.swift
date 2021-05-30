//
//  AddRecordViewModel.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/23.
//

import Foundation

protocol AddRecordViewModelDelegate: class {
    
}

class AddRecordViewModel {
    
    private weak var delegate: AddRecordViewModelDelegate?
    
    init(delegate: AddRecordViewModelDelegate) {
        self.delegate = delegate
    }
    
    public func saveRecordtoCorData(category: String, imageUrl: String, price: String, note: String, date: Date) {
        CoreDataStore().insertRecord(category: category,  imageUrl: imageUrl, price: price, note: note, date: date) { (success) in
            guard success else { fatalError("saveRecordtoCorData") }
        }
        
        print("Save Record")
    }
}
