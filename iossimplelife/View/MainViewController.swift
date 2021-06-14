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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(PieChartTableViewCell.self, forCellReuseIdentifier: PieChartTableViewCell.identifier)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModel: MainViewModel?
    private var costValue: Float = 0.0
    private var depositValue: Float = 0.0
    
    private var datesOfRecord = [[String: String]]()
    private var recordsOfDate = [String: [Record]]()

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
        viewModel?.fetchRecordOfDate()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datesOfRecord.count + 1  // Pie Chart View
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 30
        } else {
            return 0
        }
    }
     
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > 0 {
            return datesOfRecord[section - 1]["date"]
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            let key = datesOfRecord[section - 1]["date"] ?? ""
            return recordsOfDate[key]?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if section > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier,
                                                     for: indexPath) as! MainTableViewCell
            
            let key = datesOfRecord[indexPath.section - 1]["date"] ?? ""
            
            guard let models = recordsOfDate[key] else {
                return UITableViewCell()
            }
            
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
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.identifier,
                                                     for: indexPath) as! PieChartTableViewCell
            
            cell.configure(costValue: costValue, depoistValue: depositValue)
            return cell
        }

    }
    
    // 開啟 TableView 側滑功能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if section > 0 {
            switch editingStyle{
            case .delete:
                
                guard let key = datesOfRecord[indexPath.section - 1]["date"],
                      let models = recordsOfDate[key] else {
                    return
                }
                let model = models[indexPath.row]
                let confirm = UIAlertAction(title: "確定", style: .default) { [weak self] _ in
                    self?.viewModel?.deleteRecord(record: model)
                }
                let cancel = UIAlertAction(title: "取消", style: .cancel)
                
                self.showAlert(title: "確認刪除", message: "確定要刪除嗎？", actions: [cancel, confirm])
                
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        
        return true
    }
}


// MARK: - MainViewModel
extension MainViewController: MainViewModelDelegate {
    
    func mainView(_ viewModel: MainViewModel, deleteRecord success: Bool) {
        if success {
            viewModel.fetchRecordOfDate()
        }
    }
    
    func mainView(_ viewModel: MainViewModel, fetchRecord dates: [[String : String]], records: [String : [Record]]) {
        self.datesOfRecord = dates
        self.recordsOfDate = records
        
        // init
        costValue = 0.0
        depositValue = 0.0
        
        recordsOfDate.forEach() { dic in
            let records = dic.value
            records.forEach() { record in
                guard let price = Float(record.price ?? "0") else { return }
                
                if record.isCost {
                    costValue += price
                } else {
                    depositValue += price
                }
            }
        }
        
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
}
