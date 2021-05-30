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
    private var viewModel: AddRecordViewModel?
    private var category: String = ""
    private var date: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "支出 / 收入"
        view.backgroundColor = .systemBackground
        categoryView.delegate = self
        keyboardView.delegate = self
        
        viewModel = AddRecordViewModel(delegate: self)
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
}

extension AddRecordViewController: CategoryUIViewDelegate {
    func categoryView(_ view: CategoryUIView, didTappedItem model: Category) {
        self.category = model.name ?? ""
    }
}

extension AddRecordViewController: KeyboardUIViewDelegate {
    func keyboardView(_ view: KeyboardUIView, didTappedCalendar day: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: CalendarViewController.storyboardName) as! CalendarViewController
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        
        vc.sendDate? = { [weak self] (date) in
            self?.date = date
        }
        
        present(vc, animated: true)
    }
    
    func keyboardView(_ view: KeyboardUIView, didTappedSave num: String, note: String) {
        if num == "0" {
            alertVC()
        }
        else {
            viewModel?.saveRecordtoCorData(category: category, imageUrl: "", price: num, note: "", date: Date())
        }
    }
    
    private func alertVC() {
        let alert = UIAlertController(title: "提示: 金額為0", message: "要記錄此筆嗎？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive){ [weak self] _ in
            self?.viewModel?.saveRecordtoCorData(category: self?.category ?? "", imageUrl: "", price: "0", note: "", date: Date())
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension AddRecordViewController: AddRecordViewModelDelegate {
    
}
