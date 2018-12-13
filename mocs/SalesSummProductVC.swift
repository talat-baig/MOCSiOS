//
//  SalesSummProductVC.swift
//  mocs
//
//  Created by Talat Baig on 12/11/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SalesSummProductVC: UIViewController {

    var refNo = ""
    var prodData = [SalesSummProdData]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "SalesProductCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Sales Summary[Product]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
        
    }
    
    
    /// Method that fetches Counterparty List thorugh API call and populates table view with the response data
    @objc func populateList() {
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.SalesSummary.SS_PRODUCT_LIST, Session.authKey, refNo)
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let newObj = SalesSummProdData()
                        
                        newObj.prodName = jsonResponse[i]["Product Name"].stringValue

                        if jsonResponse[i]["Quantity"].stringValue == "" {
                            newObj.qty = "-"
                        } else {
                            newObj.qty = jsonResponse[i]["Quantity"].stringValue
                        }
                        
                        if jsonResponse[i]["Quality"].stringValue == "" {
                            newObj.qlty = "-"
                        } else {
                            newObj.qlty = jsonResponse[i]["Quality"].stringValue
                        }
                        
                        if jsonResponse[i]["Currency"].stringValue == "" {
                            newObj.curr = "-"
                        } else {
                            newObj.curr = jsonResponse[i]["Currency"].stringValue
                        }
                        
                        if jsonResponse[i]["SKU"].stringValue == "" {
                            newObj.sku = "-"
                        } else {
                            newObj.sku = jsonResponse[i]["SKU"].stringValue
                        }
                        
                        if jsonResponse[i]["Brand"].stringValue == "" {
                            newObj.brnd = "-"
                        } else {
                            newObj.brnd = jsonResponse[i]["Brand"].stringValue
                        }
                        
                        if jsonResponse[i]["Price"].stringValue == "" {
                            newObj.price = "-"
                        } else {
                            newObj.price = jsonResponse[i]["Price"].stringValue
                        }
                        
                        newObj.qtyMT = jsonResponse[i]["Quantity (MT)"].stringValue
                        newObj.lotNo = jsonResponse[i]["LOT Number"].stringValue
                        newObj.bagSize = jsonResponse[i]["Bag Size"].stringValue

                        self.prodData.append(newObj)
                    }
                    self.tableView.reloadData()
                }
            }))
        } else {
            
        }
    }


}

extension SalesSummProductVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prodData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SalesProductCell
        cell.layer.masksToBounds = true
        cell.setDataToView(data: self.prodData[indexPath.row])
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}


// MARK: - UITableViewDelegate methods
extension SalesSummProductVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension SalesSummProductVC: WC_HeaderViewDelegate {
    
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
