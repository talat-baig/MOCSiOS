//
//  ARCounterPartyController.swift
//  mocs
//
//  Created by Talat Baig on 4/4/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class ARCounterPartyController: UIViewController , UIGestureRecognizerDelegate{
    
    /// Array of ARCounterPartyData
    var cpListData = [ARCounterPartyData]()
    
    /// Array of ARCounterPartyData
    var newArray = [ARCounterPartyData]()
    
    /// Company Name as string
    var company = String()
    
    /// Business Unit as String
    var bUnit = String()
    
    /// Location name as string
    var location = String()
    
    /// Search bar
    @IBOutlet weak var srchBar: UISearchBar!
    
    /// Table View
    @IBOutlet weak var tblVwCP: UITableView!
    
    /// Top Header view
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVwCP.register(UINib(nibName: "ARCounterPartyCell", bundle: nil), forCellReuseIdentifier: "arCounterPartyCell")
        self.title = "AR [Counterparty-wise]"
        
        srchBar.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "AR [Counterparty-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Ends view editing mode
    @objc func handleTap() {
        self.srchBar.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tblVwCP))! {
            return false
        }
        return true
    }
    
    /// Method that fetches Counterparty List thorugh API call and populates table view with the response data
    @objc func populateList(){
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.AR.CP_LIST, Session.authKey, Helper.encodeURL(url : FilterViewController.getFilterString()),Helper.encodeURL(url:self.company),Helper.encodeURL(url: self.location),Helper.encodeURL(url:self.bUnit))
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let newCPObj = ARCounterPartyData()
                        newCPObj.location = jsonResponse[i]["Location"].stringValue
                        newCPObj.company = jsonResponse[i]["Company"].stringValue
                        newCPObj.bVertical = jsonResponse[i]["Business Vertical"].stringValue
                        newCPObj.cpName = jsonResponse[i]["Counterparty/Buyer"].stringValue
                        
                        newCPObj.amtRecievable = jsonResponse[i]["Total Amount Receivable (USD)"].stringValue
                        newCPObj.totalInvQnty = jsonResponse[i]["Total Invoice Quantity (MT)"].stringValue
                        
                        let jsonTotalAmt = jsonResponse[i]["Total Amount Received"].stringValue
                        let subJson1 = JSON.init(parseJSON:jsonTotalAmt)
                        
                        for(_,k):(String,JSON) in subJson1 {
                            let newDetails = AmountDetails()
                            newDetails.currency = k["Currency"].stringValue
                            newDetails.amount = k["Amount Received"].stringValue
                            newCPObj.totalAmtRecieved.append(newDetails)
                        }
                        
                        let jsonInvVal = jsonResponse[i]["Total Invoice Value"].stringValue
                        let subJson2 = JSON.init(parseJSON:jsonInvVal)
                        for(_,k):(String,JSON) in subJson2 {
                            let newDetails = AmountDetails()
                            newDetails.currency = k["Currency"].stringValue
                            newDetails.amount = k["Invoice Value"].stringValue
                            newCPObj.totalInvValue.append(newDetails)
                        }
                        self.cpListData.append(newCPObj)
                    }
                    self.newArray = self.cpListData
                    
                    DispatchQueue.main.async {
                        self.tblVwCP.reloadData()
                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
}

// Mark: - UITextFieldDelegate method
extension ARCounterPartyController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTap()
        return false
    }
}

// Mark: - UITableViewDataSource methods
extension ARCounterPartyController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cpListData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let width = self.cpListData[indexPath.row].cpName.count
        let totalInvVal = self.cpListData[indexPath.row].totalInvValue.count
        let totalAmtRecvd = self.cpListData[indexPath.row].totalAmtRecieved.count
        
        if totalAmtRecvd == 0 {
            
            if width >= 16 {
                return CGFloat(225 + width - 21)
            } else {
                return CGFloat(225 + width - 15)
            }
            
        } else if totalInvVal == 0 {
            
            if width >= 16 {
                return CGFloat(250 + width - 21)
            } else {
                return CGFloat(260 + width - 15)
            }
            
        } else if totalInvVal == 0 && totalAmtRecvd == 0 {
            
            if width >= 16 {
                return CGFloat(170 + width - 21)
            } else {
                return CGFloat(225 + width - 15)
            }
        } else {
            if width >= 16 {
                return CGFloat(265 + width - 26)
            } else {
                return CGFloat(265 + width - 15)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwCP.dequeueReusableCell(withIdentifier: "arCounterPartyCell") as! ARCounterPartyCell
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
extension ARCounterPartyController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.srchBar.endEditing(true)
        let arInsVC = self.storyboard?.instantiateViewController(withIdentifier: "ARInstrumentController") as! ARInstrumentController
        arInsVC.company = cpListData[indexPath.row].company
        arInsVC.location = cpListData[indexPath.row].location
        arInsVC.bUnit = cpListData[indexPath.row].bVertical
        arInsVC.counterpty = cpListData[indexPath.row].cpName
        self.navigationController?.pushViewController(arInsVC, animated: true)
        
    }
}


extension ARCounterPartyController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.cpListData = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.cpName.localizedCaseInsensitiveContains(searchText)
            }
            self.cpListData = filteredArray
        }
        tblVwCP.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        srchBar.text = ""
        self.srchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.srchBar.endEditing(true)
    }
}

extension ARCounterPartyController: WC_HeaderViewDelegate {
    
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
