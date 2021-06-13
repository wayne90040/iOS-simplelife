//
//  ViewController.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import UIKit
import Charts

class MainViewController: UIViewController {
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(didTappedAddButton), for: .touchUpInside)
        return button
    }()
    
    
    private let mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.rowHeight = 60
        
        return tableView
    }()
    
    private var viewModel: MainViewModel?
    private var models: [Record] = [Record]()
    private var costValue: Float = 0.0
    private var depositValue: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simele Life"
        mainTableView.delegate = self
        mainTableView.dataSource = self
        viewModel = MainViewModel(delegate: self)
        view.addSubviews(mainTableView, addButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel?.fetchAllRecords()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let buttonSize: CGFloat = 50.0
        
        addButton.frame = CGRect(x: (view.width - buttonSize) / 2,
                                 y: view.bottom - buttonSize - 20,
                                 width: buttonSize,
                                 height: buttonSize)
        addButton.layer.borderWidth = 2.0
        addButton.layer.cornerRadius = addButton.width / 2
        addButton.clipsToBounds = true
        
        mainTableView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: view.width,
                                     height: view.height)
    }
    
    @objc func didTappedAddButton () {
        let vc = AddRecordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK:- TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MainTableViewHeaderView()
        headerView.backgroundColor = .systemBackground
        headerView.frame = CGRect(x: 0, y: 0, width: mainTableView.width, height: 300)
        headerView.configure(costValue: costValue, depoistValue: depositValue)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier,
                                                 for: indexPath) as! MainTableViewCell
        let model = models[indexPath.row]
        let segmentedStyle: SegmentedStyle = SegmentedStyle(isCost: model.isCost) ?? .cost
        
        switch segmentedStyle {
        case .cost:
            cell.configure(with: model, .cost)
        case .deposit:
            cell.configure(with: model, .deposit)
        }
        
        return cell
    }
    
    // 開啟 TableView 側滑功能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            let model = models[indexPath.row]
            let cancel = UIAlertAction(title: "取消", style: .cancel)
            let confirm = UIAlertAction(title: "確定", style: .default) { [weak self] _ in
                self?.viewModel?.deleteRecord(record: model)
            }
            
            self.showAlert(title: "確認刪除", message: "確定要刪除嗎？", actions: [cancel, confirm])
            
        default:
            break
        }
    }
}

// MARK: - MainViewModel
extension MainViewController: MainViewModelDelegate {
    
    func mainView(_ viewModel: MainViewModel, editStyle style: CoreDateEditStyle, records: [Record]) {
        self.models = records
        
        // init
        costValue = 0.0
        depositValue = 0.0
        
        records.forEach { (record) in
            guard let price = Float(record.price ?? "0") else { return }
            
            if record.isCost {
                costValue += price
            } else {
                depositValue += price
            }
        }
        
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    
}
