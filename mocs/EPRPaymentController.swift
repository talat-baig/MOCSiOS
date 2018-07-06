//
//  EPRPaymentController.swift
//  mocs
//
//  Created by Admin on 3/8/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class EPRPaymentController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PAYMENT")
    }
    
    var response:JSON?
    @IBOutlet weak var tableView: UITableView!
    var arrayList:[EPRPaymentData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        populateList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateList(){
        for(_,j):(String,JSON) in response!{
            let data = EPRPaymentData()
            data.itemDate = j["Payment Item Date"].stringValue
            data.reason = j["Payment Reason"].stringValue
            data.chargeHead = j["A/C Charge Head"].stringValue
            data.amount = j["Amount"].stringValue
            data.invoice = j["Invoice No."].stringValue
            data.remark = j["Remarks"].stringValue
            arrayList.append(data)
        }
        tableView.reloadData()
    }

}
extension EPRPaymentController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayList.count > 0{
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else{
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .none
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let viewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EPRPaymentAdapter
        viewCell.setDataToView(data: data)
        
        return viewCell
    }
}
