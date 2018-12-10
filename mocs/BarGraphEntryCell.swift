//
//  BarGraphEntryCell.swift
//  mocs
//
//  Created by Talat Baig on 12/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Charts

class BarGraphEntryCell: UITableViewCell {
    
    @IBOutlet weak var outrVw: UIView!
    @IBOutlet weak var barChartVw: BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    func setup() {
        
        barChartVw.drawValueAboveBarEnabled = false
        barChartVw.drawGridBackgroundEnabled = false

        barChartVw.isUserInteractionEnabled = false
    
        barChartVw.leftAxis.drawLimitLinesBehindDataEnabled = false
        barChartVw.fitBars = true

//        let months = ["Jan", "Feb", "Mar", "Apr", "May", "June" , "July"]
        
        let xAxis = barChartVw.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
//        xAxis.granularityEnabled = true
//        xAxis.decimals = 0

//        xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        xAxis.drawGridLinesEnabled = false
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
//        leftAxisFormatter.negativeSuffix = " $"
//        leftAxisFormatter.positiveSuffix = " $"
//        leftAxisFormatter.drawGridLinesEnabled = false

        
        let leftAxis = barChartVw.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        leftAxis.drawGridLinesEnabled = false
        
        let rightAxis = barChartVw.rightAxis
        rightAxis.enabled = false
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        rightAxis.drawGridLinesEnabled = false
        
        let l = barChartVw.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
    }
    
    
    func setupDataToViews(dataEntry : [BarChartDataEntry] , arrLabel : [String]) {
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "Units Sold")
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartVw.data = chartData
        
        barChartVw.xAxis.valueFormatter = IndexAxisValueFormatter(values:arrLabel)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
