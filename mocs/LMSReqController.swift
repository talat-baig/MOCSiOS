//
//  LMSReqController.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSReqController: UIViewController {

    var arrayList : [LMSGridData] = []
//    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var gridTableVw: UITableView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var btnApplyLeave: UIButton!
    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "LMS Requests"
        vwTopHeader.lblSubTitle.isHidden = true
        
    }
    
    
    @IBAction func btnApplyTapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LMSBaseViewController") as! LMSBaseViewController
//        vc.response = tcrResponse
//        vc.isFromView = isFromView
//        vc.tcrBaseDelegate = self
//        vc.notifyChilds = self
//        vc.title = tcrData.headRef
//        vc.voucherResponse = response.result.value
//        vc.tcrData = tcrData
        self.navigationController!.pushViewController(vc, animated: true)
    }
    

}



extension LMSReqController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let data = arrayList[indexPath.row]
        let views = tableView.dequeueReusableCell(withIdentifier: "cell") as! LMSGridCell
//        views.setdataToView(data : data)
        views.selectionStyle = .none
        
        return views
    }
    
}


extension LMSReqController: WC_HeaderViewDelegate {
    
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
