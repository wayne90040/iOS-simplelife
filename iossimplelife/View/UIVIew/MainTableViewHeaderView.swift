//
//  ChartUIView.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/6/13.
//

import UIKit
import Charts

class MainTableViewHeaderView: UIView {
    
    private let pieChart: PieChartView = PieChartView()
    
    init() {
        super.init(frame: .zero)
        addSubview(pieChart)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pieChart.frame = CGRect(x: 0,
                                y: 0,
                                width: self.width,
                                height: self.height)
    }
    
    public func configure(with model: String) {
        let costValue: PieChartDataEntry = PieChartDataEntry(value: 25, label: "Cost")
        let depoistValue: PieChartDataEntry = PieChartDataEntry(value: 25, label: "Depoist")
        let dataSet = PieChartDataSet(entries: [costValue, depoistValue], label: "Test")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.drawValuesEnabled = false  // remove pie 圖上的 value
        dataSet.sliceSpace = 5.0
        dataSet.sliceBorderColor = .black
        dataSet.sliceBorderWidth = 2.0
        
        
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.data = data
        pieChart.drawEntryLabelsEnabled = false  // remove pie 圖上的 label
        
        pieChart.legend.font = UIFont(name: "Futura", size: 16)!
        
        pieChart.centerText = "Centet"
        

        pieChart.notifyDataSetChanged()  // This must stay at end of function
    }
}
