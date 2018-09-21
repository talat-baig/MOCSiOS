//
//  ROPrimaryViewController.swift
//  mocs
//
//  Created by Talat Baig on 7/6/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire

class ROPrimaryViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    var response:Data!
    var roData = ROData()

    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblBUnit: UILabel!
    
    @IBOutlet weak var lblCommodity: UILabel!
    
    @IBOutlet weak var lblReleaseFor: UILabel!
    
    @IBOutlet weak var lblReqDate: UILabel!
    
    @IBOutlet weak var lblReqQty: UILabel!
    
    @IBOutlet weak var lblUom: UILabel!
    
    @IBOutlet weak var lblWhtTrms: UILabel!
    
    @IBOutlet weak var lblBalQty: UILabel!
    
    @IBOutlet weak var lblQtyRcvd: UILabel!
    
    @IBOutlet weak var lblRelOrderNo: UILabel!
    
    @IBOutlet weak var lblRcptDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    func parseAndAssign(){
        let jsonResponse = JSON(response)
        for(_,j):(String,JSON) in jsonResponse{
            lblCompany.text! = j["Company Name"].stringValue
            lblLocation.text! = j["Location"].stringValue
            lblBUnit.text! = j["Business Vertical"].stringValue
            lblCommodity.text! = j["Commodity"].stringValue
            lblReleaseFor.text! = j["Release For"].stringValue
            lblReqDate.text! = j["Request Date"].stringValue
            
            lblReqQty.text! = roData.reqQty
            lblWhtTrms.text! = roData.wghtTrms
            lblBalQty.text! = roData.balQty
            lblRelOrderNo.text! = roData.relOrderNum
            lblQtyRcvd.text! = roData.rcvdQty
            lblRcptDate.text! = roData.rcptDate
            
        }
    }

    
//    @objc func populateList() {
//        if internetStatus != .notReachable {
//            
//            let url = String.init(format: Constant.RO.LIST, Helper.encodeURL(url: FilterViewController.getFilterString()), Session.authKey)
//            
//            self.view.showLoading()
//            Alamofire.request(url).responseData(completionHandler: ({ response in
//                self.view.hideLoading()
//                debugPrint(response.result)
//                if Helper.isResponseValid(vc: self, response: response.result ){
//                    
//                    let jsonResponse = JSON(response.result.value!);
//                    let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
//                    
//                    if jsonArray.count > 0 {
//                        
//                        for(_,j):(String,JSON) in jsonResponse {
//                            let data = ROData()
//                            data.company = j["ROCompanyName"].stringValue
//                            data.businessUnit = j["Businessunit"].stringValue
//                            data.location = j["Location"].stringValue
//                            data.commodity = j["Commodity"].stringValue
//                            data.reqDate = j["Date"].stringValue
//                            data.refId = j["ReferenceID"].stringValue
//                            data.roStatus = j["BalanceToPay"].stringValue
//                            data.reqQty = j["RORequestedQtyinmt"].stringValue
//                            data.rcvdQty = j["ROReceiveQuantityReceivedinmt"].stringValue
//                            data.balQty = j["ROBalanceQtyinmt"].stringValue
//                            
//                            data.uom = j["RoUom"].stringValue
//                            data.wghtTrms = j["ROWeightTerms"].stringValue
//                            
//                            if j["ROReceiveReleaseOrderNo"].stringValue == "" {
//                                data.relOrderNum = "-"
//                            } else {
//                                data.relOrderNum = j["ROReceiveReleaseOrderNo"].stringValue
//                            }
//                            
//                            if j["ROReceiveReceiptDate"].stringValue == "" {
//                                data.rcptDate = "-"
//                            } else {
//                                data.rcptDate = j["ROReceiveReceiptDate"].stringValue
//                            }
//                            
//                        }
//                        
//                    }else{
////                        Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
//                    }
//                }
//            }))
//        }else{
//            Helper.showNoInternetMessg()
//        }
//    }
    
    
    
    
    
    
}
