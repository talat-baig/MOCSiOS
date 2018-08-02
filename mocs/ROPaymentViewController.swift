//
//  ROPaymentViewController.swift
//  mocs
//
//  Created by Talat Baig on 7/6/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip

class ROPaymentViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var tableView: UITableView!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "CARGO INFO")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CargoInfoCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension ROPaymentViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = arrayList[indexPath.row]
        let views = tableView.dequeueReusableCell(withIdentifier: "cell") as! CargoInfoCell
        views.selectionStyle = .none
        views.menuDelegate = self
        views.optionMenuDelegate = self
        views.btnMore.tag = indexPath.row
        if indexPath.row == 1 {
            views.lblStatus.isHidden = true
            views.lblWHRNum.text = "WHR17-25-CAL-19-009"
        }
        return views
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let caroDetails = self.storyboard?.instantiateViewController(withIdentifier: "ROCargoDetailsEditVC") as! ROCargoDetailsEditVC
        self.navigationController?.pushViewController(caroDetails, animated: true)
    }
}


extension ROPaymentViewController: onCargoMoreClickListener , onCargoOptionIemClickListener {
   
    func onApproveClick() {
        
    }
    
    func onViewClick() {
        let roDetails = self.storyboard?.instantiateViewController(withIdentifier: "ROPaymentViewController") as! ROPaymentViewController
//        taskDetails.taskData = selectedData
    }
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
         self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onCancelClick() {
        
    }
    
    
}


