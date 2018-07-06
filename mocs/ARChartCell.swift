//
//  ARChartCell.swift
//  mocs
//
//  Created by Talat Baig on 4/4/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Charts

class ARChartCell: UITableViewCell {
    
    @IBOutlet weak var arPieChart: PieChartView!
    @IBOutlet weak var outerVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup(pieChartView: arPieChart)
    }
    
    func setup(pieChartView chartView: PieChartView) {
        
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.drawCenterTextEnabled = true
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        l.textColor = .white
    }
    
    /// Method that set data from array of elements of type PieChartDataEntry to views.
    /// - Parameter dataEntry: Array of PieChartDataEntry elements
    func setDataToViews(dataEntry : [PieChartDataEntry] ) {
        
        let strTxt = String(format : "TOP %d COUNTER PARTIES", dataEntry.count)
        let nsRange = NSString(string: strTxt).range(of: strTxt, options: String.CompareOptions.caseInsensitive)
        let nsRange2 = NSString(string: strTxt).range(of: "PARTIES", options: String.CompareOptions.caseInsensitive)
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string:strTxt )

        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Medium", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: nsRange2)
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Medium", size: 13)!,
                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: nsRange)
        
        arPieChart.centerAttributedText = centerText
        
        let set = PieChartDataSet(values: dataEntry, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.4
        set.yValuePosition = .outsideSlice
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        //        let pFormatter = NumberFormatter()
        //        pFormatter.numberStyle = .percent
        //        pFormatter.maximumFractionDigits = 1
        //        pFormatter.multiplier = 1
        //        pFormatter.percentSymbol = " %"
        //        data.se tValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        //
        //        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        //        data.setValueTextColor(.white)
        arPieChart.drawEntryLabelsEnabled = false
        arPieChart.data = data
        arPieChart.reloadInputViews()
        arPieChart.animate(xAxisDuration: 1.4)
        arPieChart.highlightValues(nil)
    }
    
}
