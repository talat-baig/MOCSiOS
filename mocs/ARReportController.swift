//
//  ARReportController.swift
//  mocs
//
//  Created by Admin on 3/9/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import SwiftyJSON

class ARReportController: UIViewController , filterViewDelegate{
    
    @IBOutlet weak var tblVwARReport: UITableView!
    var dataEntry:[PieChartDataEntry] = []
    var arOverallData : AROverallData?
    var arListData = [ARListData]()
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVwARReport.register(UINib(nibName: "AROverall", bundle: nil), forCellReuseIdentifier: "overAllCell")
        self.tblVwARReport.register(UINib(nibName: "ARChart", bundle: nil), forCellReuseIdentifier: "chartCell")
        self.tblVwARReport.register(UINib(nibName: "ARList", bundle: nil), forCellReuseIdentifier: "listCell")
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fetchAllARData))
        tblVwARReport.addSubview(refreshControl)
        
        FilterViewController.filterDelegate = self
        fetchAllARData()
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Accounts Receivables"
        vwTopHeader.lblSubTitle.isHidden = true
      
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func cancelFilter(filterString: String) {
        self.fetchAllARData()
    }
    
    
    func applyFilter(filterString: String) {
        
        if !dataEntry.isEmpty || arOverallData != nil || !arListData.isEmpty {
            dataEntry.removeAll()
            arOverallData = nil
            arListData.removeAll()
        }
        self.fetchAllARData()
    }
    
    
    @objc func fetchAllARData() {
//        print(FilterViewController.getFilterString())
        if internetStatus != .notReachable {
            var isRespOverallValid = true
            var isRespARListValid = true
            var isRespChartValid = true
            
            let group = DispatchGroup()
            self.view.showLoading()
            group.enter()
            
            let url1 = String.init(format: Constant.AR.OVERALL, Session.authKey,
                                   Helper.encodeURL(url : FilterViewController.getFilterString()))
            Alamofire.request(url1).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
//                    isRespOverallValid = true
                    var jsonResponse = JSON(response.result.value!)
                    
                    if  (jsonResponse.arrayObject?.isEmpty)! {
                        isRespOverallValid = false
                        Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, isARReport: true, action: #selector(self.showFilterMenu))
                        
                        return
                    } else {
                         isRespOverallValid = true
                        /// Modified
                        self.tblVwARReport.tableFooterView = nil
                        self.populateOverallData(respJson: jsonResponse)
                    }
                } else {
                    isRespOverallValid = false
                    Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, isARReport: true, action: #selector(self.showFilterMenu))
                    
                }
            }))
            
            group.enter()
            let url2 = String.init(format: Constant.AR.CHART, Session.authKey,
                                   Helper.encodeURL(url :  FilterViewController.getFilterString()))
            Alamofire.request(url2).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result) {
//                    isRespChartValid = true
                    var jsonResponse = JSON(response.result.value!)
                    
                    if  (jsonResponse.arrayObject?.isEmpty)! {
                        isRespChartValid = false
                        Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, isARReport: true, action: #selector(self.showFilterMenu))
                        return
                    } else {
                         isRespChartValid = true
                        /// Modified
                        self.tblVwARReport.tableFooterView = nil
                        self.populateChartData(respJson : jsonResponse)
                    }
                } else {
                    isRespChartValid = false
                    Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, isARReport: true, action: #selector(self.showFilterMenu))
                    
                }
            }))
            
            
            group.enter()
            let url3 = String.init(format: Constant.AR.LIST, Session.authKey,
                                   Helper.encodeURL(url :  FilterViewController.getFilterString()))
            Alamofire.request(url3).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
//                    isRespARListValid = true
                    var jsonResponse = JSON(response.result.value!)
                    
                    if  (jsonResponse.arrayObject?.isEmpty)! {
                        isRespARListValid = false
                        Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, isARReport: true, action: #selector(self.showFilterMenu))
                        return
                    } else {
                         isRespARListValid = true
                        /// Modified
                        self.tblVwARReport.tableFooterView = nil
                        self.populateListData(respJson: jsonResponse)
                    }
                } else {
                    isRespARListValid = false
                    Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, isARReport: true, action: #selector(self.showFilterMenu))
                }
            }))
            
            print(FilterViewController.getFilterString())
            group.notify(queue: .main) {
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if isRespARListValid && isRespChartValid && isRespOverallValid {
                    /// Modified
                    self.tblVwARReport.tableFooterView = nil
                    self.tblVwARReport.reloadData()
                } else {
                    if !self.dataEntry.isEmpty || self.arOverallData != nil || !self.arListData.isEmpty {
                        self.dataEntry.removeAll()
                        self.arOverallData = nil
                        self.arListData.removeAll()
                    }
                    self.tblVwARReport.reloadData()
                    Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, isARReport: true, action: #selector(self.showFilterMenu))
                }
//                  self.tblVwARReport.reloadData()
            }
        } else {
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: self.tblVwARReport, action: #selector(self.fetchAllARData))
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    func populateOverallData (respJson : JSON) {
        
        self.arOverallData = nil
        
        for(_,i):(String,JSON)  in respJson {
            let overAllData = AROverallData()
            overAllData.amtRecievable = i["Total Amount Receivable (USD)"].stringValue
            overAllData.totalInvQnty = i["Total Invoice Quantity (MT)"].stringValue
            
            let jsonTotalAmt = i["Total Amount Received"].stringValue
            let subJson1 = JSON.init(parseJSON:jsonTotalAmt)
            
            for(_,k):(String,JSON) in subJson1 {
                let newDetails = AmountDetails()
                newDetails.currency = k["Currency"].stringValue
                newDetails.amount = k["Amount Received"].stringValue
                overAllData.totalAmtRecieved.append(newDetails)
            }
            
            let jsonInvVal = i["Total Invoice Value"].stringValue
            let subJson2 = JSON.init(parseJSON:jsonInvVal)
            for(_,k):(String,JSON) in subJson2 {
                let newDetails = AmountDetails()
                newDetails.currency = k["Currency"].stringValue
                newDetails.amount = k["Invoice Value"].stringValue
                overAllData.totalInvValue.append(newDetails)
            }
            self.arOverallData = overAllData
        }
    }
    
    func populateChartData (respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        
        self.dataEntry.removeAll()
        if jsonArr.count > 0 {
//            self.dataEntry.removeAll()
            
            for i in 0..<jsonArr.count {
                
                let name = respJson[i]["Counterparty/Buyer"].stringValue
                let amt = Double(respJson[i]["Amount Received (USD)"].stringValue)
                self.dataEntry.append(PieChartDataEntry(value: amt!, label: name))
            }
        }
    }
    
    /// Populate Account reports list data and assign to array of List data.
    func populateListData (respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        
        self.arListData.removeAll()

        if jsonArr.count > 0 {
//            self.arListData.removeAll()
            
            for i in 0..<jsonArr.count {
                
                let newARListObj = ARListData()
                newARListObj.location = respJson[i]["Location"].stringValue
                newARListObj.company = respJson[i]["Company"].stringValue
                newARListObj.bVertical = respJson[i]["Business Vertical"].stringValue
                
                newARListObj.amtRecievable = respJson[i]["Total Amount Receivable (USD)"].stringValue
                newARListObj.invQnty = respJson[i]["Total Invoice Quantity (MT)"].stringValue
                
                let jsonTotalAmt = respJson[i]["Total Amount Received"].stringValue
                let subJson1 = JSON.init(parseJSON:jsonTotalAmt)
                for(_,k):(String,JSON) in subJson1 {
                    let newDetails = AmountDetails()
                    newDetails.currency = k["Currency"].stringValue
                    newDetails.amount = k["Amount Received"].stringValue
                    newARListObj.amtRecieved.append(newDetails)
                }
                
                let jsonInvVal = respJson[i]["Total Invoice Value"].stringValue
                let subJson2 = JSON.init(parseJSON:jsonInvVal)
                for(_,k):(String,JSON) in subJson2 {
                    let newDetails = AmountDetails()
                    newDetails.currency = k["Currency"].stringValue
                    newDetails.amount = k["Invoice Value"].stringValue
                    newARListObj.invValue.append(newDetails)
                }
                self.arListData.append(newARListObj)
            }
        }
    }
}

// MARK: - UITableViewDataSource methods
extension ARReportController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataEntry.count > 0{
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        switch section {
        case 0:
            if self.arOverallData != nil {
                return 1
            } else {
                return 0
            }
        case 1:
            if self.dataEntry.count > 0 {
                return 1
            } else {
                return 0
            }
        default:
            return self.arListData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0.0
        
        switch indexPath.section {
            
        case 0:
            if let amtCount = self.arOverallData?.totalAmtRecieved.count {
                let invValCount = self.arOverallData?.totalInvValue.count
                
                if amtCount > 2 {
                    height = 275
                } else if amtCount < 3 && invValCount == 0 {
                    height = 210
                } else {
                    height = 225
                }
            }
            break
        case 1:  height = 300
            break
            
        case 2:
            let amtCount = self.arListData[indexPath.row].amtRecieved.count
            let invValCount = self.arListData[indexPath.row].invValue.count
            
            if amtCount > 2 {
                height = 350
            } else if amtCount < 3 && invValCount == 0 {
                height = 290
            } else {
                height = 320
            }
            
        default: height = 320
            break
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tblVwARReport.dequeueReusableCell(withIdentifier: "overAllCell") as! AROverallCell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.setDataToViews(data: self.arOverallData!)
            cell.isUserInteractionEnabled = false
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tblVwARReport.dequeueReusableCell(withIdentifier: "chartCell") as! ARChartCell
            cell.setDataToViews(dataEntry: self.dataEntry)
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = tblVwARReport.dequeueReusableCell(withIdentifier: "listCell") as! ARListCell
            cell.setDataToViews(data : self.arListData[indexPath.row])
            cell.selectionStyle = .none
            return cell
            
        }
    }
}

// MARK: - UITableViewDelegate methods
extension ARReportController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            let arCPVC = self.storyboard?.instantiateViewController(withIdentifier: "ARCounterPartyController") as! ARCounterPartyController
            arCPVC.company = arListData[indexPath.row].company
            arCPVC.location = arListData[indexPath.row].location
            arCPVC.bUnit = arListData[indexPath.row].bVertical
            
            self.navigationController?.pushViewController(arCPVC, animated: true)
            
        } else {
            
        }
        
    }
}

// MARK: - WC_HeaderViewDelegate methods
extension ARReportController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}

