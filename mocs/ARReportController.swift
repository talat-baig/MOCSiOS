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

class ARReportController: UIViewController , filterViewDelegate ,clearFilterDelegate{
    
    @IBOutlet weak var tblVwARReport: UITableView!
    var dataEntry:[PieChartDataEntry] = []
    var arOverallData : AROverallData?
    var arListData = [ARListData]()

    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var collVw: UICollectionView!

    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVwARReport.register(UINib(nibName: "AROverall", bundle: nil), forCellReuseIdentifier: "overAllCell")
        self.tblVwARReport.register(UINib(nibName: "ARChart", bundle: nil), forCellReuseIdentifier: "chartCell")
        self.tblVwARReport.register(UINib(nibName: "ARList", bundle: nil), forCellReuseIdentifier: "listCell")
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fetchAllARData))
        tblVwARReport.addSubview(refreshControl)
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        flowLayout.minimumInteritemSpacing = 5.0
//        collVw.collectionViewLayout = flowLayout
        
        Helper.setupCollVwFitler(collVw: self.collVw)

        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self

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
    
    
    
    func resetData() {
        self.arOverallData = nil
        self.arListData.removeAll()
        self.dataEntry.removeAll()
    }
    
    func applyFilter(filterString: String) {
        
        if !dataEntry.isEmpty || arOverallData != nil || !arListData.isEmpty {
           self.resetData()
        }
        self.fetchAllARData()
        self.collVw.reloadData()
    }
    
    func clearAll() {
        self.collVw.reloadData()
        self.fetchAllARData()
    }
    
    
    func stop() {
        guard progressTimer != nil else { return }
        progressTimer?.invalidate()
        progressTimer = nil
    }
    

    
    @objc func fetchAllARData() {
        
        var messg = ""
        let arrFilterString = ["35+Ivory Coast+06", "25+Dubai+06"]
        
        
        
        if FilterViewController.getFilterString().contains(",") {
            Helper.showMessage(message: "Please select only one filter")
            self.collVw.reloadData()
            if !dataEntry.isEmpty || arOverallData != nil || !arListData.isEmpty {
                self.resetData()
            }
            self.refreshControl.endRefreshing()
            return
        }
        
        if internetStatus != .notReachable {
            
            let url1 = String.init(format: Constant.AR.OVERALL, Session.authKey,
                                   Helper.encodeURL(url : FilterViewController.getFilterString()))
            
            let url2 = String.init(format: Constant.AR.CHART, Session.authKey,
                                   Helper.encodeURL(url :  FilterViewController.getFilterString()))
            
            let url3 = String.init(format: Constant.AR.LIST, Session.authKey,
                                   Helper.encodeURL(url :  FilterViewController.getFilterString()))
            
            print(url1)
            
            var request = URLRequest(url: URL(string: url1)!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 180 // 180 seconds
            
            if  arrFilterString.contains(FilterViewController.getFilterString()){
                messg = "This Report is at a delay of 1 Hour of current time due to large data"
            } else {
                 messg = "This Report is Live"
            }
                
            self.view.showLoadingWithMessage(messg: messg)

            Alamofire.request(request as  URLRequestConvertible).responseData(completionHandler: ({ response in
                if Helper.isResponseValid(vc: self, response: response.result) {
                    
                    let ovrAllResp = JSON(response.result.value!)
                    
                    if  (ovrAllResp.arrayObject?.isEmpty)! {
                        self.view.hideLoadingProgressLoader()
                        self.resetData()
                        self.tblVwARReport.reloadData()
                        
                        self.refreshControl.endRefreshing()
                        Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, reports: ModName.isReport, action: #selector(self.fetchAllARData))
                        return
                    } else {
                        
                        Alamofire.request(url2).responseData(completionHandler: ({ response in
                            if Helper.isResponseValid(vc: self, response: response.result) {
                                let chartResponse = JSON(response.result.value!)
                                
                                if  (chartResponse.arrayObject?.isEmpty)! {
                                    self.view.hideLoadingProgressLoader()
                                    self.refreshControl.endRefreshing()
                                    self.resetData()
                                    self.tblVwARReport.reloadData()
                                    Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, reports: ModName.isReport, action: #selector(self.fetchAllARData))
                                    return
                                } else {
                                    Alamofire.request(url3).responseData(completionHandler: ({ response in
                                        
                                        if Helper.isResponseValid(vc: self, response: response.result){
                                            let listResponse = JSON(response.result.value!)
                                            
                                            self.view.hideLoadingProgressLoader()
                                            self.refreshControl.endRefreshing()
                                            
                                            if  (listResponse.arrayObject?.isEmpty)! {
                                                Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, reports: ModName.isReport, action: #selector(self.fetchAllARData))
                                                return
                                            } else {
                                                
                                                self.populateOverallData(respJson: ovrAllResp)
                                                self.populateChartData(respJson: chartResponse)
                                                self.populateListData(respJson: listResponse)
                                                self.tblVwARReport.tableFooterView = nil
                                                self.tblVwARReport.reloadData()
                                            }
                                        } else {
                                            self.view.hideLoadingProgressLoader()
                                            self.refreshControl.endRefreshing()
                                            self.resetData()
                                            self.tblVwARReport.reloadData()
                                            Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, reports: ModName.isReport, action: #selector(self.fetchAllARData))
                                        }
                                    }))
                                }
                            } else {
                                self.view.hideLoadingProgressLoader()
                                self.refreshControl.endRefreshing()
                                self.resetData()
                                self.tblVwARReport.reloadData()
                                Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, reports: ModName.isReport, action: #selector(self.fetchAllARData))
                            }
                        }))
                    }
                } else {
                    self.view.hideLoadingProgressLoader()
                    self.refreshControl.endRefreshing()
                    self.resetData()
                    self.tblVwARReport.reloadData()
                    Helper.showNoFilterState(vc: self, tb: self.tblVwARReport, reports: ModName.isReport, action: #selector(self.showFilterMenu))
                }
            }))
            
        } else {
            Helper.showNoInternetMessg()
            self.resetData()
            self.tblVwARReport.reloadData()
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
        
        if dataEntry.count > 0 {
            tableView.backgroundView?.isHidden = true
//            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
//            tableView.separatorStyle = .none
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
        case 2:
             return self.arListData.count
        default:
            return 0
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
//            print("Overall height" , height)
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
            cell.setDataToViews(dataEntry: self.dataEntry, strTxt: String(format : "TOP %d COUNTER PARTIES",self.dataEntry.count))
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


extension ARReportController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterViewController.selectedDataObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionCell", for: indexPath as IndexPath) as! FilterCollectionViewCell
        let newObj = FilterViewController.selectedDataObj[indexPath.row]
        let  newStr = (newObj.company?.compName)! + "|" + (newObj.location?.locName)! + "|" +  newObj.name!
        cell.lblTitle.text = newStr
        cell.lblTitle.preferredMaxLayoutWidth = 100
        return cell
    }
    
    func collectionView(_ collectionView : UICollectionView,layout  collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        let newObj = FilterViewController.selectedDataObj[indexPath.row]
        let  newStr = (newObj.company?.compName)! + "|" + (newObj.location?.locName)! + "|" +  newObj.name!
        let size: CGSize = newStr.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0)])
        return size
    }
    
    
}

