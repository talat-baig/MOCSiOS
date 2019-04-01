//
//  CreditStatementController.swift
//  mocs
//
//  Created by Talat Baig on 3/25/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class CreditStatementController: UIViewController ,IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "CREDIT")
    }
    
    var response:Data?
    var arrayList : [CUCreditData] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        Helper.setupTableView(tableVw : self.tableView, nibName: "CUCreditCell")
        self.populateList()
    }
   
    func populateList() {
        
        var data: [CUCreditData] = []
        let jsonResponse = JSON(response)
        
        arrayList.removeAll()
        
        for(_,j):(String,JSON) in jsonResponse {
            
            let jsonDebitString = j["Receipts Credits"].stringValue
            
            let pJson = JSON.init(parseJSON:jsonDebitString)
            let arr = pJson.arrayObject as! [[String:AnyObject]]
            
            if arr.count > 0 {
                
                for(_,k):(String,JSON) in pJson {
                    let creditData = CUCreditData()
                    creditData.refID = k["Reference Number"].stringValue
                    creditData.date = k["Date"].stringValue
                    creditData.bankShortName = k["Bank Short Name"].stringValue
                    creditData.grossAmt = k["Gross Amount"].stringValue
                    creditData.curr = k["Currency"].stringValue
                    creditData.accNo = k["Account No."].stringValue

                    creditData.grossAmtCCY = k["Gross Amount (CCY)"].stringValue
                    data.append(creditData)
                }
                
                self.arrayList = data
                self.tableView.reloadData()
            } else {
                Helper.showEmptyState(vc: self, messg: "No Statement found", action: nil, imageName: "no_task")
            }
        }
    }
}



extension CreditStatementController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CUCreditCell
        cell.selectionStyle = .none
        if self.arrayList.count > 0 {
            cell.setDataToView(data: self.arrayList[indexPath.row])
        }
        return cell
    }
    
}
