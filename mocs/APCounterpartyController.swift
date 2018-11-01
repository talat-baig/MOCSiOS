//
//  APCounterpartyController.swift
//  mocs
//
//  Created by Talat Baig on 10/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class APCounterpartyController: UIViewController, UIGestureRecognizerDelegate {
    
    var cpListData = [APCounterPartyData]()
    
    /// Array of APCounterPartyData
    var newArray = [APCounterPartyData]()
    
    /// Company Name as string
    var company = String()
    
    /// Business Unit as String
    var bUnit = String()
    
    /// Location name as string
    var location = String()
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "APCounterpartyCell", bundle: nil), forCellReuseIdentifier: "apcounterypartycell")
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "AP [Counterparty-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleTap() {
        self.srchBar.endEditing(true)
    }
    
    
    /// Method that fetches Counterparty List thorugh API call and populates table view with the response data
    @objc func populateList(){
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.AP.CP_LIST, Session.authKey, Helper.encodeURL(url : FilterViewController.getFilterString()),Helper.encodeURL(url:self.company),Helper.encodeURL(url: self.location),Helper.encodeURL(url:self.bUnit))
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let newCPObj = APCounterPartyData()
                        newCPObj.location = jsonResponse[i]["Location"].stringValue
                        newCPObj.company = jsonResponse[i]["Company"].stringValue
                        newCPObj.bVertical = jsonResponse[i]["Business Vertical"].stringValue
                        newCPObj.cpName = jsonResponse[i]["Counteparty Name"].stringValue
                        
                        newCPObj.balPayable = jsonResponse[i]["Balance Payable (USD)"].stringValue
                        
                        let jsonTotalInvoice = jsonResponse[i]["Total Invoice Value"].stringValue
                        let subJson1 = JSON.init(parseJSON:jsonTotalInvoice)
                        
                        for(_,k):(String,JSON) in subJson1 {
                            let newDetails = AmountDetails()
                            newDetails.currency = k["Currency"].stringValue
                            newDetails.amount = k["Invoice Value"].stringValue
                            
                            if newDetails.currency != "  " {
                                newCPObj.totalInvValue.append(newDetails)
                            }
                        }
                        self.cpListData.append(newCPObj)
                    }
                    self.newArray = self.cpListData
                    
//                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
    
    
    func getCPInvoiceData(cpListData : APCounterPartyData) {
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.AP.CP_INVOICE, Session.authKey, Helper.encodeURL(url : FilterViewController.getFilterString()),Helper.encodeURL(url:cpListData.company),Helper.encodeURL(url: cpListData.location),Helper.encodeURL(url:cpListData.bVertical),Helper.encodeURL(url:cpListData.cpName))
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    if jsonArr.count > 0 {
                        let apInvVC = self.storyboard?.instantiateViewController(withIdentifier: "APInvoiceListVC") as! APInvoiceListVC
                        apInvVC.jsonResp = response.result.value!
                        apInvVC.counterpty = cpListData.cpName
                        self.navigationController?.pushViewController(apInvVC, animated: true)
                    } else {
                        self.view.makeToast("No Invoice data found for this Counterparty")
                    }
                }
            }))
        }
    }
    
}



extension APCounterpartyController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cpListData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //        let width = self.cpListData[indexPath.row].cpName.count
        var height : CGFloat = 90.0
        let invCount = self.cpListData[indexPath.row].totalInvValue.count
        
        if invCount > 0 {
            if invCount > 2 {
                height = 210
            } else {
                height = 170
            }
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apcounterypartycell") as! APCounterpartyCell
        cell.layer.masksToBounds = true
        
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        if cpListData.count > 0 {
            DispatchQueue.main.async {
                cell.setDataToView(data: self.cpListData[indexPath.row])
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension APCounterpartyController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.srchBar.endEditing(true)
        self.getCPInvoiceData(cpListData: cpListData[indexPath.row])
    }
}


extension APCounterpartyController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.cpListData = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.cpName.localizedCaseInsensitiveContains(searchText)
            }
            self.cpListData = filteredArray
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        srchBar.text = ""
        self.srchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.srchBar.endEditing(true)
    }
}

extension APCounterpartyController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}

