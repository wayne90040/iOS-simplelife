//
//  AddRecordViewModel.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/23.
//

import Foundation

protocol AddRecordViewModelDelegate: class {
    func addRecordVC(_ viewModel: AddRecordViewModel, didTappedSave success: Bool)
    
}

class AddRecordViewModel {
    
    private weak var delegate: AddRecordViewModelDelegate?
    
    init(delegate: AddRecordViewModelDelegate) {
        self.delegate = delegate
    }
    
    public func saveRecordtoCorData(category: String, imageUrl: String, price: String, note: String, date: Date, isCost: Bool) {
        CoreDataStore().insertRecord(category: category,  imageUrl: imageUrl, price: price,
                                     note: note, date: date, isCost: isCost) { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.addRecordVC(strongSelf, didTappedSave: success)
        }
    }
}
