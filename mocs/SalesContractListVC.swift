//
//  SalesContractListVC.swift
//  mocs
//
//  Created by Talat Baig on 12/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SalesContractListVC: UIViewController, UIGestureRecognizerDelegate, passProductDelegate {

    var scData = [SalesSummData]()
    var newArray = [SalesSummData]()
    var prodStr = ""
    var prodListArr : [String] = []
    
    @IBOutlet weak var lblTotalContracts: UILabel!
    @IBOutlet weak var lblValues: UILabel!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblFilterProd: UILabel!

    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var btnReset: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SalesSummaryCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.separatorStyle = .none
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Sales Summary[Contract-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        self.tableView.separatorStyle  = .none
        
        populateList(prodStr: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkProdStringAndSetData(prodName: self.prodStr)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prodListArr.removeAll()
    }
    
    @objc func handleTap() {
        self.srchBar.endEditing(true)
    }
    
    @objc func populateList(prodStr : String = "") {
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.SalesSummary.SS_SALES_LIST, Session.authKey,Helper.encodeURL(url:prodStr))
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let ssdObj = SalesSummData()
                        ssdObj.refNo = jsonResponse[i]["Sales order/Contract"].stringValue
                        ssdObj.cpName = jsonResponse[i]["Buyer Name"].stringValue
                        ssdObj.cpID = jsonResponse[i]["CPID"].stringValue
                        ssdObj.paymntTerm = jsonResponse[i]["Payment Term"].stringValue
                        ssdObj.value = jsonResponse[i]["Contract Value"].stringValue
                        ssdObj.doQty = jsonResponse[i]["DO Quantity"].stringValue
                        ssdObj.contrctStatus = jsonResponse[i]["Contract Status"].stringValue

                        if jsonResponse[i]["Shipment Start Date"].stringValue == "" {
                            ssdObj.shipStrtDate = "-"
                        } else {
                            ssdObj.shipStrtDate = jsonResponse[i]["Shipment Start Date"].stringValue
                        }
                        if jsonResponse[i]["Shipment End Date"].stringValue == "" {
                            ssdObj.shipEndDate = "-"
                        } else {
                            ssdObj.shipEndDate = jsonResponse[i]["Shipment End Date"].stringValue
                        }
                        
                        if jsonResponse[i]["POL"].stringValue == "" {
                            ssdObj.pol = "-"
                        } else {
                            ssdObj.pol = jsonResponse[i]["POL"].stringValue
                        }
                        
                        if jsonResponse[i]["POD"].stringValue == "" {
                            ssdObj.pod = "-"
                        } else {
                            ssdObj.pod = jsonResponse[i]["POD"].stringValue
                        }
                        
                        if jsonResponse[i]["Invoice Amount"].stringValue == "" {
                            ssdObj.invAmt = "-"
                        } else {
                            ssdObj.invAmt = jsonResponse[i]["Invoice Amount"].stringValue
                        }
                        
                        ssdObj.valCurr = jsonResponse[i]["Contract Currency"].stringValue
                        ssdObj.invCurr = jsonResponse[i]["Invoice Currency"].stringValue

                        self.scData.append(ssdObj)
                    }
                    self.newArray = self.scData
                    self.setTotalValuesToViews()
                    self.tableView.reloadData()
                }
            }))
        } else {
            self.setTotalValuesToViews()
            Helper.showNoInternetMessg()
        }
    }
    
    func setTotalValuesToViews() {
        
        if self.scData.count > 0 {
            
            var valArr : [Int] = []
            
            for i in 0..<self.scData.count {
                let ab = Int(self.scData[i].value)
                valArr.append(ab ?? 0)
            }
            let sumedArr = valArr.reduce(0, +)
            lblValues.text = String(format: "%d",sumedArr)
        } else {
            lblValues.text = "0"
        }
        lblTotalContracts.text = String(format : "%d" ,self.scData.count)
    }
    
    
    func populateProdList( comp : @escaping(Bool)-> ()) {
        
        var newArr : [String] = []
        if self.prodListArr.isEmpty {
            
            if internetStatus != .notReachable {
                
                self.view.showLoading()
                let url = String.init(format: Constant.SalesSummary.SS_PROD_COUNT, Session.authKey)
                Alamofire.request(url).responseData(completionHandler: ({ response in
                    
                    self.view.hideLoading()
                    if Helper.isResponseValid(vc: self, response: response.result){
                        
                        let jsonResponse = JSON(response.result.value!)
                        let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
//                        let newArr = self.parseAndAssignProducts(prodString : )
                        for i in 0..<jsonArr.count {
                            var newObj = String()
                            newObj = jsonResponse[i]["Product Name"].stringValue
                            newArr.append(newObj)
                        }
                        self.prodListArr = newArr
                        comp(true)
                    } else {
                        comp(false)
                    }
                }))
            } else {
                comp(false)
                Helper.showNoInternetMessg()
            }
        } else {
             comp(true)
        }
    }
 
    func checkProdStringAndSetData(prodName : String) {

        if prodName == "" {
            self.lblFilterProd.text = "Tap Filter icon to view product wise contracts"
            btnReset.isHidden = true
        } else {
            self.lblFilterProd.text = String(format : "Showing results for %@",prodName)
            btnReset.isHidden = false
            populateList(prodStr: prodName)
        }
    }
    
    func sendProductName(prodName: String) {
        self.prodStr = prodName
        checkProdStringAndSetData(prodName:  self.prodStr)
    }
    
    func openSearchByProdView(arrProd : [String]) {
        let myView = Bundle.main.loadNibNamed("SearchByProductsView", owner: nil, options: nil)![0] as! SearchByProductsView
        myView.frame = CGRect.init(x: 0, y: (self.navigationController?.navigationBar.frame.origin.y)!, width: self.view.frame.size.width, height: self.view.frame.size.height)
        myView.passDelegate = self
        myView.passArrayToView(prodArr:arrProd)
        DispatchQueue.main.async {
            self.navigationController?.view.addMySubview(myView)
        }
    }
    
    
//    func btnFilterByProductsTapped() {
    
//        self.handleTap()
//        var arrProd : [String] = []
//
//        self.populateProdList(comp: { result, arr in
//            if result {
//                self.openSearchByProdView(arrProd : arr )
//            } else {
//                Helper.showMessage(message: "Products not found")
//            }
//        })
//    }
    
    @IBAction func btnFilterTapped(_ sender: Any) {
        
        self.handleTap()
        
        self.populateProdList(comp: { result in
            if result {
                self.openSearchByProdView(arrProd : self.prodListArr )
            } else {
                Helper.showMessage(message: "Unable to load products. Please try again later")
            }
        })
    }
    
    @IBAction func btnResetTapped(_ sender: Any) {
        
        if !self.prodStr.isEmpty {
            self.prodStr = ""
        } else {
            
        }
        self.checkProdStringAndSetData(prodName: self.prodStr)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
}

// Mark: - UITextFieldDelegate method
extension SalesContractListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTap()
        return false
    }
}

extension SalesContractListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SalesSummaryCell
        cell.layer.masksToBounds = true
        cell.setDataTOView(data:  self.scData[indexPath.row] )
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}


// MARK: - UITableViewDelegate methods
extension SalesContractListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let salesDetails = self.storyboard?.instantiateViewController(withIdentifier: "SalesSummProductVC") as! SalesSummProductVC
        salesDetails.refNo =  self.scData[indexPath.row].refNo
        self.navigationController?.pushViewController(salesDetails, animated: true)
    }
}

extension SalesContractListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.scData = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.refNo.localizedCaseInsensitiveContains(searchText)
            }
            self.scData = filteredArray
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        srchBar.text = ""
        self.srchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.srchBar.endEditing(true)
    }
}


extension SalesContractListVC: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {

    }
    
}
