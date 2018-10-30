//
//  APReportController.swift
//  mocs
//
//  Created by Talat Baig on 10/22/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import SwiftyJSON

class APReportController: UIViewController , filterViewDelegate {
    
    var dataEntry:[PieChartDataEntry] = []
    var apData : APListData?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "APOverallCell", bundle: nil), forCellReuseIdentifier: "overallcell")
        
        self.tableView.register(UINib(nibName: "ARChart", bundle: nil), forCellReuseIdentifier: "chartcell")
        
        self.tableView.register(UINib(nibName: "APListCell", bundle: nil), forCellReuseIdentifier: "listcell")
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fetchAllAPData))
        tableView.addSubview(refreshControl)
        
        FilterViewController.filterDelegate = self
        fetchAllAPData()
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Accounts Payable"
        vwTopHeader.lblSubTitle.isHidden = true
        //        self.tableView.tableFooterView = nil
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func fetchAllAPData() {

        if internetStatus != .notReachable {

            let url1 = String.init(format: Constant.AP.AP_OVERALL, Session.authKey,
                                   Helper.encodeURL(url : FilterViewController.getFilterString()))

            let url2 = String.init(format: Constant.AP.AP_CHART, Session.authKey,
                                   Helper.encodeURL(url :  FilterViewController.getFilterString()))

            var request = URLRequest(url: URL(string: url1)!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 180

            let messg = "This Report is Live"

            self.view.showLoadingWithMessage(messg: messg)

            Alamofire.request(request as  URLRequestConvertible).responseData(completionHandler: ({ response in
                if Helper.isResponseValid(vc: self, response: response.result) {

                    let ovrAllResp = JSON(response.result.value!)

                    self.view.hideLoadingProgressLoader()
                    self.refreshControl.endRefreshing()

                    if  (ovrAllResp.arrayObject?.isEmpty)! {
                        Helper.showNoFilterState(vc: self, tb: self.tableView, isAPReport: true, action: #selector(self.showFilterMenu))
                        return
                    } else {

                        Alamofire.request(url2).responseData(completionHandler: ({ response in
                            if Helper.isResponseValid(vc: self, response: response.result) {
                                let chartResponse = JSON(response.result.value!)

                                if  (chartResponse.arrayObject?.isEmpty)! {
                                    self.view.hideLoadingProgressLoader()
                                    self.refreshControl.endRefreshing()
                                    self.resetData()
                                    self.tableView.reloadData()
                                    Helper.showNoFilterState(vc: self, tb: self.tableView, isAPReport: true, action: #selector(self.showFilterMenu))
                                    return
                                } else {

                                    self.populateOverallData(respJson: ovrAllResp)
                                    self.populateChartData(respJson: chartResponse)
                                    self.tableView.tableFooterView = nil
                                    self.tableView.reloadData()
                                }
                            } else {
                                self.view.hideLoadingProgressLoader()
                                self.refreshControl.endRefreshing()
                                self.resetData()
                                self.tableView.reloadData()
                                Helper.showNoFilterState(vc: self, tb: self.tableView, isAPReport: true, action: #selector(self.showFilterMenu))
                            }
                        }))
                    }
                } else {
                    self.view.hideLoadingProgressLoader()
                    self.refreshControl.endRefreshing()
                    self.resetData()
                    self.tableView.reloadData()
                    Helper.showNoFilterState(vc: self, tb: self.tableView, isAPReport: true, action: #selector(self.showFilterMenu))
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            self.resetData()
            self.tableView.reloadData()
            Helper.showNoInternetState(vc: self, tb: self.tableView, action: #selector(self.fetchAllAPData))
            self.refreshControl.endRefreshing()
        }
    }
    
    
    
//    @objc func fetchAllAPData() {
//
//        if internetStatus != .notReachable {
//            var isRespOverallValid = true
//            var isRespChartValid = true
//
//            let group = DispatchGroup()
//            self.view.showLoading()
//            group.enter()
//
//            let url1 = String.init(format: Constant.AP.AP_OVERALL, Session.authKey,
//                                   Helper.encodeURL(url : FilterViewController.getFilterString()))
//
//
//            Alamofire.request(url1).responseData(completionHandler: ({ response in
//                group.leave()
//                if Helper.isResponseValid(vc: self, response: response.result){
//
//                    var jsonResponse = JSON(response.result.value!)
//
//                    if  (jsonResponse.arrayObject?.isEmpty)! {
//                        isRespOverallValid = false
//                        Helper.showNoFilterState(vc: self, tb: self.tableView, isARReport: true, action: #selector(self.showFilterMenu))
//                        return
//                    } else {
//                        isRespOverallValid = true
//                        /// Modified
//                        self.tableView.tableFooterView = nil
//                        self.populateOverallData(respJson: jsonResponse)
//                    }
//                } else {
//                    isRespOverallValid = false
//                    Helper.showNoFilterState(vc: self, tb: self.tableView, isARReport: true, action: #selector(self.showFilterMenu))
//
//                }
//            }))
//
//            group.enter()
//
//            let url2 = String.init(format: Constant.AP.AP_CHART, Session.authKey,   Helper.encodeURL(url :  FilterViewController.getFilterString()))
//
//            Alamofire.request(url2).responseData(completionHandler: ({ response in
//                group.leave()
//                if Helper.isResponseValid(vc: self, response: response.result) {
//                    //                    isRespChartValid = true
//                    var jsonResponse = JSON(response.result.value!)
//
//                    if  (jsonResponse.arrayObject?.isEmpty)! {
//                        isRespChartValid = false
//                        Helper.showNoFilterState(vc: self, tb: self.tableView, isARReport: true, action: #selector(self.showFilterMenu))
//                        return
//                    } else {
//                        isRespChartValid = true
//                        /// Modified
//                        self.tableView.tableFooterView = nil
//                        self.populateChartData(respJson : jsonResponse)
//                    }
//                } else {
//                    isRespChartValid = false
//                    Helper.showNoFilterState(vc: self, tb: self.tableView, isARReport: true, action: #selector(self.showFilterMenu))
//
//                }
//            }))
//
//            print(FilterViewController.getFilterString())
//            group.notify(queue: .main) {
//                self.view.hideLoading()
//                self.refreshControl.endRefreshing()
//
//                if isRespOverallValid && isRespChartValid {
//                    /// Modified
//                    self.tableView.tableFooterView = nil
//                    self.tableView.reloadData()
//                } else {
//                    if !self.dataEntry.isEmpty || self.apData != nil {
//                        self.dataEntry.removeAll()
//                        self.apData = nil
//                    }
//                    self.tableView.reloadData()
//                    Helper.showNoFilterState(vc: self, tb: self.tableView, isARReport: true, action: #selector(self.showFilterMenu))
//                }
//            }
//        } else {
//            Helper.showNoInternetMessg()
//            Helper.showNoInternetState(vc: self, tb: self.tableView, action: #selector(self.fetchAllAPData))
//            self.refreshControl.endRefreshing()
//        }
//    }

    
    func populateOverallData (respJson : JSON) {
        
        self.apData = nil
        
        for(_,i):(String,JSON)  in respJson {
            let apData = APListData()
            apData.company = i["Company"].stringValue
            apData.location = i["Location"].stringValue
            apData.bVertical = i["Business Vertical"].stringValue
            apData.balPayable = i["Balance Payable (USD)"].stringValue
            
            let jsonTotalAmt = i["Total Invoice Value"].stringValue
            let subJson1 = JSON.init(parseJSON:jsonTotalAmt)
            
            for(_,k):(String,JSON) in subJson1 {
                let newDetails = AmountDetails()
                newDetails.currency = k["Currency"].stringValue
                newDetails.amount = k["Amount Received"].stringValue
                apData.totalInvoice.append(newDetails)
            }
            self.apData = apData
        }
    }
    
    
    func populateChartData (respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        self.dataEntry.removeAll()
        if jsonArr.count > 0 {
            
            for i in 0..<jsonArr.count {
                let name = respJson[i]["Counteparty Name"].stringValue
                let amt = Double(respJson[i]["Balance Payable (USD)"].stringValue)
                self.dataEntry.append(PieChartDataEntry(value: amt!, label: name))
            }
        }
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    
    func cancelFilter(filterString: String) {
        self.fetchAllAPData()
    }
    
    func applyFilter(filterString: String) {
        
        if !dataEntry.isEmpty || apData != nil {
            dataEntry.removeAll()
            apData = nil
        }
        
        if filterString.contains(",") {
            Helper.showMessage(message: "Please select only one filter")
            return
        }
        self.fetchAllAPData()
    }
    
    func resetData() {
        self.apData = nil
        self.dataEntry.removeAll()
    }
}

// MARK: - UITableViewDataSource methods
extension APReportController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.dataEntry.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        switch section {
        case 0,2:
            if self.apData != nil {
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
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0.0
        
        switch indexPath.section {
            
        case 0:
            if let invCount = self.apData?.totalInvoice.count {
                
                if invCount > 2 {
                    height = 200
                } else {
                    height = 150
                }
            }
            break
        case 1:  height = 300.0
            break
        case 2:
            if let invCount = self.apData?.totalInvoice.count {
                
                if invCount > 2 {
                    height = 280
                } else {
                    height = 230
                }
            }
            break
        default: height = 200.0
            break
        }
        return height
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "overallcell") as! APOverallCell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.isUserInteractionEnabled = false
            cell.setDataToViews(data: self.apData!)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartcell") as! ARChartCell
            cell.setDataToViews(dataEntry: self.dataEntry)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listcell") as! APListCell
            cell.setDataToViews(data: self.apData!)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let apCPVC = self.storyboard?.instantiateViewController(withIdentifier: "APCounterpartyController") as! APCounterpartyController
            self.navigationController?.pushViewController(apCPVC, animated: true)
            
        } else {
        }
    }
    
}


// MARK: - WC_HeaderViewDelegate methods
extension APReportController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
