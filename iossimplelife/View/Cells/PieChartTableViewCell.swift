//
//  PieChartTableViewCell.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/6/14.
//

// https://github.com/danielgindi/Charts

import UIKit
import  Charts

class PieChartTableViewCell: UITableViewCell {
    
    static let identifier: String = "PieChartTableViewCell"
    
    private let pieChart: PieChartView = PieChartView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(pieChart)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pieChart.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(costValue: Float, depoistValue: Float) {
        let centerValue: Float = depoistValue - costValue
        let costValue: PieChartDataEntry = PieChartDataEntry(value: Double(costValue), label: "Cost")
        let depoistValue: PieChartDataEntry = PieChartDataEntry(value: Double(depoistValue), label: "Depoist")
        
        let dataSet = PieChartDataSet(entries: [costValue, depoistValue], label: nil)
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.drawValuesEnabled = false  // remove pie 圖上的 value
        dataSet.sliceSpace = 5.0
        dataSet.sliceBorderColor = .black
        dataSet.sliceBorderWidth = 2.0
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.drawEntryLabelsEnabled = false  // remove pie 圖上的 label
        pieChart.legend.font = UIFont(name: "Futura", size: 16)!
        
        if centerValue == floor(centerValue) {
            pieChart.centerText = "\(Int(centerValue))"
        } else {
            pieChart.centerText = "\(centerValue)"
        }
        
        pieChart.notifyDataSetChanged()  // This must stay at end of function
    }

}
