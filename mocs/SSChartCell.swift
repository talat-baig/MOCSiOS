//
//  SSChartCell.swift
//  mocs
//
//  Created by Talat Baig on 12/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Charts

class SSChartCell: UITableViewCell {

    
    @IBOutlet weak var barGraphVw: BarChartView!
    @IBOutlet weak var outerVw: UIView!
//    var dataEntry : [BarChartDataEntry] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(dataEntry : [BarChartDataEntry] ) {
        
        barGraphVw.drawValueAboveBarEnabled = false
        barGraphVw.drawGridBackgroundEnabled = false
        
        barGraphVw.isUserInteractionEnabled = false
        
        barGraphVw.leftAxis.drawLimitLinesBehindDataEnabled = false
        barGraphVw.fitBars = true

        let xAxis = barGraphVw.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.drawGridLinesEnabled = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        
        let leftAxis = barGraphVw.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        leftAxis.drawGridLinesEnabled = false
        
        let rightAxis = barGraphVw.rightAxis
        rightAxis.enabled = false
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        rightAxis.drawGridLinesEnabled = false
        
        let l = barGraphVw.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        
        
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
//        
//        var legenEntries : [LegendEntry] = []
//
//        for i in 0..<dataEntry.count {
//            let lgnd = LegendEntry()
//            lgnd.formColor = ChartColorTemplates.vordiplom()[i]
//            lgnd.label = self.data[i]
//        }
//
//        l.entries = legenEntries
        
    }
    
    
    func setupDataToViews(dataEntry : [BarChartDataEntry] , arrLabel : [String]) {
        

        setup(dataEntry: dataEntry)
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "Units Sold")
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        let chartData = BarChartData(dataSet: chartDataSet)
        barGraphVw.data = chartData
        
        barGraphVw.xAxis.valueFormatter = IndexAxisValueFormatter(values:arrLabel)
        
        
    }
    
}
