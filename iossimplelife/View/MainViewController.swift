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
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.rowHeight = 60
        
        return tableView
    }()
    
    private let chartView: MainTableViewHeaderView = MainTableViewHeaderView()
    
    private var viewModel: MainViewModel?
    private var models: [Record] = [Record]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simele Life"
        mainTableView.delegate = self
        mainTableView.dataSource = self
        viewModel = MainViewModel(delegate: self)
        chartView.configure(with: "test")
        view.addSubviews(mainTableView, addButton)
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
        
//        costView.frame = CGRect(x: 0, y: topBarHeight, width: viewWidth, height: viewHeight)
//        incomeView.frame = CGRect(x: viewWidth, y: topBarHeight, width: viewWidth, height: viewHeight)
//
//        chartView.frame = CGRect(x: 0,
//                                 y: costView.bottom,
//                                 width: view.width,
//                                 height: view.height - costView.height)
        
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
        headerView.configure(with: "")
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
        
        if records.count > 0 {
            var costValue: Float = 0.0
            var depositValue: Float = 0.0
            
            records.forEach { (record) in
                guard let price = Float(record.price ?? "0") else {
                    return
                }
                
                if record.isCost {
                    costValue += price
                } else {
                    depositValue += price
                }
            }
        
            costView.configure(with: costValue)
            incomeView.configure(with: depositValue)
        }
        
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
}
