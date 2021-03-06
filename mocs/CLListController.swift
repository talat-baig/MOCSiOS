//
//  CLListController.swift
//  mocs
//
//  Created by Talat Baig on 2/20/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CLListController: UIViewController, filterViewDelegate, clearFilterDelegate, UIGestureRecognizerDelegate {

    var searchString = ""
    var currentPage : Int = 1
    var arrayList:[PaymentLedgerData] = []
    
    @IBOutlet weak var vwFilter: UIView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var vwContent: UIView!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var btnMore: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CLListCell", bundle: nil), forCellReuseIdentifier: "cell")
        
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
        vwTopHeader.lblTitle.text = "Customer Ledger"
        vwTopHeader.lblSubTitle.isHidden = true
        
        btnMore.isHidden = true
        btnMore.layer.cornerRadius = 5.0
        btnMore.layer.shadowRadius = 4.0
        btnMore.layer.shadowOpacity = 0.8
        btnMore.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
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
    

    @IBAction func btnMoreTapped(_ sender: Any) {
        self.loadMoreItemsForList()
    }
    
    func clearAll() {
        self.handleTap()
        self.collVw.reloadData()
        self.resetViews()
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
        
        if ((contentOffset) >= (contentHeight)) && self.arrayList.count > 9 {
            DispatchQueue.main.async {
                self.btnMore.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.btnMore.isHidden = true
            }
        }
    }
    
    @objc func populateList() {
        
        handleTap()
        var newData :[PaymentLedgerData] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CustomerLedger.CL_LIST, Session.authKey,
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
        
                            data.cpID = j["CustomerCode"].stringValue //
                            data.vendorName = j["CustomerName"].stringValue //
                            
                            data.journal = j["Journal"].stringValue != "" ? j["Journal"].stringValue : "-" //
                            data.curr = j["Currency"].stringValue != "" ? j["Currency"].stringValue : "-" //
                            data.instNo = j["Invoice No"].stringValue != "" ? j["Invoice No"].stringValue : "-"
                            data.refNo = j["RefrenceID"].stringValue != "" ? j["RefrenceID"].stringValue : "-" //
                            data.date = j["ValuePaidDate"].stringValue != "" ? j["ValuePaidDate"].stringValue : "-" //
                           
                            data.debit = j["DebitAmount"].stringValue != "" ? j["DebitAmount"].stringValue : "-" //
                            data.credit = j["CreditAmount"].stringValue != "" ? j["CreditAmount"].stringValue : "-" //
                            data.balance = j["Balance_Payable"].stringValue != "" ? j["Balance_Payable"].stringValue : "-" //
                        
                            data.remarks = j["Description"].stringValue != "" ? j["Description"].stringValue : "-" //
                            newData.append(data)
                        }
                        self.arrayList.append(contentsOf: newData)
                        self.tableView.tableFooterView = nil
                    } else {
                        if self.arrayList.isEmpty {
                            self.btnMore.isHidden = true
                            Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.refreshList))
                        } else {
                            self.currentPage -= 1
                            Helper.showMessage(message: "No more data found")
                        }
                    }
                } else {
                    if self.arrayList.isEmpty {
                        self.btnMore.isHidden = true
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.refreshList))

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
}



// MARK: - UITableViewDataSource methods
extension CLListController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CLListCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        if arrayList.count > 0 {
            let data = arrayList[indexPath.row]
            cell.setDataToView(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
}


// MARK: - WC_HeaderViewDelegate methods
extension CLListController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}



extension CLListController: UISearchBarDelegate {
    
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
        
        searchBar.resignFirstResponder()
        guard let searchTxt = searchBar.text else {
            return
        }
        self.searchString = searchTxt
        self.refreshList()
    }
}


extension CLListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let size: CGSize = newStr.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
        return size
    }
    
    
}

