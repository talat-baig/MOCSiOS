//
//  LMSReportListVC.swift
//  mocs
//
//  Created by Talat Baig on 4/9/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SearchTextField
import DropDown

class LMSReportListVC: UIViewController , UIGestureRecognizerDelegate {
    
    var searchString = ""
//    var currentPage : Int = 1
    var arrayList:[LMSReportData] = []
    var arrLeaveType : [String] = []
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var vwCompFilter: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var vwContent: UIView!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var vwDept: UIView!
    
    @IBOutlet weak var btnLeaveType: UIButton!
    @IBOutlet weak var txtFldCompany: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        srchBar.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Employee Leave (LMS) Report"
        vwTopHeader.lblSubTitle.isHidden = true
        
        btnMore.isHidden = true
        btnMore.layer.cornerRadius = 5.0
        btnMore.layer.shadowRadius = 4.0
        btnMore.layer.shadowOpacity = 0.8
        btnMore.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
        Helper.setupTableView(tableVw: self.tableView, nibName: "LMSListCell" )
        
        Helper.addBordersToView(view: txtFldCompany, borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        
        Helper.addBordersToView(view: vwDept , borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        
        txtFldCompany.theme.font = UIFont.systemFont(ofSize: 14)
        txtFldCompany.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        txtFldCompany.theme.borderWidth = 1.0
        txtFldCompany.theme.bgColor = UIColor.white
        txtFldCompany.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtFldCompany.frame.height))
        txtFldCompany.leftViewMode = .always
        txtFldCompany.filterStrings(Session.companies)
        
        btnLeaveType.setTitle("Select Leave Type", for: .normal)
        btnLeaveType.contentHorizontalAlignment = .left
        
        txtFldCompany.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            self.txtFldCompany.text = item.title
            
            self.getLeaveTypesByCompany(compStr: item.title )
        }
        
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func btnLeaveTypeTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnLeaveType
        dropDown.dataSource = self.arrLeaveType
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnLeaveType.setTitle(item, for: .normal)
            self?.populateList()
        }
        dropDown.show()
        
        self.handleTap()
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
    
    
    func getLeaveTypesByCompany(compStr : String)  {
        
        var leavTypArr : [String] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.LMS_Rept.LEAVE_TYPES, Session.authKey, Helper.encodeURL(url: compStr) )
            
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ leaveResp in
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: leaveResp.result) {
                    
                    let responseJson = JSON(leaveResp.result.value!)
                    for(_,j):(String,JSON) in responseJson {
                        let leavType = j["LeaveType"].stringValue
                        leavTypArr.append(leavType)
                    }
                    
                    self.arrLeaveType = leavTypArr
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
//    @objc func refreshList() {
//        self.arrayList.removeAll()
//        self.currentPage = 1
//        self.populateList()
//        self.resetViews()
//    }
    
    @objc func populateList() {
        
        var newData :[LMSReportData] = []
        
        if internetStatus != .notReachable {
            
            
            let url = String.init(format: Constant.LMS_Rept.LMS_LIST , Session.authKey,
                                  Helper.encodeURL(url: txtFldCompany.text ?? "") , 1, Helper.encodeURL(url: self.searchString), btnLeaveType.titleLabel?.text ?? "")
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
                            newData = try decoder.decode([LMSReportData].self, from: response.result.value!)
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
//                            self.currentPage -= 1
                            Helper.showMessage(message: "No more data found")
                        }
                    }
                } else {
                    if self.arrayList.isEmpty {
                        self.btnMore.isHidden = true
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isReport, action: #selector(self.populateList))
                    } else {
//                        self.currentPage -= 1
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
                Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
                self.tableView.reloadData()
            } else {
//                self.currentPage -= 1
            }
        }
    }
    
}



extension LMSReportListVC: UITableViewDataSource, UITableViewDelegate {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LMSListCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        if self.arrayList.count > 0 {
            cell.setDataToViews(data: self.arrayList[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension LMSReportListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if  searchText.isEmpty {
            self.searchString = ""
            self.handleTap()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchString = ""
        self.handleTap()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        srchBar.resignFirstResponder()
        guard let searchTxt = srchBar.text else {
            return
        }
        self.searchString = searchTxt
        self.populateList()
        self.handleTap()
    }
}

extension LMSReportListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtFldCompany {
            self.view.endEditing(true)
        }
        return true
    }
    
    
    
}


// MARK: - WC_HeaderViewDelegate methods
extension LMSReportListVC: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
}


extension LMSReportListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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


