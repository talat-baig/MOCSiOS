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
       
        let xAxis = barGraphVw.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: arrValues)
        xAxis.wordWrapEnabled = true
        xAxis.avoidFirstLastClippingEnabled = false
        
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
        
        let chartDataSet = BarChartDataSet(entries: dataEntry, label: "")
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barGraphVw.data = chartData
        barGraphVw.barData?.barWidth = 0.5
        barGraphVw.chartDescription?.enabled = false

        barGraphVw.drawValueAboveBarEnabled = true
        barGraphVw.drawGridBackgroundEnabled = false
        barGraphVw.isUserInteractionEnabled = false
        barGraphVw.leftAxis.drawLimitLinesBehindDataEnabled = false
        barGraphVw.fitBars = true
        barGraphVw.notifyDataSetChanged() // *imp:  need to notify , if not, app will crash
//        barGraphVw.barData?.setValueFont()

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
        
    }
    
    
    func setChartBarGroupDataSet(dataPoints: [String], values1: [Double], values2: [Double],sortIndex:Int) {
        
        var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values1[i] )
            dataEntries1.append(dataEntry)
        }
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values2[i] )
            dataEntries2.append(dataEntry)
        }
        
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Amount Paid")
        let chartDataSet2 = BarChartDataSet(entries: dataEntries2, label: "Balance Remaining")
        chartDataSet1.colors =   [ChartColorTemplates.vordiplom()[0]]
        chartDataSet2.colors = [ChartColorTemplates.vordiplom()[1]]
        chartDataSet1.valueFont = UIFont.systemFont(ofSize: 6.0)
        chartDataSet2.valueFont = UIFont.systemFont(ofSize: 6.0)

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
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.drawGridLinesEnabled = true
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        xAxis.axisMinimum = 0.0
        xAxis.wordWrapEnabled = true
        xAxis.avoidFirstLastClippingEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = barGraphVw.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.drawGridLinesEnabled = false
        
        
        let rightAxis = barGraphVw.rightAxis
        rightAxis.enabled = false
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false

        let l = barGraphVw.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        
        barGraphVw.drawGridBackgroundEnabled = false
        barGraphVw.drawValueAboveBarEnabled = true
        
        barGraphVw.isUserInteractionEnabled = false
        barGraphVw.leftAxis.drawLimitLinesBehindDataEnabled = false
        barGraphVw.fitBars = true
        barGraphVw.chartDescription?.enabled = false
        barGraphVw.extraBottomOffset = 20
    }
    
}
