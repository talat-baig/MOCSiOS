//
//  ShipAppBuyerListVC.swift
//  mocs
//
//  Created by Talat Baig on 3/27/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire

class ShipAppBuyerListVC: UIViewController {

    var refId = ""
    var prodName = ""
    var arrayList = [SABuyerData]()
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.tableView.register(UINib(nibName: "ShipBuyerCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblSubTitle.isHidden = false
        vwTopHeader.lblTitle.text = "Buyer Name"
        vwTopHeader.lblSubTitle.text =  "Commodity Name"
        
        Helper.setupTableView(tableVw : self.tableView, nibName: "ShipBuyerCell")
        
        self.populateList()
    }
    
    @objc func populateList(){
    }
    


}



// MARK: - UITableViewDataSource methods
extension ShipAppBuyerListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ShipBuyerCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
//        cell.isUserInteractionEnabled = false
        cell.selectionStyle = .none
//        if self.arrayList.count > 0 {
//            cell.setDataToView(data: self.arrayList[indexPath.row])
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let saProdVC = self.storyboard?.instantiateViewController(withIdentifier: "ShipProductListVC") as! ShipProductListVC
        self.navigationController?.pushViewController(saProdVC, animated: true)
    }
    
}



// MARK: - WC_HeaderViewDelegate methods
extension ShipAppBuyerListVC: WC_HeaderViewDelegate {
    
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
