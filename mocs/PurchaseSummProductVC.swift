//
//  PurchaseSummProductVC.swift
//  mocs
//
//  Created by Talat Baig on 12/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PurchaseSummProductVC: UIViewController {

    var refNo = ""
    var prodData = [SalesSummProdData]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.tableView.register(UINib(nibName: "PurchaseProdCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Purchase Summary Report"
        vwTopHeader.lblSubTitle.text = refNo
        
        self.tableView.separatorStyle  = .none
        
        populateList()
    }
    
    /// Method that fetches Counterparty List thorugh API call and populates table view with the response data
    @objc func populateList() {
        
        if internetStatus != .notReachable {

            self.view.showLoading()
            let url:String = String.init(format: Constant.PurchaseSummary.PC_PRODUCT_LIST, Session.authKey, refNo)

            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){

                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]

                    for i in 0..<jsonArr.count {

                        let newObj = SalesSummProdData()

                        newObj.prodName = jsonResponse[i]["Product Name"].stringValue
//
                        if jsonResponse[i]["Quantity (MT)"].stringValue == "" {
                            newObj.qty = "-"
                        } else {
                            newObj.qty = jsonResponse[i]["Quantity (MT)"].stringValue
                        }

                        if jsonResponse[i]["Currency"].stringValue == "" {
                            newObj.curr = "-"
                        } else {
                            newObj.curr = jsonResponse[i]["Currency"].stringValue
                        }
//
                        if jsonResponse[i]["SKU"].stringValue == "" {
                            newObj.sku = "-"
                        } else {
                            newObj.sku = jsonResponse[i]["SKU"].stringValue
                        }

                        if jsonResponse[i]["Price"].stringValue == "" {
                            newObj.price = "-"
                        } else {
                            newObj.price = jsonResponse[i]["Price"].stringValue
                        }
//
                        newObj.lotNo = jsonResponse[i]["LOT ID"].stringValue

                        self.prodData.append(newObj)
                    }
                    self.tableView.reloadData()
                }
            }))
        } else {
        
        }
    }


}


extension PurchaseSummProductVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prodData.count
//        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PurchaseProdCell
        cell.layer.masksToBounds = true
        cell.setDataToView(data: self.prodData[indexPath.row])
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}


// MARK: - UITableViewDelegate methods
extension PurchaseSummProductVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension PurchaseSummProductVC: WC_HeaderViewDelegate {
    
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
