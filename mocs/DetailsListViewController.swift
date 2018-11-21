//
//  DetailsListViewController.swift
//  
//
//  Created by Talat Baig on 11/16/18.
//

import UIKit
import DropDown
import Alamofire
import  SwiftyJSON

class DetailsListViewController: UIViewController {
    
    var isFromProduct = false
    var isFromWarehouse = false
    var isFromVessel = false
    
    var isFromVesselAndProduct = false
    
    
    var titleStr = ""
    var arrVesselList : [String] = []
    var arrProductList : [AvlRelProductData] = []
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwVessel: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var vwSummary: UIView!
    
    let arrRoList = ["RRD-18-13-0002","RRD-18-12-0007","RRD-16-13-0003", "RRD-18-25-0005"]
    //    let arrProduct = ["Brazilian Parboiled Rice","Brown Sugar","Lentils","abcd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.addBordersToView(view: vwVessel)
        
        if isFromVessel {
            btnSelect.setTitle(titleStr, for: .normal)
        } else {
            btnSelect.setTitle("Tap To Select", for: .normal)
        }
        
        self.tableView.register(UINib(nibName: "AvlRelListCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        
        if isFromVessel || isFromVesselAndProduct {
            vwTopHeader.lblTitle.text = "Report [Vessel-wise]"
            fetchVesselWiseProducts(vesslName: titleStr )
        } else if isFromProduct {
            vwTopHeader.lblTitle.text = "Report [Product-wise]"
        } else {
            vwTopHeader.lblTitle.text = "Report [Warehouse-wise]"
        }
        
        vwTopHeader.lblSubTitle.text = titleStr
        
        tableView.estimatedRowHeight = 55.0
        tableView.rowHeight = UITableViewAutomaticDimension
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
                
                if Helper.isResponseValid(vc: self, response: prodResp.result) {
                    let responseJson = JSON(prodResp.result.value!)
                    let arrProd = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrProd.count > 0) {
                        var arrProd: [AvlRelProductData] = []
                        for(_,j):(String,JSON) in responseJson  {
                            
                            let newProd = AvlRelProductData()
                            if j["Product"].stringValue == "" {
                                newProd.prodName = "-"
                            } else {
                                newProd.prodName = j["Product"].stringValue
                            }
                            newProd.prodQty = j["Release Available for Sale (mt)"].stringValue
                            newProd.totalQty = j["Release Pending for Approval (mt)"].stringValue
                            arrProd.append(newProd)
                        }
                        self.arrProductList = arrProd
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    } else {
                        self.showEmptyState()
                    }
                } else {
                    self.showEmptyState()
                }
            }))
        }
    }
    
    func showEmptyState(){
//        if isFromVesselAndProduct {
//        Helper.showNoItemState(vc: self, messg: "No Data Available. Please Reload.", tb: tableView, action: #selector(fetchVesselWiseProducts(vesslName:)))
//        }
    }
    
    @IBAction func btnSelectVesselTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnSelect
        dropDown.dataSource = arrVesselList
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnSelect.setTitle(item, for: .normal)
            
            self?.fetchVesselWiseProducts(vesslName : item)
        }
        dropDown.show()
    }
    
}

extension DetailsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromVesselAndProduct {
            return 3
        } else if isFromVessel{
            return arrProductList.count
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AvlRelListCell
        cell.layer.masksToBounds = true
        
        if isFromProduct || isFromVesselAndProduct {
            cell.lblText.text = "RO Number"
            cell.lblName.text = arrRoList[indexPath.row]
        } else if isFromVessel {
            cell.setProductDataToView(data: arrProductList[indexPath.row])
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
        if arrProductList.count > 0 && isFromVessel {
            //            getROListAndNavigate()
            let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailsListViewController") as! DetailsListViewController
            detail.isFromVesselAndProduct = true
            detail.arrVesselList = self.arrVesselList
            self.navigationController?.pushViewController(detail, animated: true)
        } else {
            // RO selected
            let detail = self.storyboard?.instantiateViewController(withIdentifier: "RODetailsViewController") as! RODetailsViewController
            self.navigationController?.pushViewController(detail, animated: true)
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
