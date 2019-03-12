//
//  SAProductListController.swift
//  mocs
//
//  Created by Talat Baig on 3/12/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON


class SAProductListController: UIViewController {

    var arrayList = [BCDetailData]()
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(UINib(nibName: "SAProdCell", bundle: nil), forCellReuseIdentifier: "cell")
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        gestureRecognizer.delegate = self
//        self.view.addGestureRecognizer(gestureRecognizer)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblSubTitle.isHidden = false
        vwTopHeader.lblTitle.text = "Produts"
        vwTopHeader.lblSubTitle.text =  "Ref Id"
        
        self.tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.populateList()
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
    
    @objc func populateList(){
        
    }

}


// MARK: - UITableViewDataSource methods
extension SAProductListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SAProdCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        //      cell.isUserInteractionEnabled = false
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
        let vesslListVC = self.storyboard?.instantiateViewController(withIdentifier: "SAVesselListController") as! SAVesselListController
        self.navigationController?.pushViewController(vesslListVC, animated: true)
    }
    
}


// MARK: - WC_HeaderViewDelegate methods
extension SAProductListController: WC_HeaderViewDelegate {
    
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
