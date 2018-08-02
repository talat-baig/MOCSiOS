//
//  ROCargoDetailsEditVC.swift
//  mocs
//
//  Created by Talat Baig on 7/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class ROCargoDetailsEditVC: UIViewController {
    
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Record Receipt"
        vwTopHeader.lblSubTitle.text = "WHR17-25-CAL-19-008"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lastView : UIView! = mySubVw.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos + 100
        
        scrlVw.contentSize.height = sizeOfContent
    }
    
    @IBAction func addNewRRTapped(_ sender: Any) {
        
        let expAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewRecordRcptVC") as! AddNewRecordRcptVC
        
        self.navigationController?.pushViewController(expAddEditVC, animated: true)
    }
    
}

// MARK: - WC_HeaderViewDelegate methods
extension ROCargoDetailsEditVC: WC_HeaderViewDelegate {
    
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

extension ROCargoDetailsEditVC: UITableViewDelegate, UITableViewDataSource, onRRcptMoreClickListener, onRRcptItemClickListener  {
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
          self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onCancelClick() {
        
    }
    
    func onReceiveClick() {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recRcptCell = tableView.dequeueReusableCell(withIdentifier: "rrcell") as! RecordReceiptCell
        recRcptCell.rrMenuDelegate = self
        recRcptCell.rrOptionClickDelegate = self
        recRcptCell.selectionStyle = .none
        recRcptCell.btnMore.tag = indexPath.row
        
        return recRcptCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}

