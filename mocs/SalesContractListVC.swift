//
//  SalesContractListVC.swift
//  mocs
//
//  Created by Talat Baig on 12/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SalesContractListVC: UIViewController {
    
    var company = ""
    var location = ""
    var bUnit = ""
    
    var scData = [SalesSummData]()
    var newArray = [SalesSummData]()

    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SalesSummaryCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Sales Summary[Contractwise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
        
    }
    
    
    @objc func populateList() {
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.SalesSummary.SS_SALES_LIST, Session.authKey)
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                  
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let ssdObj = SalesSummData()
                        
                        ssdObj.refNo = jsonResponse[i]["Sales order/Contract"].stringValue
                        ssdObj.cpName = jsonResponse[i]["Buyer Name"].stringValue
                        ssdObj.cpID = jsonResponse[i]["CPID"].stringValue
                        ssdObj.paymntTerm = jsonResponse[i]["Payment Term"].stringValue
                        ssdObj.value = jsonResponse[i]["Contract Value"].stringValue
                        ssdObj.shipStrtDate = jsonResponse[i]["Shipment Start Date"].stringValue
                        ssdObj.shipEndDate = jsonResponse[i]["Shipment End Date"].stringValue
                        ssdObj.doQty = jsonResponse[i]["DO Quantity"].stringValue
                        ssdObj.contrctStatus = jsonResponse[i]["Contract Status"].stringValue
                        ssdObj.pol = jsonResponse[i]["POL"].stringValue
                        ssdObj.pod = jsonResponse[i]["POD"].stringValue
                        ssdObj.invAmt = jsonResponse[i]["Invoice Amount"].stringValue

                        self.scData.append(ssdObj)
                    }
                    self.newArray = self.scData
                    self.tableView.reloadData()
                }
            }))
        } else {
            
        }
    }
            
}

extension SalesContractListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SalesSummaryCell
        cell.layer.masksToBounds = true
        cell.setDataTOView(data:  self.scData[indexPath.row] )
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}


// MARK: - UITableViewDelegate methods
extension SalesContractListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let salesDetails = self.storyboard?.instantiateViewController(withIdentifier: "SalesSummProductVC") as! SalesSummProductVC
        salesDetails.refNo =  self.scData[indexPath.row].refNo
        self.navigationController?.pushViewController(salesDetails, animated: true)
    }
}


extension SalesContractListVC: WC_HeaderViewDelegate {
    
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
