//
//  SummaryForApprovalController.swift
//  mocs
//
//  Created by Talat Baig on 12/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import SwiftyJSON


class SummaryForApprovalController: UIViewController {

    var pieDataEntry:[PieChartDataEntry] = []
    var barDataEntry: [BarChartDataEntry] = []
    let buUnit = ["Rice", "Sugar", "Roastry", "Grains & Feed", "Transportation", "Management" , "Premium Rice", "Pharma Chemicals", "Premium Rice", "Pharma Chemicals", "Premium Rice", "Pharma Chemicals" , "ppp"]

    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PieChartEntryCell", bundle: nil), forCellReuseIdentifier: "pieentry")
        self.tableView.register(UINib(nibName: "BarGraphEntryCell", bundle: nil), forCellReuseIdentifier: "bargraph")
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Sales Contract"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populatePieChartData()
        populateBarChartData()
        self.tableView.reloadData()

//        self.tableView.separatorStyle = .none
    }
    
    func populatePieChartData() {
    
        let jsonArr : [[String:String]] = [["Company Name" : "Phoenic Global DMCC", "Value" : "100.0"],[ "Company Name" : "PCL Foods LTD","Value" : "10.0"],[ "Company Name" : "Agriex Cameroon","Value" : "60.0"], ["Company Name" : "Agriex Cote d ivoire","Value" : "200.0"], ["Company Name" : "Mozcom Logistics","Value" : "90.0"]]
        
        self.pieDataEntry.removeAll()
        
        if jsonArr.count > 0 {

            for newObj in jsonArr {
                let name = newObj["Company Name"]
                if let lat = newObj["Value"], let doubleLat = Double(lat) {
                    self.pieDataEntry.append(PieChartDataEntry(value: doubleLat , label: name))
                }
            }
        }
    }
    
//    func setChart(dataPoints: [String], values: [Double]) {
//
//        var dataEntries: [BarChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
//            barDataEntry.append(dataEntry)
//        }
//
//        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Pending Approvals")
//        let chartData =  BarChartData(dataSet: chartDataSet)
//        setChartData()
//    }
    
    
    
    func populateBarChartData() {
        
//        let buUnit = ["Rice", "Sugar", "Roastry", "Grains & Feed", "Transportation", "Management" , " Premium Rice", "Pharma Chemicals" ]
        let paValue = [60.0, 40.0, 30.0, 20.0, 10.0, 5.0, 30.0 , 24.0, 20.0, 10.0, 5.0, 30.0 , 24.0]
        
        self.barDataEntry.removeAll()
        
        for i in 0..<self.buUnit.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: paValue[i])
            self.barDataEntry.append(dataEntry)
        }
    }
    
    
    
}


// MARK: - UITableViewDataSource methods
extension SummaryForApprovalController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pieDataEntry.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        switch section {
        case 0: return 1
            
          
        case 1:  return 2
            
           
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0.0
        
        switch indexPath.section {
            
        case 0: height = 320
            break
        case 1:  height = 300
            break
            
        default: height = 320
            break
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pieentry") as! PieChartEntryCell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.setupDataToViews(dataEntry: self.pieDataEntry)
            cell.isUserInteractionEnabled = false
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bargraph") as! BarGraphEntryCell
            cell.setupDataToViews(dataEntry: self.barDataEntry, arrLabel: self.buUnit )
            cell.selectionStyle = .none
            return cell
        }
        
    }
}

// MARK: - UITableViewDelegate methods
extension SummaryForApprovalController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

// MARK: - WC_HeaderViewDelegate methods
extension SummaryForApprovalController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
