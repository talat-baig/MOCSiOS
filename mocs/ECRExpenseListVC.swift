//
//  ECRExpenseListVC.swift
//  mocs
//
//  Created by Talat Baig on 6/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class ECRExpenseListVC: UIViewController, IndicatorInfoProvider, onMoreClickListener ,onEcrExpOptionMenuTap , notifyChilds_UC, onECRPaymentAddDelegate {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PAYMENT ITEMS")
    }
    
    var arrayList: [ECRExpenseListData] = []
    var categoryArr = [String]()
    var paymntRes : Data?
    @IBOutlet weak var btnAddExpense: UIButton!
    var isFromView : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var ecrData = EmployeeClaimData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getECRExpenseData))
        
        if isFromView {
            btnAddExpense.isHidden = true
            
        } else {
            btnAddExpense.isHidden = false
            tableView.addSubview(refreshControl)
        }
        
        guard let respValue = paymntRes else {
            Helper.showMessage(message: "Something went wrong!, Please try refreshing")
            return
        }
        
        populateList(response: respValue)

        getAccountCharge(ecrData: ecrData)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func notifyChild(messg: String, success: Bool) {
        Helper.showVUMessage(message: messg, success: success)
    }
    
    
    
    func populateList(response : Data) {
        
        var data: [ECRExpenseListData] = []
        
        let pJson = JSON(response)
        let arr = pJson.arrayObject as! [[String:AnyObject]]
        
        if arr.count > 0 {
            
            for(_,k):(String,JSON) in pJson {
                let expList = ECRExpenseListData()
                
                expList.addedDate = k["AddDate"].stringValue
                expList.eprRefId = k["EPRMainReferenceID"].stringValue
                expList.accntCharge = k["EPRItemsCategory"].stringValue
                expList.comments = k["EPRItemsRemarks"].stringValue
                expList.eprTaxType = k["EPRItemsTaxType"].stringValue
                expList.expAmount = k["EPRItemsAmount"].stringValue
                expList.invoiceNo =  k["EPRItemsInvoiceNumber"].stringValue
                expList.eprCategory =  k["EPRItemsCategory"].stringValue
                expList.eprRefId =  k["EPRMainReferenceID"].stringValue
                expList.vendor = k["EPRItemsVendorName"].stringValue
                expList.reason = k["EPRItemsAccountChargeHead"].stringValue
                expList.eprItemsId = k["EmployeePaymentRequestItemsID"].stringValue

                data.append(expList)
            }
            
            self.arrayList = data
            self.tableView.reloadData()
        } else {
            
            if isFromView {
                Helper.showNoItemState(vc:self , messg: "No Payment Item found" , tb:tableView)
            } else {
                
            }
        }
        
    }
    
    
    @objc func getECRExpenseData() {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.API.ECR_PAYMENT_LIST, Session.authKey,
                                  ecrData.headRef, ecrData.counter)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result,tv: self.tableView){
                    self.populateList(response : response.result.value!)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    

    func getAccountCharge(ecrData: EmployeeClaimData) {
        
        if internetStatus != .notReachable {
            var newData:[String] = []
            
            let url = String.init(format: Constant.API.GET_ACCOUNT_CHARGE, Session.authKey,ecrData.claimTypeInInt, ecrData.headRef)
            
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
       
                
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonString = JSON(response.result.value!)
                    print(jsonString)
                    for(_,j):(String,JSON) in jsonString {
                        let newCurr = j["Category"].stringValue
                        newData.append(newCurr)
                    }
                    self.categoryArr = newData
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }

    
    @IBAction func btnAddExpenseTapped(_ sender: Any) {
        
        let expAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpClaimExpenseAddEditVC") as! EmpClaimExpenseAddEditVC
        expAddEditVC.ecrExpListData = nil
        expAddEditVC.arrAccChrg = self.categoryArr

        expAddEditVC.ecrData = self.ecrData
        expAddEditVC.okPymntDelegate = self
        self.navigationController?.pushViewController(expAddEditVC, animated: true)
    }
    
    func onEditClick(data: ECRExpenseListData) {
        
        let expAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpClaimExpenseAddEditVC") as! EmpClaimExpenseAddEditVC
        expAddEditVC.ecrExpListData = data
        expAddEditVC.arrAccChrg = self.categoryArr
        expAddEditVC.ecrData = self.ecrData

        expAddEditVC.okPymntDelegate = self
        self.navigationController?.pushViewController(expAddEditVC, animated: true)
    }
    
    func onDeleteClick(data: ECRExpenseListData) {
        
    }
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: ECRExpenseListAdapter = self.tableView.cellForRow(at: indexPath) as! ECRExpenseListAdapter
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMenu
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onOkClick() {
        self.getECRExpenseData()
    }
    
}


extension ECRExpenseListVC: UITableViewDataSource {
    
    
    
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
        
        let view = tableView.dequeueReusableCell(withIdentifier: "ECRExpenseListAdapter") as! ECRExpenseListAdapter
        view.btnMenu.tag = indexPath.row
        if isFromView {
            view.btnMenu.isHidden = true
        } else {
            view.btnMenu.isHidden = false
        }
        
        view.setDataToView(data: data)
        //
        //        if isFromView {
        //            view.btnMenu.isHidden = true
        //        } else {
        //            view.btnMenu.isHidden = false
        //        }
        view.delegate = self
        //        view.btnMenu.tag = indexPath.row
        view.ecrExpMenuTapDelegate = self
        return view
    }
}

// MARK: - UITableViewDelegate methods
extension ECRExpenseListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
