//
//  ViewController.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import UIKit

class MainViewController: UIViewController {
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(didTappedAddButton), for: .touchUpInside)
        return button
    }()
    
    private let incomeView: MainMoneyUIView = {
        let view = MainMoneyUIView(title: "收入", isLeft: false)
        view.isLeft = false
        return view
    }()
    
    private let costView: MainMoneyUIView = {
        let view = MainMoneyUIView(title: "支出", isLeft: true)
        view.isLeft = true
        return view
    }()
    
    private let mainTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var viewModel: MainViewModel?
    private var models: [Record] = [Record]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simele Life"
        mainTableView.delegate = self
        mainTableView.dataSource = self
        viewModel = MainViewModel(delegate: self)
        view.addSubviews(addButton, incomeView, costView, mainTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel?.fetchAllRecords()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let buttonSize: CGFloat = 50.0
        let viewHeight: CGFloat = 60.0
        let viewWidth: CGFloat = view.width / 2
        
        addButton.frame = CGRect(x: (view.width - buttonSize) / 2,
                                 y: view.bottom - buttonSize - 20,
                                 width: buttonSize,
                                 height: buttonSize)
        addButton.layer.borderWidth = 2.0
        addButton.layer.cornerRadius = addButton.width / 2
        addButton.clipsToBounds = true
        
        costView.frame = CGRect(x: 0, y: topBarHeight, width: viewWidth, height: viewHeight)
        incomeView.frame = CGRect(x: viewWidth, y: topBarHeight, width: viewWidth, height: viewHeight)
    }
    
    @objc func didTappedAddButton () {
        let vc = AddRecordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}


extension MainViewController: MainViewModelDelegate {
    func mainView(_ viewModel: MainViewModel, fetchAllRecords records: [Record]) {
        self.models = records
    }
}
