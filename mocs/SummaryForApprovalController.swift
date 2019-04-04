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

    var paSummObj : [PASummaryData] = []
    
    var modName : ModName?
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fecthAllSummaryData))
        tableView.addSubview(refreshControl)
        
        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
//        vwTopHeader.lblTitle.text =  Helper.getNavTitleString(modName : self.modName ?? ModName.isDefault)
        vwTopHeader.lblTitle.text =  "Delivery Orders - Approval"

        vwTopHeader.lblSubTitle.isHidden = true
        
        self.tableView.register(UINib(nibName: "BarGraphEntryCell", bundle: nil), forCellReuseIdentifier: "barcell")
        self.tableView.register(UINib(nibName: "PieChartEntryCell", bundle: nil), forCellReuseIdentifier: "piecell")
        
        self.fecthAllSummaryData()
    }
    
    
   
    
    
    func cancelFilter(filterString: String) {
        pieDataEntry.removeAll()
        self.paSummObj.removeAll()
    }
    
    func applyFilter(filterString: String) {
        
        if !pieDataEntry.isEmpty  {
            pieDataEntry.removeAll()
            self.paSummObj.removeAll()
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
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: #selector(self.showFilterMenu))
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
                                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: #selector(self.showFilterMenu))
                                    return
                                } else {
                                    self.parsePieChartData(respJson: url1Resp)
                                    self.parseBarChartData(respJson: url2Resp)
                                    
                                    self.tableView.tableFooterView = nil
                                    self.tableView.reloadData()
                                }
                            } else {
                                self.resetData()
                                self.refreshControl.endRefreshing()
                                self.tableView.reloadData()
                                Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: #selector(self.showFilterMenu))
                            }
                        }))
                        
                    }
                } else {
                    self.resetData()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: #selector(self.showFilterMenu))
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
        self.paSummObj.removeAll()
        self.pieDataEntry.removeAll()
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
 
    func parsePieChartData(respJson : JSON) {
        
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
    
 
    // chartData
    func parseBarChartData(respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        self.paSummObj.removeAll()

        if jsonArr.count > 0 {
            
            for i in 0..<jsonArr.count {
            
                let pcSummry = PASummaryData()

                let cName = respJson[i]["Company"].stringValue //Comp Name
                
                ///////***************************////////
                let bUnitStr = respJson[i]["BusinessUnit"].stringValue // bUnit
                let strArr = bUnitStr.components(separatedBy: ",")
                
                var arrFilterString : [String] = []
                var arrBName : [String] = []
                var arrBVal : [String] = []
                var arrDataEntry : [BarChartDataEntry] = []

                for k in 0..<strArr.count {
                    
                    let buArr = strArr[k].components(separatedBy: "+")
                    
                    let bName = buArr[0]
                    let pndApprvl = buArr[1]
                    let pa = Double(pndApprvl)
                    
                    arrBName.append(bName)
                    arrBVal.append(pndApprvl)
                    
                    let dataEntry = BarChartDataEntry(x: Double(k), y: pa ?? 0)
                    arrDataEntry.append(dataEntry)

                }
                
                ///////***************************////////
                let selFilterStr = respJson[i]["SelectedFilter"].stringValue // Filter String in 25+Dubai+06 format
                let fltrStr = selFilterStr.components(separatedBy: ",")
                pcSummry.filterString = fltrStr
                
                pcSummry.compName = cName
                pcSummry.bNames = arrBName
                pcSummry.bValues = arrBVal
                pcSummry.barDataEntry = arrDataEntry

                self.paSummObj.append(pcSummry)
            }
        }
    }
    

    @objc func openPendingApprovals(sender:UIButton) {
        
        let doVC = UIStoryboard(name: "DeliveryOrder", bundle: nil).instantiateViewController(withIdentifier: "DeliveryOrderController") as! DeliveryOrderController
//        doVC.filterString = self.paSummObj[sender.tag].filterString.joined(separator: ",")
        self.navigationController?.pushViewController(doVC, animated: true)
        
    }
    
}


// MARK: - UITableViewDataSource methods
extension SummaryForApprovalController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.paSummObj.count > 0  {
            tableView.backgroundView?.isHidden = true
            return (self.paSummObj.count + 1)
        } else {
            tableView.backgroundView?.isHidden = false
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0.0
        
        switch indexPath.row {
            
        case 0: height = 300
            break
            
        default: height = 320
            break
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "piecell") as! PieChartEntryCell
            cell.setDataToViews(dataEntry: self.pieDataEntry, strTxt: "Pending Approvals [Company-wise]")
            cell.layer.masksToBounds = true
            cell.selectionStyle = .none
            cell.layer.cornerRadius = 5
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "barcell") as! BarGraphEntryCell
            cell.btnOpenPA.tag = indexPath.row - 1
            
            cell.btnOpenPA.addTarget(self, action: #selector(self.openPendingApprovals(sender:)), for: UIControl.Event.touchUpInside)

            let titleStr = String(format:"Pending Approvals for %@ [Product-wise]",self.paSummObj[indexPath.row - 1].compName)

            cell.setupDataToViews(dataEntry: self.paSummObj[indexPath.row - 1 ].barDataEntry, arrLabel: self.paSummObj[indexPath.row - 1].bNames, arrValues: self.paSummObj[indexPath.row - 1].bValues, lblTitle: titleStr )
            
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
