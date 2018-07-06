//
//  TCRExpenseController.swift
//  mocs
//
//  Created by Admin on 3/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class TCRExpenseController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "EXPENSES")
    }
    

    var arrayList:[ExpenseListData] = []
    var response:String?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "cell")
        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseAndAssign(){
        let jsonResponse = JSON.init(parseJSON: response!)
        let arrayJson = jsonResponse.arrayObject as! [[String:AnyObject]]
        if arrayJson.count > 0{
            for(_,j):(String,JSON) in jsonResponse{
                let data = ExpenseListData()
                data.expId = j["Expense Id"].stringValue
                data.expDate = j["Expense Date"].stringValue
                data.expCategory = j["Expense Category"].stringValue
                data.expSubCategory = j["Expense Sub Category"].stringValue
                data.expVendor = j["Expense Vendor"].stringValue
                data.expPaymentType = j["Expense Payment Type"].stringValue
                data.expCurrency = j["Expense Currency"].stringValue
                data.expAmount = j["Expense Amount"].stringValue
                data.expComments = j["Expense Comments"].stringValue
                arrayList.append(data)
            }
            self.tableView.reloadData()
        }else{
            Helper.showNoInternetState(vc: self, tb: self.tableView, action: nil)

        }
    }

}
extension TCRExpenseController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayList.count > 0{
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }else{
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let views = tableView.dequeueReusableCell(withIdentifier: "cell") as! ExpenseCell
        views.setDataToView(data: data)
        views.selectionStyle = .none
        return views
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 205
    }
    
}
