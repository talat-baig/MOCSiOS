//
//  PendingApprovalsController.swift
//  mocs
//
//  Created by Talat Baig on 1/30/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class PendingApprovalsController: UIViewController {

    var arrayList : [PAData] = []
    let arrayMod : [String] = ["Purchase Contract","Sales Contract","Delivery Order", "Release Order"]
    let arrayModCount : [String] = ["10","90","34", "0"]

    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.ALL
        vwTopHeader.lblSubTitle.isHidden = true

        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "PendingApprovalCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    

}



extension PendingApprovalsController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayModCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = arrayModCount[indexPath.row]
        let title = arrayMod[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PendingApprovalCell
        cell.selectionStyle = .none
        cell.setDataToView(title: title, count: count)
        return cell
    }
}

extension PendingApprovalsController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}

