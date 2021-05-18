//
//  KeyboardViewModel.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/11.
//

import Foundation

protocol KeyboardViewModelDelegate: class {
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedNumber numberString: String)
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedOperation operation: OperationType)
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedOK numberString: String)
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedBack numberString: String)
}

class KeyboardViewModel {
    
    private weak var delegate: KeyboardViewModelDelegate?
    private var operation: OperationType = .none
    private var numA: Double = 0
    private var numB: Double = 0
    
    init(delegate: KeyboardViewModelDelegate) {
        self.delegate = delegate
    }
    
    public func didTappedNumberButtons(text: String, numberString: String) {
        var res: String = "0"
        
        if text == "0" {
            res = "\(numberString)"
        }
        else {
            res = "\(text)\(numberString)"
        }
        
        numB = Double(res) ?? 0
        
        delegate?.keyboardView(self, didTappedNumber: res)
    }
    
    public func didTappedOperationButtons(operation: OperationType) {
        self.operation = operation
        numA = numB
        delegate?.keyboardView(self, didTappedOperation: operation)
    }
    
    public func didTappedOKButton() {
        switch operation {
        case .plus:
            numB = numA + numB
        case .divided:
            numB = numA / numB
        case .minus:
            numB = numA - numB
        case .multiply:
            numB = numA * numB
        case .none:
            break
        }
        
        // 判斷是否有小數點
        if floor(numB) == numB {
            delegate?.keyboardView(self, didTappedOK: "\(Int(numB))")
        }
        else {
            delegate?.keyboardView(self, didTappedNumber: "\(numB)")
        }
        
        operation = .none
    }
    
    public func didTappedBackButton() {
       
        if floor(numB) == numB {
            numB = floor(numB / 10)
            delegate?.keyboardView(self, didTappedBack: "\(Int(numB))")
        }
        else {
            // 小數點
        }
    }
    
    public func didTappedCleanButton() {
        numA = 0.0
        numB = 0.0
    }
}
