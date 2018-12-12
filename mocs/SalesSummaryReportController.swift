//
//  SalesSummaryReportController.swift
//  mocs
//
//  Created by Talat Baig on 12/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class SalesSummaryReportController: UIViewController, filterViewDelegate, clearFilterDelegate {
    
    var barDataEntry: [BarChartDataEntry] = []
    
    var ssData : SSListData?
    
    // Countrparty Names arry to show on Graph
    var cpNameArr : [String] = []
    
    // Countrparty Values arry to show on Graph
    var cpValuesArr : [String] = []
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var collVw: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SSOverallCell", bundle: nil), forCellReuseIdentifier: "overallcell")
        
        self.tableView.register(UINib(nibName: "SSChartCell", bundle: nil), forCellReuseIdentifier: "chartcell")
        
        self.tableView.register(UINib(nibName: "SSListCell", bundle: nil), forCellReuseIdentifier: "listcell")
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fetchAllSSData))
        tableView.addSubview(refreshControl)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 5.0
        collVw.collectionViewLayout = flowLayout
        
        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self
        
        fetchAllSSData()
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Sales Summary"
        vwTopHeader.lblSubTitle.isHidden = true

    }
    
    
    func clearAll() {
        self.collVw.reloadData()
        self.fetchAllSSData()
    }
    
    func applyFilter(filterString: String) {
        
        if !barDataEntry.isEmpty || ssData != nil {
            barDataEntry.removeAll()
            ssData = nil
        }
        
        if filterString.contains(",") {
            Helper.showMessage(message: "Please select only one filter")
            return
        }
        self.fetchAllSSData()
        self.collVw.reloadData()
    }
    
    func cancelFilter(filterString: String) {
        self.ssData = nil
        self.barDataEntry.removeAll()
    }
    
    @objc func fetchAllSSData() {
        
        if internetStatus != .notReachable {

            let url1 = String.init(format: Constant.SalesSummary.SS_OVERALL, Session.authKey,
                                   Helper.encodeURL(url : FilterViewController.getFilterString()))

            let url2 = String.init(format: Constant.SalesSummary.SS_CHART, Session.authKey,
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
                        self.resetData()
                        self.tableView.reloadData()

                        Helper.showNoFilterState(vc: self, tb: self.tableView, isSC: true, action: #selector(self.showFilterMenu))
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
                                    Helper.showNoFilterState(vc: self, tb: self.tableView, isSC: true, action: #selector(self.showFilterMenu))
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
                                Helper.showNoFilterState(vc: self, tb: self.tableView, isSC: true, action: #selector(self.showFilterMenu))
                            }
                        }))
                    }
                } else {
                    self.view.hideLoadingProgressLoader()
                    self.refreshControl.endRefreshing()
                    self.resetData()
                    self.tableView.reloadData()
                    Helper.showNoFilterState(vc: self, tb: self.tableView, isSC: true, action: #selector(self.showFilterMenu))
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            self.resetData()
            self.tableView.reloadData()
            Helper.showNoInternetState(vc: self, tb: self.tableView, action: #selector(self.fetchAllSSData))
            self.refreshControl.endRefreshing()
        }
    }
    
    func populateOverallData (respJson : JSON) {
        
        self.ssData = nil
        
        for(_,i):(String,JSON)  in respJson {
            let summ = SSListData()
            summ.company = i["Company"].stringValue
            summ.location = i["Location"].stringValue
            summ.bVertical = i["Business Unit"].stringValue
            summ.totalValUSD = i["Total Summary Value (USD)"].stringValue
            //
            let jsonTotalAmt = i["Total Value"].stringValue
            let subJson1 = JSON.init(parseJSON:jsonTotalAmt)
            
            for(_,k):(String,JSON) in subJson1 {
                let newDetails = AmountDetails()
                newDetails.currency = k["Currency"].stringValue
                newDetails.amount = k["Summary Value"].stringValue
                
                if k["Currency"].stringValue == "  " {
                    newDetails.currency = " -"
                } else {
                    newDetails.currency = k["Currency"].stringValue
                }
                summ.totalValue.append(newDetails)
            }
            self.ssData = summ
        }
    }
    
    
    func populateChartData (respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        self.barDataEntry.removeAll()
        self.cpNameArr.removeAll()
        self.cpValuesArr.removeAll()

        
        if jsonArr.count > 0 {
            
            for i in 0..<jsonArr.count {
                let name = respJson[i]["CounterParty Name"].stringValue
                let qtyStr = respJson[i]["Product Quantity"].stringValue
                let qty = Double(qtyStr)
                
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(qty!) )
                
                self.barDataEntry.append(dataEntry)
                self.cpNameArr.append(name)
                self.cpValuesArr.append(qtyStr)
            }
        }
    }
    

    func resetData() {
        self.ssData = nil
        self.barDataEntry.removeAll()
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
}


// MARK: - UITableViewDataSource methods
extension SalesSummaryReportController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.barDataEntry.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        switch section {
        case 0,2:
            if self.ssData != nil {
                return 1
            } else {
                return 0
            }
        case 1:
            if self.barDataEntry.count > 0 {
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
            if let totalValue = self.ssData?.totalValue.count {

                if totalValue > 2 && totalValue <= 4 {
                    height = 180
                } else if totalValue > 2 && totalValue <= 6 {
                    height = 215
                } else if totalValue > 6 {
                    height = 215
                } else {
                     height = 140
                }
            }
            print("Case 0:", height)
            break
        case 1:  height = 300.0
            break
        case 2:
          
            if let totalValue = self.ssData?.totalValue.count {
                  print("Case 2 :", totalValue)
                if totalValue > 2 && totalValue <= 4 {
                    height = 270
                } else if totalValue > 2 && totalValue <= 6 {  // 3,4,5,6
                    height = 295
                } else if totalValue > 6 {
                    height = 295
                } else {
                    height = 230 // 1, 2 need testing
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "overallcell") as! SSOverallCell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.isUserInteractionEnabled = false
            cell.setDataToViews(data: self.ssData!)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartcell") as! SSChartCell
            cell.setupDataToViews(dataEntry: self.barDataEntry, arrLabel: self.cpNameArr, arrValues: self.cpValuesArr )
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listcell") as! SSListCell
            cell.selectionStyle = .none
            cell.setDataToViews(data: self.ssData!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let salesDetails = self.storyboard?.instantiateViewController(withIdentifier: "SalesContractListVC") as! SalesContractListVC
            self.navigationController?.pushViewController(salesDetails, animated: true)
        } else {
            
        }
    }
    
}



extension SalesSummaryReportController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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


// MARK: - WC_HeaderViewDelegate methods
extension SalesSummaryReportController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
