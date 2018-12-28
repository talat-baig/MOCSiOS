//
//  ROPaymentViewController.swift
//  mocs
//
//  Created by Talat Baig on 7/6/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip
import SwiftyJSON
import  Alamofire

class ROCarfoInfoVC: UIViewController, IndicatorInfoProvider {
    
    var roData = ROData()
    @IBOutlet weak var tableView: UITableView!
    var cResponse : Data?
    var arrayList: [WHRListData] = []
    var refreshControl: UIRefreshControl = UIRefreshControl()

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "CARGO INFO")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CargoInfoCell", bundle: nil), forCellReuseIdentifier: "cell")
        populateList(response: cResponse!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populateList(response : Data) {
        
        var data: [WHRListData] = []
        let jsonResponse = JSON(response)
        
        arrayList.removeAll()
        
        for(_,j):(String,JSON) in jsonResponse {
            
            let arr = jsonResponse.arrayObject as! [[String:AnyObject]]
            
            if arr.count > 0 {
                
                for(_,k):(String,JSON) in jsonResponse {
                    let whrList = WHRListData()
                    whrList.vesselName = k["ROVesselName"].stringValue
                    whrList.uom = k["ROUom"].stringValue
                    whrList.product = k["ROProduct"].stringValue
                    whrList.brand = k["ROBrand"].stringValue
                    whrList.bagSize = k["ROBagSize"].stringValue
                    whrList.quality = k["ROQuality"].stringValue
                    whrList.wtTerms = k["ROWeightTerms"].stringValue
                    whrList.qtyRcvd = k["ROQuantityReceivedinmt"].stringValue
                    whrList.whrDate = k["ROWhrDateORGrnDate"].stringValue
                    whrList.whrId = k["RUID"].stringValue
                    whrList.whrNum = k["ROWhrNoORGrnNo"].stringValue
                    whrList.roID = k["ROReferenceID"].stringValue
                    whrList.reqQty = k["RORequestedQtyinmt"].stringValue
                    whrList.balQty = k["ROBalanceQtyinmt"].stringValue
                    whrList.manualNo = k["WHR_Manual_No"].stringValue


                    if k["ROReceiptQtyinmt"].stringValue == "" {
                         whrList.rcptQty = "0"
                    } else {
                         whrList.rcptQty = k["ROReceiptQtyinmt"].stringValue
                    }
//                    whrList.rcptQty = k["ROReceiptQtyinmt"].stringValue

//                    whrList.roGuid = k["ROGUID"].stringValue
                    
                    data.append(whrList)
                }
                
                self.arrayList = data
                self.tableView.reloadData()
            } else {
                
                
            }
        }
        
    }
    
    
    
}

extension ROCarfoInfoVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayList.count > 0{
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else{
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayList[indexPath.row]
        let views = tableView.dequeueReusableCell(withIdentifier: "cell") as! CargoInfoCell
        views.selectionStyle = .none
        views.setDataToView(data: data)
        views.menuDelegate = self
        views.optionMenuDelegate = self
        views.btnMore.tag = indexPath.row
        
        return views
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 410
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
    }
}


extension ROCarfoInfoVC: onCargoMoreClickListener , onCargoOptionIemClickListener {
    
    func onReceiveClick(sender : UIButton) {
        
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "ROCargoDetailsEditVC") as! ROCargoDetailsEditVC
//        detail.whrId = arrayList[sender.tag].whrId
//        detail.whrNum = arrayList[sender.tag].whrNum
        detail.roId = roData.refId
//        detail.whrDate = arrayList[sender.tag].whrDate
        detail.whrData = arrayList[sender.tag]
        
//        detail.roGuid = roData.roGuid
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onCancelClick() {
        
    }
    
    
}


