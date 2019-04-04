//
//  ShipProductListVC.swift
//  mocs
//
//  Created by Talat Baig on 3/27/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShipProductListVC: UIViewController {
    
    var saBuyrData = SABuyerData(refID: "", scNo: "", product: "", quality: "", size: "", brand: "")
    
    var arrayList = [ShipAppProdData]()
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblSubTitle.isHidden = true
        vwTopHeader.lblTitle.text = self.saBuyrData.scNo
//        vwTopHeader.lblSubTitle.text = self.saBuyrData.refID

        Helper.setupTableView(tableVw : self.tableView, nibName: "ShipProductCell")
        self.populateList()
    }
    
    @objc func populateList(){
        
        var newArr : [ShipAppProdData] = []
        if internetStatus != .notReachable {

            self.view.showLoading()
            let url:String = String.init(format: Constant.ShipmentAppropriation.SA_SC_DETAILS, Session.authKey, Helper.encodeURL(url: self.saBuyrData.refID ?? ""), Helper.encodeURL(url: self.saBuyrData.scNo ?? ""))

            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){

                    let jsonResp = JSON(response.result.value!)
                    let arrayJson = jsonResp.arrayObject as! [[String:AnyObject]]

                    if arrayJson.count > 0 {
                        do {
                            //    1
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            // 2
                            newArr = try decoder.decode([ShipAppProdData].self, from: response.result.value!)
                        } catch let error { // 3
                            print("Error creating current newDataObj from JSON because: \(error)")
                        }
                        self.arrayList = newArr
                    }
                    self.tableView.setNeedsLayout()
                    self.tableView.layoutIfNeeded()
                    self.tableView.reloadData()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
}


// MARK: - UITableViewDataSource methods
extension ShipProductListVC: UITableViewDataSource, UITableViewDelegate {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ShipProductCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        if self.arrayList.count > 0 {
            cell.setDataToView(data: self.arrayList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

// MARK: - WC_HeaderViewDelegate methods
extension ShipProductListVC: WC_HeaderViewDelegate {
    
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
