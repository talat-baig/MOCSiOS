//
//  TravelRequestNonEditVC.swift
//  mocs
//
//  Created by Talat Baig on 9/20/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class TravelRequestNonEditVC: UIViewController, IndicatorInfoProvider, customPopUpDelegate {
    
    var trfData: TravelRequestData?
    
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblEmpCode: UILabel!
    @IBOutlet weak var lblDept: UILabel!
    @IBOutlet weak var lblDesgntn: UILabel!
    @IBOutlet weak var lblReportMngr: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblTrvlArngmnt: UILabel!
    
    @IBOutlet weak var lblAccmpnd: UILabel!
    
    @IBOutlet weak var lblReqBy: UILabel!
    @IBOutlet weak var lblApprvdBy: UILabel!
    @IBOutlet weak var lblApprvdByDate: UILabel!
    @IBOutlet weak var lblReqByDate: UILabel!

    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    var myView = CustomPopUpView()
    var declView = CustomPopUpView()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TRAVEL DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func declineTapped(_ sender: Any) {
        
//        self.handleTap()
        let window = UIApplication.shared.keyWindow!
        self.declView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declView.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Travel Request? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove: false)
        declView.data = trfData
        declView.isApprove = false
        declView.cpvDelegate = self
        declView.center = window.center
        window.addSubview(self.declView)
    }
    
    
    @IBAction func approveTapped(_ sender: Any) {
//        self.handleTap()
        let window = UIApplication.shared.keyWindow!
        self.myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        self.myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Travel Request? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove: true)
        self.myView.data = trfData
        self.myView.cpvDelegate = self
        self.myView.isApprove = true
        myView.center = window.center
        window.addSubview(self.myView)
    }
    
    
    func assignData(){
        
        guard let trfDta = trfData else {
            return
        }
       
//        lblEmpName.text! = trfDta.empName
        
        if trfDta.empName == "" {
            lblEmpName.text! = "-"
        } else {
            lblEmpName.text! = trfDta.empName
        }
        
        if trfDta.trvArrangmnt == "" {
           lblTrvlArngmnt.text! = "-"
        } else {
            lblTrvlArngmnt.text! = trfDta.trvArrangmnt
        }
        
        if trfDta.reason == "" {
            lblReason.text! = "-"
        } else {
            lblReason.text! = trfDta.reason
        }
        
        if trfDta.accmpnd == "" {
             lblAccmpnd.text! = "-"
        } else {
            lblAccmpnd.text! = trfDta.accmpnd
        }
        
//        lblEmpCode.text! = Session.empCode
//        lblDept.text! = Session.department
//        lblDesgntn.text! = Session.designation
        
        lblEmpCode.text! = trfDta.empCode
        lblDept.text! = trfDta.empDept
        lblDesgntn.text! = trfDta.empDesgntn
       
        if trfDta.approver == "" {
            lblApprvdBy.text! = "-"
        } else {
            lblApprvdBy.text! = trfDta.approver
        }
        
        if trfDta.requestor == "" {
            lblReqBy.text! = "-"
        } else {
            lblReqBy.text! = trfDta.requestor
        }
        
        if trfDta.reqDate == "" {
            lblReqByDate.text! = "-"
        } else {
            lblReqByDate.text! = trfDta.reqDate
        }
        
        if trfDta.approvdDate == "" {
            lblApprvdByDate.text! = "-"
        } else {
            lblApprvdByDate.text! = trfDta.approvdDate
        }
        
        if trfDta.reportMngr == "" {
            lblReportMngr.text! = "-"
        } else {
            lblReportMngr.text! = trfDta.reportMngr
        }
    }
    
    
    
    func showSuccessAlert() {
        
        let alert = UIAlertController(title: "Success", message: "Travel Request Successfully Approved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
            (UIAlertAction) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constant.TRF.trfPopulate), object: self)
            
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeclineAlert() {
        let alert = UIAlertController(title: "Success", message: "Travel Request Successfully Declined", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
            (UIAlertAction) -> Void in
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constant.TRF.trfPopulate), object: self)
            
            
           self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        
        var commnt = ""
        if text == "" || text == "Enter Comment" || text == "Enter Comment (Optional)" {
            commnt = ""
        } else {
            commnt = text
        }
        
        if isApprove {
            
            self.approveOrDeclineTRF(event: 1, trData: data as! TravelRequestData, comment: commnt)
            myView.removeFromSuperviewWithAnimate()
        } else {
            
            if text == "" || text == "Enter Comment" {
                Helper.showMessage(message: "Please Enter Comment")
                return
            }
            
            self.approveOrDeclineTRF(event: 2, trData: data as! TravelRequestData , comment: commnt)
            declView.removeFromSuperviewWithAnimate()
        }
    }
    
    func approveOrDeclineTRF( event : Int, trData:TravelRequestData, comment:String) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.TRF.TRF_APPROVE, Session.authKey, trData.trfId, event, Helper.encodeURL(url: comment))
            self.view.showLoading()
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    if event == 1 {
                        self.showSuccessAlert()
                    } else {
                        self.showDeclineAlert()
                    }
                }
            })
        } else {
            
        }
    }
    
}
