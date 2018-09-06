//
//  ExpenseListViewController.swift
//  mocs
//
//  Created by Talat Baig on 3/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON


class ExpenseListViewController: UIViewController, IndicatorInfoProvider, onSubmitOkDelegate, notifyChilds_UC {
   
    var arrayList: [ExpenseListData] = []
    var isFromView : Bool = false
    var startDateStr = String()
    var endDateStr = String()
    var response:Data?

    var tcrData = TravelClaimData()
    
    @IBOutlet weak var tblVwExpenseList: UITableView!
    @IBOutlet weak var btnAddExpense: UIButton!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getExpenseData))
        
      
        if isFromView {
            btnAddExpense.isHidden = true
            
        } else {
            btnAddExpense.isHidden = false
            tblVwExpenseList.addSubview(refreshControl)
        }
        
        guard let respValue = response else {
            Helper.showMessage(message: "Something went wrong!, Please try refreshing")
            return
        }
        
        
        populateList(response: respValue)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "EXPENSE ITEMS")
    }
    
    
    
    @objc func getExpenseData() {
        
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TCR.VIEW, Session.authKey,
                                  tcrData.headRef, tcrData.counter)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result,tv: self.tblVwExpenseList){
                    self.populateList(response : response.result.value!)
                }
            }))
        } else {
           Helper.showNoInternetMessg()
        }
    }
    
    func notifyChild(messg: String, success : Bool) {
         Helper.showVUMessage(message: messg, success: success)
    }
    
    
    
    func populateList(response : Data) {
        
        var data: [ExpenseListData] = []
        let jsonResponse = JSON(response)
        
        arrayList.removeAll()
        
        for(_,j):(String,JSON) in jsonResponse {
            
            let jsonExpenseString = j["Expense Items"].stringValue
            startDateStr = j["Travel Start Date"].stringValue
            endDateStr = j["Travel End Date"].stringValue
            
            let newStr = jsonExpenseString.replacingOccurrences(of: "\r\n|\n|\r",  with: " ", options: .regularExpression, range: nil)

            let pJson = JSON.init(parseJSON:newStr)
            let arr = pJson.arrayObject as! [[String:AnyObject]]
            
            if arr.count > 0 {
                
                for(_,k):(String,JSON) in pJson {
                    let expList = ExpenseListData()
                    expList.expId = k["Expense Id"].stringValue
                    expList.expSubCategory = k["Expense Sub Category"].stringValue
                    expList.expPaymentType = k["Expense Payment Type"].stringValue
                    expList.expCurrency = k["Expense Currency"].stringValue
                    expList.expCategory = k["Expense Category"].stringValue
                    expList.expAmount = k["Expense Amount"].stringValue
                    expList.expDate = k["Expense Date"].stringValue
                    expList.expComments = k["Expense Comments"].stringValue
                    expList.expVendor = k["Expense Vendor"].stringValue
                    data.append(expList)
                }
                
                self.arrayList = data
                self.tblVwExpenseList.reloadData()
            } else {
                
                if isFromView {
                    Helper.showNoItemState(vc:self , messg: "No Expense Item found" , tb:tblVwExpenseList)
                } else {
                   
                }
            }
        }
    }
    
    func getCurrency(comp : @escaping(Bool) ->()) {
        if Session.currency == "" {
            if internetStatus != .notReachable {
                let url = String.init(format: Constant.API.CURRENCY_TYPE, Session.authKey)
                self.view.showLoading()
                Alamofire.request(url).responseData(completionHandler: ({ response in
                    self.view.hideLoading()
                    if Helper.isResponseValid(vc: self, response: response.result){
                        let jsonString = JSON(response.result.value!)
                        Session.currency = jsonString.rawString()!
                        comp(true)
                    } else {
                        comp(false)
                    }
                }))
                
            } else {
                
                comp(false)
            }
        }
         comp(true)
    }
            
    
    func getCurrencyAndOpenVC(eplData: ExpenseListData?) {
        if Session.currency == "" {
            if internetStatus != .notReachable {
                let url = String.init(format: Constant.API.CURRENCY_TYPE, Session.authKey)
                self.view.showLoading()
                Alamofire.request(url).responseData(completionHandler: ({ response in
                    self.view.hideLoading()
                    if Helper.isResponseValid(vc: self, response: response.result) {
                        let jsonString = JSON(response.result.value!)
                        Session.currency = jsonString.rawString()!
                        
                        let expAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseAddEditViewController") as! ExpenseAddEditViewController
                        expAddEditVC.currResponse = Session.currency
                        expAddEditVC.expCatResponse = Session.category
                        expAddEditVC.tcrRefNo =  self.tcrData.headRef
                        expAddEditVC.startDate = self.startDateStr
                        expAddEditVC.endDate = self.endDateStr
                        expAddEditVC.tcrCounter = self.tcrData.counter
                        expAddEditVC.eplData = eplData
                        expAddEditVC.okSubmitDelegate = self
                        self.navigationController?.pushViewController(expAddEditVC, animated: true)
                    }
                }))
            }
        } else {
            let expAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseAddEditViewController") as! ExpenseAddEditViewController
            expAddEditVC.currResponse = Session.currency
            expAddEditVC.expCatResponse = Session.category
            expAddEditVC.tcrRefNo =  self.tcrData.headRef
            expAddEditVC.startDate = self.startDateStr
            expAddEditVC.endDate = self.endDateStr
            expAddEditVC.tcrCounter = self.tcrData.counter
            expAddEditVC.eplData = eplData
            expAddEditVC.okSubmitDelegate = self
            self.navigationController?.pushViewController(expAddEditVC, animated: true)
        }
    }
    
    func deleteExpense(data : ExpenseListData) {
        if internetStatus != .notReachable {
            self.view.showLoading()
            let url = String.init(format: Constant.API.EXPENSE_DELETE, Session.authKey, self.tcrData.headRef, data.expId.trimmingCharacters(in: .whitespaces), self.tcrData.counter)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Expense Successfully deleted", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(AlertAction) ->  Void in
                        if let index = self.arrayList.index(where: {$0 === data}) {
                            self.arrayList.remove(at: index)
                        }
                        self.tblVwExpenseList.reloadData()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func getExpenseAndCurrencyType(eplData : ExpenseListData?) {
        if Session.category == "" {
            if internetStatus != .notReachable {
                let url = String.init(format: Constant.API.EXPENSE_TYPE, Session.authKey)
                self.view.showLoading()
                Alamofire.request(url).responseData(completionHandler: ({ response in
                    self.view.hideLoading()
                    if Helper.isResponseValid(vc: self, response: response.result){
                        let jsonString = JSON(response.result.value!)
                        Session.category = jsonString.rawString()!
                        self.getCurrencyAndOpenVC(eplData: eplData)
                    }
                }))
            } else {
                Helper.showNoInternetMessg()
            }
        } else {
            self.getCurrencyAndOpenVC(eplData: eplData)
        }
    }
    
    func onOkClick() {
        self.getExpenseData()
    }
    
    @IBAction func btnAddExpenseTapped(_ sender: Any) {
        
        getExpenseAndCurrencyType(eplData: nil)
    }
    
}

extension ExpenseListViewController: UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 210
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
        
        let view = tableView.dequeueReusableCell(withIdentifier: "ExpenseListAdapter", for: indexPath) as! ExpenseListAdapter
        view.setDataToView(data: data)
        
        if isFromView {
            view.btnMenu.isHidden = true
        } else {
            view.btnMenu.isHidden = false
        }
        view.delegate = self
        view.btnMenu.tag = indexPath.row
        view.expOptionClickListener = self
        return view
    }
}

// MARK: - UITableViewDelegate methods
extension ExpenseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ExpenseListViewController: onMoreClickListener, onExpOptionItemClickListener {
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: ExpenseListAdapter = self.tblVwExpenseList.cellForRow(at: indexPath) as! ExpenseListAdapter
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMenu
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onEditClick(data: ExpenseListData) {
      
        getExpenseAndCurrencyType(eplData: data)
    }
    
    func onDeleteClick(data: ExpenseListData) {
        let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete Expense Item? Once you delete this, there is no way to un-delete", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "NO GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.deleteExpense(data : data )
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}





