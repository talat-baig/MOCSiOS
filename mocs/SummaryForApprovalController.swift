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


class SummaryForApprovalController: UIViewController, filterViewDelegate,clearFilterDelegate {
    
    var pieDataEntry:[PieChartDataEntry] = []
    var barDataEntry: [BarChartDataEntry] = []
    var filterObj : [ApprovalFilterData] = []
    //    var compName: [String] = []
    //    var bUnit: [String] = []
    
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SSChartCell", bundle: nil), forCellReuseIdentifier: "bargraph")
        
        self.navigationController?.isNavigationBarHidden = true
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fecthAllSummaryData))
        tableView.addSubview(refreshControl)
        
        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Delivery Order"
        vwTopHeader.lblSubTitle.isHidden = true
        
        self.fecthAllSummaryData()
        self.tableView.reloadData()
    }
    
    
    func cancelFilter(filterString: String) {
        self.fecthAllSummaryData()
    }
    
    func applyFilter(filterString: String) {
        
        if !pieDataEntry.isEmpty  {
            pieDataEntry.removeAll()
        }
        self.fecthAllSummaryData()
    }
    
    func clearAll() {
        self.fecthAllSummaryData()
    }
    
    @objc func fecthAllSummaryData() {
        
        if internetStatus != .notReachable {
            
            let url1 = String.init(format: Constant.DO.DO_SUMMARY_COMPANIES, Session.authKey,Helper.encodeURL(url : FilterViewController.getFilterString()))
            
            let url2 = String.init(format: Constant.DO.DO_SUMMARY_BU, Session.authKey, Helper.encodeURL(url :  FilterViewController.getFilterString()))
            
            self.view.showLoading()
            
            Alamofire.request(url1).responseData(completionHandler: ({ response in
                if Helper.isResponseValid(vc: self, response: response.result) {
                    let url1Resp = JSON(response.result.value!)
                    
                    self.view.hideLoading()
                    self.refreshControl.endRefreshing()
                    
                    if  (url1Resp.arrayObject?.isEmpty)! {
                        self.resetData()
                        self.tableView.reloadData()
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isApprovals, action: #selector(self.showFilterMenu))
                        return
                    } else {
                        Alamofire.request(url2).responseData(completionHandler: ({ response in
                            if Helper.isResponseValid(vc: self, response: response.result) {
                                let url2Resp = JSON(response.result.value!)
                                
                                self.view.hideLoading()
                                self.refreshControl.endRefreshing()
                                
                                if  (url2Resp.arrayObject?.isEmpty)! {
                                    self.resetData()
                                    self.tableView.reloadData()
                                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isApprovals, action: #selector(self.showFilterMenu))
                                    return
                                } else {
                                    self.parseAndAssignChartData(respJson: url1Resp)
                                    self.parseBarChartData(respJson: url2Resp)
                                    
                                    self.tableView.tableFooterView = nil
                                    self.tableView.reloadData()
                                }
                            } else {
                                self.resetData()
                                self.refreshControl.endRefreshing()
                                self.tableView.reloadData()
                                Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isApprovals, action: #selector(self.showFilterMenu))
                            }
                        }))
                        
                    }
                } else {
                    self.resetData()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isApprovals, action: #selector(self.showFilterMenu))
                }
            }))
        } else {
            self.resetData()
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(fecthAllSummaryData))
            self.refreshControl.endRefreshing()
        }
    }
    
    func resetData() {
        self.barDataEntry.removeAll()
        self.filterObj.removeAll()
        self.pieDataEntry.removeAll()
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    //  {"Company Code":25,"Company":"Phoenix Global DMCC","Location":"Dubai","Pending Contracts":17}]
    func parseAndAssignChartData(respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        self.pieDataEntry.removeAll()
        
        if jsonArr.count > 0 {
            
            for i in 0..<jsonArr.count {
                let cName = respJson[i]["Company"].stringValue
                let cPA = Double(respJson[i]["Pending Contracts"].stringValue)
                let cLoc = respJson[i]["Location"].stringValue
                
                let newStr = cName + "(" + cLoc + ")"
                self.pieDataEntry.append(PieChartDataEntry(value: cPA!, label: newStr))
            }
        }
    }
    
    //    {
    //    "Company Code":25,
    //    "Company":"Phoenix Global DMCC",
    //    "Location":"Dubai",
    //    "CompanyDetails":"[{\"Business Vertical.\":\" Rice\",\"Pending Contract\":\" 17\"}]"
    //    }
    //    {
    //    "Company Code":25,
    //    "Company":"Phoenix Global DMCC",
    //    "Location":"Dubai",
    //    "CompanyDetails":"[{"Business Vertical.":" Rice","Pending Contract":" 17"}]"
    //    }
    
    // chartData
    func parseBarChartData(respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        self.barDataEntry.removeAll()
        self.filterObj.removeAll()

        if jsonArr.count > 0 {
            let newFilter = ApprovalFilterData()
            
            for i in 0..<jsonArr.count {
                let compName = respJson[i]["Company"].stringValue //Comp Name
                let compLoc = respJson[i]["Location"].stringValue //Comp Location
                let compDetails = respJson[i]["CompanyDetails"].stringValue
                
                let newCompDetailJson = JSON.init(parseJSON: compDetails)
                let compDetailsArr = newCompDetailJson.arrayValue
                
                
                for item in compDetailsArr {
                    
                    let bussVertical = item["Business Vertical."].stringValue //BU
                    let pendApproval = item["Pending Contract"].stringValue //PA
                    
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(pendApproval) ?? 0 )
                    self.barDataEntry.append(dataEntry)
                    
                    newFilter.bUnit = bussVertical
                }
                
                newFilter.compName = compName
                newFilter.location = compLoc
                self.filterObj.append(newFilter)
            }
        }
    }
    
    
    
    
}


// MARK: - UITableViewDataSource methods
extension SummaryForApprovalController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pieDataEntry.count > 0 || filterObj.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        switch section {
        case 0: return pieDataEntry.count
            
        case 1: return filterObj.count
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "pieentry") as! ARChartCell
            cell.setDataToViews(dataEntry: self.pieDataEntry, strTxt: "Pending Approvals [Company-wise]")
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bargraph") as! SSChartCell
            let titleStr = String(format:"Pending Approvals for %@ [Product-wise]",self.filterObj[indexPath.row].compName)
            cell.setupDataToViews(dataEntry: self.barDataEntry, arrLabel: [self.filterObj[indexPath.row].bUnit], arrValues: [], lblTitle: titleStr )
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
