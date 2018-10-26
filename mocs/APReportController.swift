//
//  APReportController.swift
//  mocs
//
//  Created by Talat Baig on 10/22/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import SwiftyJSON

class APReportController: UIViewController , filterViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "APOverallCell", bundle: nil), forCellReuseIdentifier: "overallcell")

        self.tableView.register(UINib(nibName: "ARChart", bundle: nil), forCellReuseIdentifier: "chartcell")

        self.tableView.register(UINib(nibName: "APListCell", bundle: nil), forCellReuseIdentifier: "listcell")

        //        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fetchAllAPData))
        //        tableView.addSubview(refreshControl)
        
        FilterViewController.filterDelegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Accounts Payable"
        vwTopHeader.lblSubTitle.isHidden = true
        //        self.tableView.tableFooterView = nil
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func fetchAllAPData() {
        
    }
    
    func applyFilter(filterString: String) {
        
    }
    
    func cancelFilter(filterString: String) {
        
    }
    
    
}

// MARK: - UITableViewDataSource methods
extension APReportController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var height : CGFloat = 0.0
        
        switch indexPath.section {
        case 0: height = 224.0
            break
        case 1:  height = 200.0
            break
        case 2:  height = 300.0
            break
        default: height = 280.0
            break
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "overallcell") as! APOverallCell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.setDataToView()
            cell.isUserInteractionEnabled = false
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartcell") as! ARChartCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listcell") as! APListCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            let apCPVC = self.storyboard?.instantiateViewController(withIdentifier: "APCounterpartyController") as! APCounterpartyController
            self.navigationController?.pushViewController(apCPVC, animated: true)
            
        } else {
            
        }
        
    }
}


// MARK: - WC_HeaderViewDelegate methods
extension APReportController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
