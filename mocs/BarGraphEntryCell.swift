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
    @IBOutlet weak var lblToptxt: UILabel!
    @IBOutlet weak var btnOpenPA: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.contentView.layer.shadowOpacity = 0.25
//        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.contentView.layer.shadowRadius = 1
//        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.outrVw.layer.borderColor = UIColor.lightGray.cgColor
        self.outrVw.layer.borderWidth = 0.8

    }
    
    
func setupDataToViews(dataEntry : [BarChartDataEntry] , arrLabel : [String], arrValues : [String], lblTitle : String = "") {
        
        lblToptxt.text = lblTitle
        barChartVw.drawValueAboveBarEnabled = false
        barChartVw.drawGridBackgroundEnabled = false
        barChartVw.isUserInteractionEnabled = false
        barChartVw.leftAxis.drawLimitLinesBehindDataEnabled = false
        barChartVw.fitBars = true
        
        let xAxis = barChartVw.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        
        xAxis.drawGridLinesEnabled = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
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
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "")
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartVw.data = chartData
        barChartVw.barData?.barWidth = 0.5
        barChartVw.chartDescription?.enabled = false
        //        barChartVw.chartDescription?.text = String(format: "Top %d Counterparty", arrValues.count)
        barChartVw.xAxis.valueFormatter = IndexAxisValueFormatter(values: arrValues)
        
        let l = barChartVw.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 9
        l.wordWrapEnabled = true
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        var legenEntries : [LegendEntry] = []
        
        if l.isLegendCustom {
            l.resetCustom()
        }
        
        for i in 0..<arrLabel.count {
            let lgnd = LegendEntry()
            lgnd.formColor = ChartColorTemplates.vordiplom()[i]
            lgnd.label = arrLabel[i]
            legenEntries.append(lgnd)
        }
        
        l.setCustom(entries: legenEntries)
        barChartVw.notifyDataSetChanged() // *imp:  need to notify , if not, app will crash
    }

    
    
//    func setupDataToViews(dataEntry : [BarChartDataEntry] , arrLabel : [String], arrValues : [String], lblTitle : String = "") {
//
//        barChartVw.drawValueAboveBarEnabled = false
//        barChartVw.drawGridBackgroundEnabled = false
//
//        barChartVw.isUserInteractionEnabled = false
//
//        barChartVw.leftAxis.drawLimitLinesBehindDataEnabled = false
//        barChartVw.fitBars = true
//
////        let months = ["Jan", "Feb", "Mar", "Apr", "May", "June" , "July"]
//
//        let xAxis = barChartVw.xAxis
//        xAxis.labelPosition = .bottom
//        xAxis.labelFont = .systemFont(ofSize: 10)
//        xAxis.granularity = 1
//        xAxis.labelCount = 7
////        xAxis.granularityEnabled = true
////        xAxis.decimals = 0
//
////        xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
//        xAxis.drawGridLinesEnabled = false
//
//
//        let leftAxisFormatter = NumberFormatter()
//        leftAxisFormatter.minimumFractionDigits = 0
//        leftAxisFormatter.maximumFractionDigits = 1
////        leftAxisFormatter.negativeSuffix = " $"
////        leftAxisFormatter.positiveSuffix = " $"
////        leftAxisFormatter.drawGridLinesEnabled = false
//
//
//        let leftAxis = barChartVw.leftAxis
//        leftAxis.labelFont = .systemFont(ofSize: 10)
//        leftAxis.labelCount = 8
//        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
//        leftAxis.labelPosition = .outsideChart
//        leftAxis.spaceTop = 0.15
//        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
//        leftAxis.drawGridLinesEnabled = false
//
//        let rightAxis = barChartVw.rightAxis
//        rightAxis.enabled = false
//        rightAxis.spaceTop = 0.15
//        rightAxis.axisMinimum = 0
//        rightAxis.drawGridLinesEnabled = false
//
//        let l = barChartVw.legend
//        l.horizontalAlignment = .left
//        l.verticalAlignment = .bottom
//        l.orientation = .horizontal
//        l.drawInside = false
//        l.form = .circle
//        l.formSize = 9
//
//        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
//        l.xEntrySpace = 4
//
//    }
    
    @IBAction func btnOpenPATapped(_ sender: Any) {
        
    }
    
//    func setupDataToViews(dataEntry : [BarChartDataEntry] , arrLabel : [String]) {
//
//        let chartDataSet = BarChartDataSet(values: dataEntry, label: "Units Sold")
//        chartDataSet.colors = ChartColorTemplates.vordiplom()
//        let chartData = BarChartData(dataSet: chartDataSet)
//        barChartVw.data = chartData
//
//        barChartVw.xAxis.valueFormatter = IndexAxisValueFormatter(values:arrLabel)
//
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
