//
//  AvlRelBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 11/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AvlRelBaseViewController: UIViewController {
    
    /// Top Header
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    let arrImgName = [ "vessel", "product", "warehouse"]
    let arrTitle = ["Vessel", "Product" , "Warehouse"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "AvlRelBaseCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Available Releases"
        vwTopHeader.lblSubTitle.isHidden = true
        
    }
    
//    func getProductDataAndNavigate() {
//
//
//        if internetStatus != .notReachable {
//
//            let url1 = String.init(format: Constant.AvlRel.VESSEL_LIST, Session.authKey,  Helper.encodeURL(url : FilterViewController.getFilterString()))
//
//            let url2 = String.init(format: Constant.AvlRel.PRODUCT_LIST, Session.authKey,  Helper.encodeURL(url : FilterViewController.getFilterString()))
//
//            self.view.showLoading()
//
//            Alamofire.request(url1).responseData(completionHandler: ({ response in
//                self.view.hideLoading()
//
//                if Helper.isResponseValid(vc: self, response: response.result){
//
//                    let responseJson = JSON(response.result.value!)
//                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
//                }
//            }))
//        }
//    }
    
    
    
    
    func getVesselData() {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.AvlRel.VESSEL_LIST, Session.authKey,  Helper.encodeURL(url : FilterViewController.getFilterString()))
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let responseJson = JSON(response.result.value!)
                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrData.count > 0) {
                        let vessl = self.storyboard?.instantiateViewController(withIdentifier: "VesselListViewController") as! VesselListViewController
                        vessl.response = response.result.value
                        self.navigationController?.pushViewController(vessl, animated: true)
                    } else {
                        self.view.makeToast("Data not found")
                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    @objc func navigateToList(sender: UIButton) {
        
        if FilterViewController.getFilterString() == "" {
            self.view.makeToast("Please Select Filter")
            return
        }
        
        if sender.tag == 0 {
            getVesselData()
        } else if sender.tag == 1 {
            let prod = self.storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            self.navigationController?.pushViewController(prod, animated: true)

        } else {
            let ware = self.storyboard?.instantiateViewController(withIdentifier: "WarehouseListViewController") as! WarehouseListViewController
            self.navigationController?.pushViewController(ware, animated: true)
        }
    }
    
}

extension AvlRelBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 165
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AvlRelBaseCell
        let tintedImage = UIImage(named: arrImgName[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.btnAvlRel.setImage(tintedImage, for: .normal)
        cell.btnAvlRel.tintColor = UIColor.white
        cell.lblTitle.text = arrTitle[indexPath.row]
        
        cell.btnAvlRel.tag = indexPath.row
        cell.btnAvlRel.addTarget(self, action: #selector(self.navigateToList(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}


// Mark: - WC_HeaderViewDelegate delegate methods
extension AvlRelBaseViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
}
