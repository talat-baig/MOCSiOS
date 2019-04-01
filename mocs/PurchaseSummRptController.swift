//
//  PurchaseSummRptCotnroller.swift
//  mocs
//
//  Created by Talat Baig on 12/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class PurchaseSummRptController: UIViewController, filterViewDelegate, clearFilterDelegate {
    
    var barDataEntry: [BarChartDataEntry] = []
    var prodDataEntry: [PieChartDataEntry] = []

    var pcData : SSListData?
    
    // Countrparty Names arry to show on Graph
    var cpNameArr : [String] = []
    
    // Countrparty Values arry to show on Graph
    var cpValuesArr : [String] = []

    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var collVw: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "SSOverallCell", bundle: nil), forCellReuseIdentifier: "overallcell")
        
        self.tableView.register(UINib(nibName: "SSChartCell", bundle: nil), forCellReuseIdentifier: "chartcell")
        
        self.tableView.register(UINib(nibName: "ARChart", bundle: nil), forCellReuseIdentifier: "cell")

        self.tableView.register(UINib(nibName: "SSListCell", bundle: nil), forCellReuseIdentifier: "listcell")
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fetchAllPSData))
        tableView.addSubview(refreshControl)
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        flowLayout.minimumInteritemSpacing = 5.0
//        collVw.collectionViewLayout = flowLayout
        
        Helper.setupCollVwFitler(collVw: self.collVw)

        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self
        
        fetchAllPSData()
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Purchase Summary"
        vwTopHeader.lblSubTitle.isHidden = true
        
    }
    
    func clearAll() {
        self.collVw.reloadData()
        self.fetchAllPSData()
    }
    
    func applyFilter(filterString: String) {
        
        if !barDataEntry.isEmpty || pcData != nil || !prodDataEntry.isEmpty {
            barDataEntry.removeAll()
            prodDataEntry.removeAll()

            pcData = nil
        }
        
        if filterString.contains(",") {
            Helper.showMessage(message: "Please select only one filter")
            return
        }
        self.fetchAllPSData()
        self.collVw.reloadData()
    }
    
    func cancelFilter(filterString: String) {
        self.pcData = nil
        self.barDataEntry.removeAll()
        self.prodDataEntry.removeAll()
    }
    

    @objc func fetchAllPSData() {
        
        if internetStatus != .notReachable {

            let url1 = String.init(format: Constant.PurchaseSummary.PC_OVERALL, Session.authKey,
                                   Helper.encodeURL(url : FilterViewController.getFilterString()))

            let url2 = String.init(format: Constant.PurchaseSummary.PC_CHART, Session.authKey,
                                   Helper.encodeURL(url :  FilterViewController.getFilterString()))
            let url3 = String.init(format: Constant.PurchaseSummary.PC_PRODUCT_CHART, Session.authKey)


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
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.fetchAllPSData))
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
                                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.fetchAllPSData))
                                    return
                                } else {

                                    Alamofire.request(url3).responseData(completionHandler: ({ response in
                                        if Helper.isResponseValid(vc: self, response: response.result) {
                                            let prdChartResp = JSON(response.result.value!)
                                            
                                            if  (prdChartResp.arrayObject?.isEmpty)! {
                                                self.view.hideLoadingProgressLoader()
                                                self.refreshControl.endRefreshing()
                                                self.resetData()
                                                self.tableView.reloadData()
                                                Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.fetchAllPSData))
                                                return
                                            } else {
                                                
                                                self.populateOverallData(respJson: ovrAllResp)
                                                self.populateChartData(respJson: chartResponse)
                                                self.populateProdChartData(respJson: prdChartResp)

                                                self.lblNote.isHidden = false
                                                self.tableView.tableFooterView = nil
                                                self.tableView.reloadData()
                                            }
                                        } else {
                                            self.view.hideLoadingProgressLoader()
                                            self.refreshControl.endRefreshing()
                                            self.resetData()
                                            self.tableView.reloadData()
                                            Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.fetchAllPSData))
                                        }
                                    }))
                                }
                            } else {
                                self.view.hideLoadingProgressLoader()
                                self.refreshControl.endRefreshing()
                                self.resetData()
                                self.tableView.reloadData()
                                Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.fetchAllPSData))
                            }
                        }))
                    }
                } else {
                    self.view.hideLoadingProgressLoader()
                    self.refreshControl.endRefreshing()
                    self.resetData()
                    self.tableView.reloadData()
                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.fetchAllPSData))
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            self.resetData()
            self.tableView.reloadData()
            Helper.showNoInternetState(vc: self, tb: self.tableView, action: #selector(self.fetchAllPSData))
            self.refreshControl.endRefreshing()
        }
    }

    func populateOverallData (respJson : JSON) {
        
        self.pcData = nil
        
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

                let currStr = k["Currency"].stringValue
                let charSet = CharacterSet.whitespaces
                let trimmedString = currStr.trimmingCharacters(in: charSet)
                if (trimmedString == "") {
                    newDetails.currency = " -"
                } else {
                    newDetails.currency = k["Currency"].stringValue
                }
                summ.totalValue.append(newDetails)
            }
            self.pcData = summ
        }
    }
    
    func populateProdChartData(respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        self.prodDataEntry.removeAll()
        if jsonArr.count > 0 {
            
            for i in 0..<jsonArr.count {
                let name = respJson[i]["Product Name"].stringValue
                let qty = Double(respJson[i]["Product Quantity"].stringValue)
                self.prodDataEntry.append(PieChartDataEntry(value: qty!, label: name))
            }
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
//                let qty = Double(qtyStr)

                let editedText = qtyStr.replacingOccurrences(of: ",", with: "")
                let qty = Double(editedText)
                
                let modifiedVal = qtyStr.components(separatedBy: ".").first
                
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(qty!) )

                self.barDataEntry.append(dataEntry)
                self.cpNameArr.append(name)
                self.cpValuesArr.append(modifiedVal ?? "0")
            }
        }
    }
    
    
    func resetData() {
        self.pcData = nil
        lblNote.isHidden = true
        self.barDataEntry.removeAll()
        self.cpNameArr.removeAll()
        self.cpValuesArr.removeAll()
        self.prodDataEntry.removeAll()
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
}




// MARK: - UITableViewDataSource methods
extension PurchaseSummRptController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0.0
        
        switch indexPath.section {
        case 0:
            height = 70.0
            break
        case 1,2:
            height = 300.0
            break
        case 3:
            height = 150.0
            break
        default: height = 200.0
            break
        }
        return height
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.barDataEntry.count > 0 && self.prodDataEntry.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        
        switch section {
        case 0,3:
            if self.pcData != nil {
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
        case 2:
            if self.prodDataEntry.count > 0 {
                return 1
            } else {
                return 0
            }
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "overallcell") as! SSOverallCell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.isUserInteractionEnabled = false
            cell.setDataToViews(data: self.pcData!)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartcell") as! SSChartCell
            cell.setupDataToViews(dataEntry: self.barDataEntry, arrLabel: self.cpNameArr, arrValues: self.cpValuesArr, lblTitle: "Top Counterparties (Values in USD)" )
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ARChartCell
//            cell.setDataToViews(dataEntry: self.prodDataEntry)
            cell.setDataToViews(dataEntry: self.prodDataEntry, strTxt: String( format : "Top Products",self.prodDataEntry.count))

//            cell.setupDataToViews(dataEntry: self.prodDataEntry, arrLabel: self.prdName, arrValues: self.prdQty,lblTitle: "Top Products (Quantity in MT)" )
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listcell") as! SSListCell
            cell.selectionStyle = .none
            cell.setDataToViews(data: self.pcData!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 {
            let purContract = self.storyboard?.instantiateViewController(withIdentifier: "PurchaseContractListVC") as! PurchaseContractListVC
            self.navigationController?.pushViewController(purContract, animated: true)
        } else {
            
        }
    }
    
}




extension PurchaseSummRptController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
extension PurchaseSummRptController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
