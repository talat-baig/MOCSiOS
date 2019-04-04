//
//  CreditUtilListController.swift
//  mocs
//
//  Created by Talat Baig on 3/25/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreditUtilListController: UIViewController , filterViewDelegate, clearFilterDelegate, UIGestureRecognizerDelegate {
    

    var searchString = ""
    var currentPage : Int = 1
    var arrayList:[CUListData] = []
    
    @IBOutlet weak var vwFilter: UIView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var vwContent: UIView!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        vwTopHeader.lblTitle.text = "Credit Limit Utilization Summary"
        vwTopHeader.lblSubTitle.isHidden = true
        
        btnMore.isHidden = true
        btnMore.layer.cornerRadius = 5.0
        btnMore.layer.shadowRadius = 4.0
        btnMore.layer.shadowOpacity = 0.8
        btnMore.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
        Helper.setupTableView(tableVw: self.tableView, nibName: "CredUtilCell", identifier: "cell")
        self.refreshList()
    }
    
    func resetViews() {
        
        self.collVw.reloadData()
        
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
        
//
//        if FilterViewController.getFilterString().contains(",") {
//            Helper.showMessage(message: "Please select only one filter")
//            self.collVw.reloadData()
//            return
//        }

        self.refreshList()
        self.resetViews()
        self.collVw.reloadData()
    }
    
   
    func cancelFilter(filterString: String) {
        self.populateList()
        self.resetViews()
    }
    
    func clearAll() {
        self.collVw.reloadData()
        self.resetViews()
    }
    
    func loadMoreItemsForList() {
        self.currentPage += 1
        populateList()
    }
 
    @IBAction func btnMoreTapped(_ sender: Any) {
        self.loadMoreItemsForList()
    }
    
    
    @objc func populateList() {
        
        if FilterViewController.getFilterString().contains(",") {
            
            Helper.showMessage(message: "Please select only one filter")
            self.collVw.reloadData()
            self.arrayList.removeAll()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.populateList))

            return
        }
        
        var newData :[CUListData] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CreditUtil.CU_LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()), self.currentPage, 0 ,Helper.encodeURL(url: self.searchString),"")
            print(url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result,tv: self.tableView){
                    
                    let jsonResp = JSON(response.result.value!)
                    let arrayJson = jsonResp.arrayObject as! [[String:AnyObject]]
                    
                    if arrayJson.count > 0 {
                        
                        do {
                            // 1
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            // 2
                            newData = try decoder.decode([CUListData].self, from: response.result.value!)
                        } catch let error { // 3
                            print("Error creating current newDataObj from JSON because: \(error)")
                        }
                        
                        self.arrayList.append(contentsOf: newData)
                        self.tableView.tableFooterView = nil
                    } else {
                        if self.arrayList.isEmpty {
                            self.btnMore.isHidden = true
                            Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.populateList))
                        } else {
                            self.currentPage -= 1
                            Helper.showMessage(message: "No more data found")
                        }
                    }
                } else {
                    if self.arrayList.isEmpty {
                        self.btnMore.isHidden = true
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.populateList))
                    } else {
                        self.currentPage -= 1
                    }
                    print("Invalid Reponse")
                }
                self.tableView.reloadData()
                self.setCurrencyText()
            }))
        } else {
            self.setCurrencyText()
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
    
    
    func setCurrencyText() {
        if arrayList.count > 0 && self.arrayList[0].currency != nil {
            self.lblNote.text =  String(format: "*All values are reflected in %@" , self.arrayList[0].currency ?? "-")
        } else {
            self.lblNote.text = ""
        }
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
    
    
    func getStatementDetailsAndNavigate(data : CUListData) {
        
        if internetStatus != .notReachable{
            
            let url = String.init(format: Constant.CreditUtil.CU_LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()),1 , 1 , "" ,Helper.encodeURL(url: data.cpID ?? ""))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: response.result){
                    let baseCUVC = self.storyboard?.instantiateViewController(withIdentifier: "CUBaseViewController") as! CUBaseViewController
                    baseCUVC.cuListData = data
                    baseCUVC.response = response.result.value
                    self.navigationController?.pushViewController(baseCUVC, animated: true)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    @objc func viewStatement(sender : UIButton) {
        self.getStatementDetailsAndNavigate(data: self.arrayList[sender.tag] )
    }
    
    
    
}

extension CreditUtilListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.searchString = ""
            self.refreshList()
            self.handleTap()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchString = ""
        self.refreshList()
        self.handleTap()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        srchBar.resignFirstResponder()
        guard let searchTxt = srchBar.text else {
            return
        }
        self.searchString = searchTxt
        self.refreshList()
        self.handleTap()
    }
    

}

// MARK: - UITableViewDataSource methods
extension CreditUtilListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CredUtilCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action: #selector(self.viewStatement(sender:)), for: UIControl.Event.touchUpInside)
        if arrayList.count > 0 {
            cell.setDataToViews(data: self.arrayList[indexPath.row])
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

// MARK: - WC_HeaderViewDelegate methods
extension CreditUtilListController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
}


extension CreditUtilListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

