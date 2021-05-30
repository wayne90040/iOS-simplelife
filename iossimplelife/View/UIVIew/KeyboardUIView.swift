//
//  KeyboardUIView.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/10.
//

import UIKit

protocol KeyboardUIViewDelegate: class {
    func keyboardView(_ view: KeyboardUIView, didTappedSave num: String, note: String)
    func keyboardView(_ view: KeyboardUIView, didTappedCalendar day: String)
}

enum OperationType {
    case plus, minus, multiply, divided, none
}

class KeyboardUIView: UIView {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var number7Button: NumberButton!
    @IBOutlet weak var number8Button: NumberButton!
    @IBOutlet weak var number9Button: NumberButton!
    @IBOutlet weak var number4Button: NumberButton!
    @IBOutlet weak var number5Button: NumberButton!
    @IBOutlet weak var number6Button: NumberButton!
    @IBOutlet weak var number1Button: NumberButton!
    @IBOutlet weak var number2Button: NumberButton!
    @IBOutlet weak var number3Button: NumberButton!
    @IBOutlet weak var number00Button: NumberButton!
    @IBOutlet weak var number0Button: NumberButton!
    @IBOutlet weak var numberDotButton: NumberButton!
    @IBOutlet weak var gobackButton: NumberButton!
    @IBOutlet weak var clearButton: NumberButton!
    @IBOutlet weak var backButton: NumberButton!
    @IBOutlet weak var okButton: NumberButton!
    @IBOutlet weak var dividedButton: NumberButton!
    @IBOutlet weak var multiplyButton: NumberButton!
    @IBOutlet weak var plusButton: NumberButton!
    @IBOutlet weak var minusButton: NumberButton!
    @IBOutlet weak var calendarButton: UIButton!
    
    private var viewModel: KeyboardViewModel?
    weak var delegate: KeyboardUIViewDelegate?
    
//    private var operationType: OperationType = .none
    
    // tag 1 to 11
    @IBAction func numberButtonsAction(_ sender: NumberButton) {
        var number: String = ""
        if sender.tag == 10 {
            number = "0"
        } else if sender.tag == 11 {
            number = "00"
        } else {
            number = "\(sender.tag)"
        }
       
        viewModel?.didTappedNumberButtons(text: numberLabel.text ?? "0", numberString: number)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xib()
        viewModel = KeyboardViewModel(delegate: self)
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xib()
    }
    
    private func xib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        setBackColor(plusButton, minusButton, dividedButton, multiplyButton)
        addSubview(view)
    }
    
    private func setButtonAction() {
        plusButton.addTarget(self, action: #selector(didTappedPlusButton), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(didTappedMinusButton), for: .touchUpInside)
        dividedButton.addTarget(self, action: #selector(didTappedDivideButton), for: .touchUpInside)
        multiplyButton.addTarget(self, action: #selector(didTappedMultiplyButton), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(didTappedClearButton), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(didTappedOKButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(didTappedCalendarButton), for: .touchUpInside)
    }
    
    // MARK: - Button Action
    
    @objc func didTappedClearButton() {
        viewModel?.didTappedCleanButton()
        numberLabel.text = "0"
    }
    
    @objc func didTappedPlusButton() {
        viewModel?.didTappedOperationButtons(operation: .plus)
    }
    
    @objc func didTappedMinusButton() {
        viewModel?.didTappedOperationButtons(operation: .minus)
    }
    
    @objc func didTappedMultiplyButton() {
        viewModel?.didTappedOperationButtons(operation: .multiply)
    }
    
    @objc func didTappedDivideButton() {
        viewModel?.didTappedOperationButtons(operation: .divided)
    }
    
    @objc func didTappedOKButton() {
        if okButton.titleLabel?.text == "="{
            /// 計算等於
            viewModel?.didTappedOKButton()
        }
        else {
            /// Save
            guard let number = numberLabel.text else {
                return
            }
            delegate?.keyboardView(self, didTappedSave: number, note: "")
        }
    }
    
    @objc func didTappedBackButton() {
        viewModel?.didTappedBackButton()
    }
    
    @objc func didTappedCalendarButton() {
        delegate?.keyboardView(self, didTappedCalendar: "")
    }
}

extension KeyboardUIView: KeyboardViewModelDelegate {
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedNumber number: String) {
        numberLabel.text = "\(number)"
    }
    
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedOperation operation: OperationType) {
        // operation
        setBackColor(plusButton, minusButton, dividedButton, multiplyButton)
        
        switch operation {
        case .divided:
            dividedButton.selectedBackground()
        case .minus:
            minusButton.selectedBackground()
        case .multiply:
            multiplyButton.selectedBackground()
        case .plus:
            plusButton.selectedBackground()
        case .none: break
        }
        
        okButton.setTitle("=", for: .normal)
        numberLabel.text = "0"
    }
    
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedOK number: String) {
        numberLabel.text = "\(number)"
        okButton.setTitle("OK", for: .normal)
        setBackColor(plusButton, minusButton, dividedButton, multiplyButton)
    }
    
    func keyboardView(_ viewModel: KeyboardViewModel, didTappedBack numberString: String) {
        numberLabel.text = numberString
    }
    
    private func setBackColor(_ buttons: NumberButton...) {
        buttons.forEach() {$0.normalBackground()}
    }
}
