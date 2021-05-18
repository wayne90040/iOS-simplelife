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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "支出 / 收入"
        view.backgroundColor = .systemBackground
        
        view.addSubviews(categoryView, keyboardView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        categoryView.frame = CGRect(x: 20, y: topBarHeight + 20, width: view.width - 40, height: view.height / 2)
        keyboardView.frame = CGRect(x:0 , y: view.height / 2, width: view.width, height: view.height / 2)
    }
}
