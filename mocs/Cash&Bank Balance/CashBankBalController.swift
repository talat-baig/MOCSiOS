//
//  CashBankBalController.swift
//  mocs
//
//  Created by Talat Baig on 2/22/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import  Alamofire
import  SwiftyJSON

class CashBankBalController: UIViewController , filterViewDelegate, clearFilterDelegate, UIGestureRecognizerDelegate  {
    
    var searchString = ""
    var currentPage : Int = 1
    var arrayList:[PaymentLedgerData] = []
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var vwFilter: UIView!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var vwContent: UIView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CashBankCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(refreshList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        srchBar.delegate = self
        Helper.setupCollVwFitler(collVw: self.collVw)
        
        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self
        
        resetViews()
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Cash and Bank Register"
        vwTopHeader.lblSubTitle.isHidden = true
        
        btnMore.isHidden = true
        btnMore.layer.cornerRadius = 5.0
        btnMore.layer.shadowRadius = 4.0
        btnMore.layer.shadowOpacity = 0.8
        btnMore.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        self.refreshList()
        
    }
    
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func refreshList() {
        self.arrayList.removeAll()
        self.currentPage = 1
        self.populateList()
        self.resetViews()
    }
    
    func resetViews() {
        if FilterViewController.selectedDataObj.isEmpty {
            vwFilter.isHidden = true
        } else {
            vwFilter.isHidden = false
        }
    }
    
    func applyFilter(filterString: String) {
        
        if !arrayList.isEmpty {
            arrayList.removeAll()
        }
        self.refreshList()
        self.resetViews()
        self.collVw.reloadData()
    }
    
    func loadMoreItemsForList() {
        self.currentPage += 1
        populateList()
    }
    
    func cancelFilter(filterString: String) {
        self.populateList()
        self.resetViews()
    }
    
    
    @objc func populateList() {
        
        
        var newData :[PaymentLedgerData] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CashAndBank.CB_LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()), self.currentPage, Helper.encodeURL(url: self.searchString))
            print(url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                
                
                if Helper.isResponseValid(vc: self, response: response.result,tv: self.tableView){
                    
                    let jsonResp = JSON(response.result.value!)
                    let arrayJson = jsonResp.arrayObject as! [[String:AnyObject]]
                    
                    if arrayJson.count > 0 {
                        
                        for(_,j):(String,JSON) in jsonResp {
                            
                            let data = PaymentLedgerData()
                            
                            data.cpID = j["Beneficiary ID"].stringValue //
                            data.vendorName = j["Beneficiary Name"].stringValue //

                            data.journal = j["Journal"].stringValue != "" ? j["Journal"].stringValue : "-" //
                            data.curr = j["Cur"].stringValue != "" ? j["Cur"].stringValue : "-" //
                            data.instNo = j["Invoice No"].stringValue != "" ? j["Invoice No"].stringValue : "-"
                            data.refNo = j["Reference No"].stringValue != "" ? j["Reference No"].stringValue : "-" //
                            data.date = j["Value Date"].stringValue != "" ? j["Value Date"].stringValue : "-" //
                            data.debit = j["Debit"].stringValue != "" ? j["Debit"].stringValue : "-" //
                            data.credit = j["Credit"].stringValue != "" ? j["Credit"].stringValue : "-" //
                            data.balance = j["Current_Balance"].stringValue != "" ? j["Current_Balance"].stringValue : "-" //
                            data.particular = j["Particulars"].stringValue != "" ? j["Particulars"].stringValue : "-" //
                            data.remarks = j["Remark"].stringValue != "" ? j["Remark"].stringValue : "-" //
                            data.bankName = j["From Bank"].stringValue != "" ? j["From Bank"].stringValue : "-" //
                            data.account = j["From Bank Account No"].stringValue != "" ? j["From Bank Account No"].stringValue : "-" //
                            
                            newData.append(data)
                        }
                        self.arrayList.append(contentsOf: newData)
                        self.tableView.tableFooterView = nil
                    } else {
                        if self.arrayList.isEmpty {
                            self.btnMore.isHidden = true
                            Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: nil)
                        } else {
                            self.currentPage -= 1
                            Helper.showMessage(message: "No more data found")
                        }
                    }
                } else {
                    if self.arrayList.isEmpty {
                        self.btnMore.isHidden = true
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: nil)
                    } else {
                        self.currentPage -= 1
                    }
                    print("Invalid Reponse")
                }
                self.tableView.reloadData()
            }))
        } else {
            self.refreshControl.endRefreshing()
            Helper.showNoInternetMessg()
            
            if self.arrayList.isEmpty {
                btnMore.isHidden = true
                Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(refreshList))
                self.tableView.reloadData()
            } else {
                self.currentPage -= 1
            }
        }
    }
    
    @IBAction func btnMoreTapped(_ sender: Any) {
        self.loadMoreItemsForList()
    }
    
    func clearAll() {
        self.handleTap()
        self.collVw.reloadData()
        self.resetViews()
    }
    
    func resetData() {
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y + scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        
        if ((contentOffset) >= (contentHeight)) && self.arrayList.count > 0 {
            DispatchQueue.main.async {
                self.btnMore.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.btnMore.isHidden = true
            }
        }
    }
    
    
}




// MARK: - UITableViewDataSource methods
extension CashBankBalController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 330
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CashBankCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        if self.arrayList.count > 0 {
            DispatchQueue.main.async {
               cell.layoutIfNeeded()
                cell.setNeedsDisplay()
             cell.setDataToView(data: self.arrayList[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension CashBankBalController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.searchString = ""
            self.refreshList()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchString = ""
        self.refreshList()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        srchBar.resignFirstResponder()
        guard let searchTxt = srchBar.text else {
            return
        }
        self.searchString = searchTxt
        self.refreshList()
    }
}

// MARK: - WC_HeaderViewDelegate methods
extension CashBankBalController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}


extension CashBankBalController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterViewController.selectedDataObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionCell", for: indexPath as IndexPath) as! FilterCollectionViewCell
        let newObj = FilterViewController.selectedDataObj[indexPath.row]
        let  newStr = (newObj.company?.compName)! + "|" + (newObj.location?.locName)! + "|" +  newObj.name!
        cell.lblTitle.text = newStr
        cell.lblTitle.preferredMaxLayoutWidth = 100
        return cell
    }
    
    func collectionView(_ collectionView : UICollectionView,layout  collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        let newObj = FilterViewController.selectedDataObj[indexPath.row]
        let  newStr = (newObj.company?.compName)! + "|" + (newObj.location?.locName)! + "|" +  newObj.name!
        let size: CGSize = newStr.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0)])
        return size
    }
    
    
}

