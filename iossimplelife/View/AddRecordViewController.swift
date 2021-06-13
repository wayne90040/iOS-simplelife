//
//  AddRecordViewController.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/9.
//

import UIKit

class AddRecordViewController: UIViewController {
    
    private let keyboardView: KeyboardUIView = KeyboardUIView()
    private let categoryView: CategoryUIView = CategoryUIView()
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["支出", "收入"])
        return control
    }()
    
    private var viewModel: AddRecordViewModel?
    private var category: Category = Category()
    private var date: Date = Date()
    
    private var segmentedStyle = SegmentedStyle(index: 0) {
        didSet {
            switch segmentedStyle {
            case .cost:
                categoryView.configure(with: NSPredicate(format: "isCost = %d", true))
            case .deposit:
                categoryView.configure(with: NSPredicate(format: "isCost = %d", false))
            case .none:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setSegmentedControl()
        categoryView.delegate = self
        keyboardView.delegate = self
        
        categoryView.configure(with: NSPredicate(format: "isCost = %d", true))
        
        viewModel = AddRecordViewModel(delegate: self)
        self.navigationItem.titleView = segmentedControl
        view.addSubviews(categoryView, keyboardView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        categoryView.frame = CGRect(x: 20,
                                    y: topBarHeight + 20,
                                    width: view.width - 40,
                                    height: view.height / 2 - topBarHeight - 20)
        
        keyboardView.frame = CGRect(x:0 ,
                                    y: categoryView.bottom,
                                    width: view.width,
                                    height: view.height / 2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setSegmentedControl() {
        segmentedControl.frame = CGRect(x: 0, y: 0, width: view.width / 3, height: 30)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControl), for: .valueChanged)
    }
    
    @objc private func didChangeSegmentedControl(sender: UISegmentedControl) {
        segmentedStyle = SegmentedStyle(index: sender.selectedSegmentIndex)
    }
    
}

// MARK: - CategoryUIViewDelegate
extension AddRecordViewController: CategoryUIViewDelegate {
    
    func categoryView(_ view: CategoryUIView, didTappedItem model: Category) {
        self.category = model
        keyboardView.iconImageName = model.imageUrl ?? ""
    }
}

// MARK: - KeyboardUIViewDelegate
extension AddRecordViewController: KeyboardUIViewDelegate {
    
    func keyboardView(_ view: KeyboardUIView, didTappedCalendar date: Date) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: CalendarViewController.storyboardName) as! CalendarViewController
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.setDate(date: date)  // Set date from keyboardView
       
        vc.sendDate = { [weak self] (date) in  // Send date from Calendar
            self?.date = date
            self?.keyboardView.date = date
        }
        
        present(vc, animated: true)
    }
    
    func keyboardView(_ view: KeyboardUIView, didTappedSave num: String, note: String) {
        if num == "0" {
            alertVC()
        }
        else {
            viewModel?.saveRecordtoCorData(category: category.name ?? "",
                                           imageUrl: category.imageUrl ?? "",
                                           price: num,
                                           note: note,
                                           date: date,
                                           isCost: segmentedStyle?.isCost ?? true)
        }
    }
    
    private func alertVC() {
        let ok: UIAlertAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
            self?.viewModel?.saveRecordtoCorData(category: self?.category.name ?? "",
                                                 imageUrl: self?.category.imageUrl ?? "",
                                                 price: "0",
                                                 note: "",
                                                 date: self?.date ?? Date(),
                                                 isCost: self?.segmentedStyle?.isCost ?? true)
        }
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        self.showAlert(title: "提示: 金額為0", message: "要記錄此筆嗎？", actions: [ok, cancel])
    }
}

// MARK: - AddRecordViewModelDelegate
extension AddRecordViewController: AddRecordViewModelDelegate {
    func addRecordVC(_ viewModel: AddRecordViewModel, didTappedSave success: Bool) {
        if success {
            let ok: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            self.showAlert(title: "記帳成功", message: "", actions: [ok])
        }
    }
}

// MARK: - Enum SegmentedStyle
enum SegmentedStyle {
    case cost, deposit
    
    var isCost: Bool{
        switch self {
        case .cost:
            return true
        case .deposit:
            return false
        }
    }
}

extension SegmentedStyle {
    init?(index: Int) {
        switch index {
        case 0:
            self = .cost
        case 1:
            self = .deposit
        default:
            self = .cost
        }
    }
    
    init?(isCost: Bool) {
        switch isCost {
        case true:
            self = .cost
        case false:
            self = .deposit
        }
    }
}
