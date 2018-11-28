//
//  DetailsListViewController.swift
//  
//
//  Created by Talat Baig on 11/16/18.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON

class DetailsListViewController: UIViewController {
    
    var arrVesselList : [String] = []
    var arrProductList : [AvlRelProductData] = []
    var arrROList : [ROListData] = []
    
    // item as string for btnVessel item selected 
    var item = ""
    var titleStr = ""
    var vesselStr = ""
    var wareHousStr = ""
    
    var isFromProduct = false
    var isFromWarehouse = false
    var isFromVessel = false
    // bool to check if navigation is from Vessel list -> Product list
    var isFromVesselAndProduct = false
    // bool to check if navigation is from warehouse list -> Product list
    var isFromWarehouseAndProduct = false
    
    @IBOutlet weak var vwNameAndQty: UIView!
    @IBOutlet weak var lblQtyVal: UILabel!
    @IBOutlet weak var lblTitleVal: UILabel!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwVessel: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var vwSummary: UIView!
    @IBOutlet weak var lblTotalQty: UILabel!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.addBordersToView(view: vwVessel)
        
        self.tableView.register(UINib(nibName: "AvlRelListCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(initialSetup))
        self.tableView.addSubview(refreshControl)
        
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblSubTitle.text = titleStr
        
        self.item = self.arrVesselList[0]
        self.initialSetup()
        
        self.vwSummary.layer.borderWidth = 1
        self.vwSummary.layer.borderColor = AppColor.universalHeaderColor.cgColor
        self.vwSummary.layer.cornerRadius = 5
        
        tableView.estimatedRowHeight = 55.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func resetViews() {
        self.lblTotalQty.text = " "
        self.vwNameAndQty.isHidden = true
    }
    //    @objc func initialSetup() {
    //
    //        self.lblQtyVal.text = "QTY Avail (MT)"
    //
    //        if isFromVessel || isFromVesselAndProduct {
    //
    //            vwTopHeader.lblTitle.text = "Report [Vessel-wise]"
    //
    //            if isFromVesselAndProduct {
    //                self.lblTitleVal.text = "Release No"
    //                btnSelect.setTitle(vesselStr, for: .normal)
    //                fetchProductWiseROList(vesslName: vesselStr, prodName: titleStr )
    //            } else {
    //                btnSelect.setTitle(titleStr, for: .normal)
    //                self.lblTitleVal.text = "Product Name"
    //                fetchVesselWiseProducts(vesslName: titleStr )
    //            }
    //        } else if isFromProduct {
    //
    //            vwTopHeader.lblTitle.text = "Report [Product-wise]"
    //            btnSelect.setTitle(arrVesselList[0], for: .normal)
    //            self.lblTitleVal.text = "Release No"
    //            fetchProductWiseROList(vesslName: arrVesselList[0], prodName: titleStr )
    //        } else {
    //
    //            vwTopHeader.lblTitle.text = "Report [Warehouse-wise]"
    //            btnSelect.setTitle(arrVesselList[0], for: .normal)
    //
    //            if isFromWarehouseAndProduct {
    //                self.lblTitleVal.text = "Release No"
    //                self.fetchProductWiseROList(vesslName: self.arrVesselList[0], prodName: self.titleStr, warehouseName: self.wareHousStr )
    //            } else {
    //                self.lblTitleVal.text = "Product Name"
    //                fetchWarehouseWiseProduct(wareName: self.titleStr, vesslName: arrVesselList[0])
    //            }
    //        }
    //
    //    }
    
    @objc func initialSetup() {
        
        self.lblQtyVal.text = "QTY Avail (MT)"
        
        if isFromVessel || isFromVesselAndProduct {
            
            vwTopHeader.lblTitle.text = "Report [Vessel-wise]"
            
            if isFromVesselAndProduct {
                self.lblTitleVal.text = "Release No"
                btnSelect.setTitle(vesselStr, for: .normal)
                fetchProductWiseROList(vesslName: vesselStr, prodName: titleStr )
            } else {
                btnSelect.setTitle(titleStr, for: .normal)
                self.lblTitleVal.text = "Product Name"
                self.vwTopHeader.lblSubTitle.text = self.titleStr
                fetchVesselWiseProducts(vesslName: titleStr )
            }
        } else if isFromProduct {
            
            vwTopHeader.lblTitle.text = "Report [Product-wise]"
            btnSelect.setTitle(self.item, for: .normal)
            self.lblTitleVal.text = "Release No"
            fetchProductWiseROList(vesslName: self.item, prodName: titleStr )
        } else {
            
            vwTopHeader.lblTitle.text = "Report [Warehouse-wise]"
            btnSelect.setTitle(self.item, for: .normal)
            
            if isFromWarehouseAndProduct {
                self.lblTitleVal.text = "Release No"
                self.fetchProductWiseROList(vesslName: self.item, prodName: self.titleStr, warehouseName: self.wareHousStr )
            } else {
                self.lblTitleVal.text = "Product Name"
                fetchWarehouseWiseProduct(wareName: self.titleStr, vesslName: self.item)
            }
        }
        
    }
    
    
    @objc func fetchVesselWiseProducts(vesslName : String) {
        
        var vesslStr = ""
        if vesslName == "-" {
            vesslStr = ""
        } else {
            vesslStr = vesslName
        }
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.AvlRel.VESSEL_WISE_PRODUCT_LIST, Session.authKey,  Helper.encodeURL(url: vesslStr))
            print("vessel wise prod", url)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ prodResp in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: prodResp.result) {
                    let responseJson = JSON(prodResp.result.value!)
                    let arrProd = responseJson.arrayObject as! [[String:AnyObject]]
                    self.arrProductList.removeAll()
                    
                    if (arrProd.count > 0) {
                        var arrProd: [AvlRelProductData] = []
                        for(_,j):(String,JSON) in responseJson  {
                            
                            let newProd = AvlRelProductData()
                            if j["Product"].stringValue == "" {
                                newProd.prodName = "-"
                            } else {
                                newProd.prodName = j["Product"].stringValue
                            }
                            newProd.relPending = j["Release Pending for Approval (mt)"].stringValue
                            newProd.prodQty = j["Release Available for Sale (mt)"].stringValue
                            newProd.totalQty = j["Total Release Available for Sale (mt)"].stringValue
                            
                            arrProd.append(newProd)
                        }
                        self.arrProductList = arrProd
                        self.tableView.tableFooterView = nil
                        self.lblTotalQty.text =  "Total Qty(MT) : " +  self.arrProductList[0].totalQty
                        self.vwNameAndQty.isHidden = false
                        
                    } else {
                        self.resetViews()
                        self.showEmptyState()
                    }
                } else {
                    self.resetViews()
                    self.showEmptyState()
                }
                self.tableView.reloadData()
            }))
        } else {
            self.resetViews()
            Helper.showNoInternetMessg()
        }
    }
    
    @objc func fetchWarehouseWiseProduct(wareName : String, vesslName : String) {
        
        var vesslStr = ""
        if vesslName == "-" {
            vesslStr = ""
        } else {
            vesslStr = vesslName
        }
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.AvlRel.WAREHOUSE_WISE_PRODUCT_LIST, Session.authKey, Helper.encodeURL(url: wareName), Helper.encodeURL(url: vesslStr))
            print("warehouse wise prod", url)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ prodResp in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: prodResp.result) {
                    let responseJson = JSON(prodResp.result.value!)
                    let arrProd = responseJson.arrayObject as! [[String:AnyObject]]
                    self.arrProductList.removeAll()
                    
                    if (arrProd.count > 0) {
                        var arrProd: [AvlRelProductData] = []
                        for(_,j):(String,JSON) in responseJson  {
                            
                            let newProd = AvlRelProductData()
                            if j["Product"].stringValue == "" {
                                newProd.prodName = "-"
                            } else {
                                newProd.prodName = j["Product"].stringValue
                            }
                            newProd.relPending = j["Release Pending for Approval (mt)"].stringValue
                            newProd.prodQty = j["Release Available for Sale (mt)"].stringValue
                            newProd.totalQty = j["Total Release Available for Sale (mt)"].stringValue
                            
                            arrProd.append(newProd)
                        }
                        self.arrProductList = arrProd
                        self.tableView.tableFooterView = nil
                        self.lblTotalQty.text =  "Total Qty(MT) : " +  self.arrProductList[0].totalQty
                        self.vwNameAndQty.isHidden = false
                    } else {
                        
                        self.self.resetViews()
                        self.showEmptyState()
                    }
                } else {
                    self.self.resetViews()
                    self.showEmptyState()
                }
                self.tableView.reloadData()
            }))
        }  else {
            self.self.resetViews()
            Helper.showNoInternetMessg()
        }
        
    }
    
    
    @objc func fetchProductWiseROList(vesslName : String, prodName : String , warehouseName : String = "" ) {
        
        let vesslStr = vesslName == "-" ? "" : vesslName
        let prodStr = prodName == "-" ? "" : prodName
        
        var flag = 0
        
        if isFromVesselAndProduct {
            flag = 1
        } else if isFromProduct {
            flag = 2
        } else {
            flag = 3
        }
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.AvlRel.GET_RO_LIST, Session.authKey,  Helper.encodeURL(url: warehouseName) , Helper.encodeURL(url: vesslStr), Helper.encodeURL(url: prodStr), flag )
            print("product wise RO", url)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ roResp in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: roResp.result) {
                    let responseJson = JSON(roResp.result.value!)
                    let arrRo = responseJson.arrayObject as! [[String:AnyObject]]
                    self.arrROList.removeAll()
                    
                    if (arrRo.count > 0) {
                        var arrRo: [ROListData] = []
                        for(_,j):(String,JSON) in responseJson  {
                            
                            let newRo = ROListData()
                            
                            newRo.roNum = j["RO Reference ID"].stringValue
                            newRo.vesslName = j["Vessel Name"].stringValue
                            newRo.relSale = j["Release Available for Sale (mt)"].stringValue
                            newRo.relPending = j["Release Pending for Approval (mt)"].stringValue
                            newRo.totalQty = j["Total Release Available for Sale (mt)"].stringValue
                            arrRo.append(newRo)
                        }
                        self.arrROList = arrRo
                        self.tableView.tableFooterView = nil
                        self.lblTotalQty.text =  "Total Qty(MT) : " +  self.arrROList[0].totalQty
                        self.vwNameAndQty.isHidden = false
                    } else {
                        self.self.resetViews()
                        self.showEmptyState()
                    }
                } else {
                    self.self.resetViews()
                    self.showEmptyState()
                }
                self.tableView.reloadData()
            }))
        } else {
            self.self.resetViews()
            Helper.showNoInternetMessg()
        }
    }
    
    func showEmptyState(){
        Helper.showNoFilterStateResized(vc: self, messg: "No Data Available for the current. Try by changing Vessel or swipe to refresh.", tb: tableView,  action:#selector(initialSetup))
    }
    
    
    @IBAction func btnSelectVesselTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnSelect
        dropDown.dataSource = arrVesselList
        dropDown.selectionAction = { [weak self] (index, item) in
            
            self?.btnSelect.setTitle(item, for: .normal)
            
            self?.item = item  // *
            
            if self?.isFromVessel ?? false { // *
                self?.titleStr = item  // *
            }
            
            if self?.isFromVesselAndProduct ?? false { // *
                self?.vesselStr = item  // *
            }
            
            self?.initialSetup() // *
            //            if self?.isFromVesselAndProduct ?? false {
            //                self?.fetchProductWiseROList(vesslName: self?.vesselStr ?? "", prodName: self?.titleStr ?? "" )
            //            }
            //
            //            if self?.isFromVessel ?? false {
            //                self?.fetchVesselWiseProducts(vesslName : item)
            //            }
            //
            //            if self?.isFromProduct ?? false {
            //                self?.fetchProductWiseROList(vesslName: item, prodName: self?.titleStr ?? "" )
            //            }
            //
            //            if self?.isFromWarehouse ?? false {
            //                self?.fetchWarehouseWiseProduct(wareName: self?.titleStr ?? "", vesslName: item)
            //            }
            //
            //            if self?.isFromWarehouseAndProduct ?? false {
            //                self?.fetchProductWiseROList(vesslName: item, prodName: self?.titleStr ?? "" , warehouseName: self?.wareHousStr ?? "")
            //            }
        }
        dropDown.show()
    }
    
}

extension DetailsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromVesselAndProduct || isFromProduct  || isFromWarehouseAndProduct {
            return arrROList.count
        } else if isFromVessel || isFromWarehouse {
            return arrProductList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AvlRelListCell
        cell.layer.masksToBounds = true
        
        if isFromProduct || isFromVesselAndProduct || isFromWarehouseAndProduct {
            if arrROList.count > 0 {
                cell.setRODataToView(data: arrROList[indexPath.row])
            }
        } else if isFromVessel || isFromWarehouse {
            cell.setProductDataToView(data: arrProductList[indexPath.row])
        } else {
            
        }
        
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension DetailsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // check if Product selected
        if arrProductList.count > 0  {
            let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailsListViewController") as! DetailsListViewController
            
            if isFromVessel {
                detail.titleStr = arrProductList[indexPath.row].prodName
                detail.vesselStr = btnSelect.titleLabel?.text ?? ""
                detail.arrVesselList = self.arrVesselList
                detail.isFromVesselAndProduct = true
            } else if isFromWarehouse {
                detail.titleStr = arrProductList[indexPath.row].prodName
                detail.vesselStr = btnSelect.titleLabel?.text ?? ""
                detail.wareHousStr = self.titleStr
                detail.arrVesselList = self.arrVesselList
                detail.isFromWarehouseAndProduct = true
            }
            
            self.navigationController?.pushViewController(detail, animated: true)
            
        } else {
            // RO selected
            if arrROList.count == 0 {
                self.view.makeToast("No Data to Show")
                return
            }
            
            let detail = self.storyboard?.instantiateViewController(withIdentifier: "RODetailsViewController") as! RODetailsViewController
            
            if isFromVesselAndProduct {
                detail.vesselStr = self.vesselStr
                detail.prodStr = self.titleStr
                detail.isFromVessel = isFromVesselAndProduct
                detail.roNum = arrROList[indexPath.row].roNum
                self.navigationController?.pushViewController(detail, animated: true)
            }
            
            if isFromProduct {
                detail.vesselStr = btnSelect.titleLabel?.text
                    ?? ""
                detail.prodStr = self.titleStr
                detail.isFromProduct = isFromProduct
                detail.roNum = arrROList[indexPath.row].roNum
                self.navigationController?.pushViewController(detail, animated: true)
            }
            
            if isFromWarehouseAndProduct {
                detail.vesselStr = self.vesselStr
                detail.prodStr = self.titleStr
                detail.isFromWarehouse = isFromVesselAndProduct
                detail.roNum = arrROList[indexPath.row].roNum
                self.navigationController?.pushViewController(detail, animated: true)
            }
        }
        
    }
}


extension DetailsListViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
