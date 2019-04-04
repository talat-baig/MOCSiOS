//
//  LMSEmployeeListVC.swift
//  mocs
//
//  Created by Talat Baig on 1/14/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LMSEmployeeListVC: UIViewController {
  
    var arrayList : [LMSEmpData] = []
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Pending Approvals"
        vwTopHeader.lblSubTitle.isHidden = true

        self.navigationController?.isNavigationBarHidden = true
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "LMSEmpDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.checkAndReloadData()
    }
    
    func checkAndReloadData() {
        
        if self.arrayList.count > 0 {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        } else {
            self.showEmptyState()
        }
    }
    
    func showEmptyState() {
        Helper.showNoFilterState(vc: self, tb: tableView, reports: ModName.isLMSApproval)
    }
    
    @objc func viewLeaveReq(sender : UIButton) {

        let lmsDetail = self.storyboard?.instantiateViewController(withIdentifier: "LMSLeaveDetailsVC") as! LMSLeaveDetailsVC
        lmsDetail.empName = self.arrayList[sender.tag].empName
        lmsDetail.dept = self.arrayList[sender.tag].dept
        lmsDetail.empId = self.arrayList[sender.tag].empId
        self.navigationController?.pushViewController(lmsDetail, animated: true)
    }
    
}

extension LMSEmployeeListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LMSEmpDataCell
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action: #selector(self.viewLeaveReq(sender:)), for: UIControl.Event.touchUpInside)
        cell.setDataToViews(data: data)
        cell.selectionStyle = .none
        return cell
    }

}


extension LMSEmployeeListVC: WC_HeaderViewDelegate {
    
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
