//
//  DebitStatementController.swift
//  mocs
//
//  Created by Talat Baig on 3/25/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class DebitStatementController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "DEBIT")
    }
    
    var response:Data?
    var arrayList : [CUDebitData] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        Helper.setupTableView(tableVw : self.tableView, nibName: "CUDebitCell")
        self.populateList()
    }
    
    
    func populateList() {
        
        var data: [CUDebitData] = []
        let jsonResponse = JSON(response)
        
        arrayList.removeAll()
        
        for(_,j):(String,JSON) in jsonResponse {
            
            let jsonDebitString = j["Invoices Debits"].stringValue
            
            let pJson = JSON.init(parseJSON:jsonDebitString)
            let arr = pJson.arrayObject as! [[String:AnyObject]]
            
            if arr.count > 0 {
                
                for(_,k):(String,JSON) in pJson {
                    let debitData = CUDebitData()
                    debitData.refID = k["Reference Number"].stringValue
                    debitData.date = k["Date"].stringValue
                    debitData.uom = k["UOM"].stringValue
                    debitData.invQty = k["Invoice Quantity"].stringValue
                    debitData.invVal = k["Invoice Value"].stringValue
                    debitData.curr = k["Currency"].stringValue
                    debitData.balCCY = k["Balance (CCY)"].stringValue
                    debitData.invValCCY = k["Invoice Value (CCY)"].stringValue

                    data.append(debitData)
                }
                
                self.arrayList = data
                self.tableView.reloadData()
            } else {
                Helper.showEmptyState(vc: self, messg: "No Statement found", action: nil, imageName: "no_task")
            }
        }
    }

}

extension DebitStatementController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CUDebitCell
        cell.selectionStyle = .none
        if self.arrayList.count > 0 {
            cell.setDataToView(data: self.arrayList[indexPath.row])
        }
        return cell
    }
    
}
