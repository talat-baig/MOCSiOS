//
//  FundsPaymentController.swift
//  mocs
//
//  Created by Talat Baig on 1/2/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class FundsPaymentController: UIViewController,filterViewDelegate, clearFilterDelegate  {

    var fpData : SSListData?
//    var barDataEntry1: [BarChartDataEntry] = []
//    var barDataEntry2: [BarChartDataEntry] = []

    var fpBarData : FPSBarData?

    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var collVw: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FPSOverallCell", bundle: nil), forCellReuseIdentifier: "overallcell")
        
        self.tableView.register(UINib(nibName: "SSChartCell", bundle: nil), forCellReuseIdentifier: "chartcell")
        
        self.tableView.register(UINib(nibName: "FPSListCell", bundle: nil), forCellReuseIdentifier: "listcell")
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fetchAllFPSData))
        tableView.addSubview(refreshControl)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 5.0
        collVw.collectionViewLayout = flowLayout
        
        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self
        
        fetchAllFPSData()
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Funds Payment & Settlement"
        vwTopHeader.lblSubTitle.isHidden = true
    }
    

    func clearAll() {
        self.collVw.reloadData()
        self.fetchAllFPSData()
    }
    
    func applyFilter(filterString: String) {
        
        if fpBarData != nil || fpData != nil  {
            fpData = nil
            fpBarData = nil
        }

        if filterString.contains(",") {
            Helper.showMessage(message: "Please select only one filter")
            return
        }
        self.fetchAllFPSData()
        self.collVw.reloadData()
    }
    
    func cancelFilter(filterString: String) {
        self.fpData = nil
        self.fpBarData = nil
    }
    
    @objc func fetchAllFPSData() {
        
        if internetStatus != .notReachable {
            
            let url1 = String.init(format: Constant.FPS.FPS_OVERALL, Session.authKey,
                                   Helper.encodeURL(url : FilterViewController.getFilterString()))
            
            let url2 = String.init(format: Constant.FPS.FPS_CHART, Session.authKey,
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
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isFPS, action: #selector(self.showFilterMenu))
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
                                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isFPS, action: #selector(self.showFilterMenu))
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
                                Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isFPS, action: #selector(self.showFilterMenu))
                            }
                        }))
                    }
                } else {
                    self.view.hideLoadingProgressLoader()
                    self.refreshControl.endRefreshing()
                    self.resetData()
                    self.tableView.reloadData()
                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isFPS, action: #selector(self.showFilterMenu))
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            self.resetData()
            self.tableView.reloadData()
            Helper.showNoInternetState(vc: self, tb: self.tableView, action: #selector(self.fetchAllFPSData))
            self.refreshControl.endRefreshing()
        }
    }
    
    func resetData() {
        self.fpData = nil
        self.fpBarData = nil
    }
    
    func populateOverallData (respJson : JSON) {
        
        self.fpData = nil
        for(_,i):(String,JSON)  in respJson {
            let summ = SSListData()
            summ.company = i["Company"].stringValue
            summ.location = i["Location"].stringValue
            summ.bVertical = i["Business Unit"].stringValue
            summ.totalRequested = i["Requested Amount In USD"].stringValue
            summ.totalPaid = i["Total Paid Amount In USD"].stringValue
            summ.totalValUSD = i["Total Balance Amount In USD"].stringValue
            self.fpData = summ
        }
        
    }
    
    func populateChartData(respJson : JSON) {
        
        let jsonArr = respJson.arrayObject as! [[String:AnyObject]]
        
        if self.fpBarData != nil {
            self.fpBarData = nil
        }

        if jsonArr.count > 0 {
            
             let fpsBarDta = FPSBarData()
            
            for i in 0..<jsonArr.count {
                
                let name = respJson[i]["CounterParty Name"].stringValue
                
                let paidAmt = respJson[i]["Paid Amount"].stringValue
                let editedText = paidAmt.replacingOccurrences(of: ",", with: "")
                let pAmt = Double(editedText)
                
                let balAmt = respJson[i]["Balance Amount"].stringValue
                let editedText2 = balAmt.replacingOccurrences(of: ",", with: "")
                let bAmt = Double(editedText2)

                fpsBarDta.name.append(name)
                fpsBarDta.value1.append(pAmt ?? 0)
                fpsBarDta.value2.append(bAmt ?? 0)
            }
            
            self.fpBarData = fpsBarDta
        }
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }

}




// MARK: - UITableViewDataSource methods
extension FundsPaymentController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0.0
        
        switch indexPath.section {
        case 0:
            height = 150.0
            break
        case 1:  height = 300.0
            break
        case 2:  height = 240.0
            break
        default: height = 250.0
            break
        }
        return height
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
        if self.fpData != nil {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }

        switch section {
        case 0,2:
            if self.fpData != nil {
                return 1
            } else {
                return 0
            }
        case 1:
            if self.fpBarData != nil {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "overallcell") as! FPSOverallCell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.isUserInteractionEnabled = false
            cell.setDataToViews(data: self.fpData!)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartcell") as! SSChartCell
            cell.setChartBarGroupDataSet(dataPoints: self.fpBarData?.name ?? [], values1:  self.fpBarData?.value1 ?? [], values2: self.fpBarData?.value2 ?? [], sortIndex: indexPath.row)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listcell") as! FPSListCell
            cell.selectionStyle = .none
            cell.setDataToView(data: self.fpData!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let fpsRefVC = self.storyboard?.instantiateViewController(withIdentifier: "FPSRefListViewController") as! FPSRefListViewController
            self.navigationController?.pushViewController(fpsRefVC, animated: true)
        }
    }
    
}


extension FundsPaymentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
extension FundsPaymentController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
