//
//  iossimplelifeTests.swift
//  iossimplelifeTests
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import XCTest
@testable import iossimplelife

class iossimplelifeTests: XCTestCase {
    
    private var numA: Double = 0
    private var numB: Double = 0
    private var res: String = ""
    private var operation: OperationType = .none

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testKeyboardTappedNumButtonWithZero() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedNumberButtons(text: "0", numberString: "12")
        
        XCTAssertEqual("12", res, "Failed")
    }
    
    func testKeyboardTappedNumButton() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedNumberButtons(text: "1", numberString: "12")
        
        XCTAssertEqual("112", res, "Failed")
    }
    
    func testTappedOperationButtonWithDivided() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedOperationButtons(operation: .divided)
        
        XCTAssertEqual(OperationType.divided, operation, "Failed")
    }
    
    func testTappedOperationButtonWithPlus() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedOperationButtons(operation: .plus)
        
        XCTAssertEqual(OperationType.plus, operation, "Failed")
    }
    
    func testTappedOperationButtonWithMinus() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedOperationButtons(operation: .minus)
        
        XCTAssertEqual(OperationType.minus, operation, "Failed")
    }
    
    func testTappedOperationButtonWithMultiply() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedOperationButtons(operation: .multiply)
        
        XCTAssertEqual(OperationType.multiply, operation, "Failed")
    }
    
    func testTappedOKButtonPlus() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedNumberButtons(text: "100", numberString: "0")
        obj.didTappedOperationButtons(operation: .plus)
        obj.didTappedNumberButtons(text: "100", numberString: "0")
        obj.didTappedOKButton()
        
        XCTAssertEqual("2000", res, "Failed")
    }
    
    func testTappedOKButtonMinus() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedNumberButtons(text: "100", numberString: "0")
        obj.didTappedOperationButtons(operation: .minus)
        obj.didTappedNumberButtons(text: "100", numberString: "0")
        obj.didTappedOKButton()
        
        XCTAssertEqual("0", res, "Failed")
    }
    
    func testTappedOKButtonMultiply() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedNumberButtons(text: "1", numberString: "0")
        obj.didTappedOperationButtons(operation: .multiply)
        obj.didTappedNumberButtons(text: "1", numberString: "0")
        obj.didTappedOKButton()
        
        XCTAssertEqual("100", res, "Failed")
    }
    
    func testTappedOKButtonDivided() {
        let obj = KeyboardViewModel(delegate: self)
        obj.didTappedNumberButtons(text: "1", numberString: "0")
        obj.didTappedOperationButtons(operation: .divided)
        obj.didTappedNumberButtons(text: "0", numberString: "2")
        obj.didTappedOKButton()
        
        XCTAssertEqual("5", res, "Failed")
    }
}

extension iossimplelifeTests: KeyboardViewModelDelegate {
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedNumber numberString: String) {
        self.res = numberString
    }
    
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedOperation operation: OperationType) {
        self.operation = operation
    }
    
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedOK numberString: String) {
        self.res = numberString
    }
    
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedBack numberString: String) {
        
    }
    
}

