//
//  ECRExpenseListVC.swift
//  mocs
//
//  Created by Talat Baig on 6/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class ECRExpenseListVC: UIViewController, IndicatorInfoProvider, onMoreClickListener ,onEcrExpOptionMenuTap {
    func onDeleteClick(data: ECRExpenseListData) {
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "EXPENSE ITEMS")
    }
    
    
    @IBAction func btnAddExpenseTapped(_ sender: Any) {
        
        let expAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpClaimExpenseAddEditVC") as! EmpClaimExpenseAddEditVC
       
        self.navigationController?.pushViewController(expAddEditVC, animated: true)
    }
    
    func onEditClick() {
        let expAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpClaimExpenseAddEditVC") as! EmpClaimExpenseAddEditVC
//        expAddEditVC.currResponse = Session.currency
//        expAddEditVC.expCatResponse = Session.category
//        expAddEditVC.tcrRefNo =  self.tcrData.headRef
//        expAddEditVC.startDate = self.startDateStr
//        expAddEditVC.endDate = self.endDateStr
//        expAddEditVC.tcrCounter = self.tcrData.counter
//        expAddEditVC.eplData = data
//        expAddEditVC.okSubmitDelegate = self
        self.navigationController?.pushViewController(expAddEditVC, animated: true)
    }
    
 
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: ECRExpenseListAdapter = self.tableView.cellForRow(at: indexPath) as! ECRExpenseListAdapter
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMenu
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
}


extension ECRExpenseListVC: UITableViewDataSource {
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if arrayList.count > 0{
//            tableView.backgroundView?.isHidden = true
//            tableView.separatorStyle = .singleLine
//        }else{
//            tableView.backgroundView?.isHidden = false
//            tableView.separatorStyle = .none
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = arrayList[indexPath.row]
        
        let view = tableView.dequeueReusableCell(withIdentifier: "ECRExpenseListAdapter") as! ECRExpenseListAdapter
        view.setDataToView(data: nil)
//
//        if isFromView {
//            view.btnMenu.isHidden = true
//        } else {
//            view.btnMenu.isHidden = false
//        }
        view.delegate = self
//        view.btnMenu.tag = indexPath.row
        view.ecrExpMenuTapDelegate = self
        return view
    }
}

// MARK: - UITableViewDelegate methods
extension ECRExpenseListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
