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
    
    @IBOutlet weak var lblToptxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   
    
    func setupDataToViews(dataEntry : [BarChartDataEntry] , arrLabel : [String], arrValues : [String], lblTitle : String = "") {

        lblToptxt.text = lblTitle
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
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "")
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barGraphVw.data = chartData
        barGraphVw.barData?.barWidth = 0.5
        barGraphVw.chartDescription?.enabled = false
        barGraphVw.xAxis.valueFormatter = IndexAxisValueFormatter(values: arrValues)
        
        let l = barGraphVw.legend
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
        barGraphVw.notifyDataSetChanged() // *imp:  need to notify , if not, app will crash 
    }
    
    
    func setChartBarGroupDataSet(dataPoints: [String], values: [Double], values2: [Double],sortIndex:Int) {
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i] )
            dataEntries.append(dataEntry)
        }
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values2[i] )
            dataEntries2.append(dataEntry)
        }
        
        let chartDataSet1 = BarChartDataSet(values: dataEntries, label: "Amount Paid")
        let chartDataSet2 = BarChartDataSet(values: dataEntries2, label: "Balance Remaining")
        chartDataSet1.colors =   [ChartColorTemplates.vordiplom()[0]]
        chartDataSet2.colors = [ChartColorTemplates.vordiplom()[1]]
        
        let dataSets: [BarChartDataSet] = [chartDataSet1,chartDataSet2]
        
        let data = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        let groupCount = dataPoints.count
        let startYear = 0
        
        
        data.barWidth = barWidth
        barGraphVw.xAxis.axisMinimum = Double(startYear)
        let gg = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        
        barGraphVw.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        data.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        barGraphVw.notifyDataSetChanged()
        barGraphVw.data = data
        
        let xAxis = barGraphVw.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1
        
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
//        leftAxis.drawAxisLineEnabled = false
        
        let rightAxis = barGraphVw.rightAxis
        rightAxis.enabled = false
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false

        barGraphVw.drawGridBackgroundEnabled = false
        barGraphVw.drawValueAboveBarEnabled = true
        barGraphVw.isUserInteractionEnabled = false
        barGraphVw.leftAxis.drawLimitLinesBehindDataEnabled = false
        barGraphVw.fitBars = true
        barGraphVw.chartDescription?.enabled = false
        
    }
    
}
