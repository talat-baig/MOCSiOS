//
//  KYCDetailsController.swift
//  mocs
//
//  Created by Talat Baig on 8/29/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown
import Alamofire
import SwiftyJSON
import NotificationBannerSwift

protocol onCPApprove: NSObjectProtocol {
    func onOkClick() -> Void
}


class KYCDetailsController: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate, customPopUpDelegate {
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "KYC DETAILS")
    }
    
    
    var cpData = CPListData()
    var kycResp : Data?
    
    var myView = CustomPopUpView()
    var declView = CustomPopUpView()
    
    @IBOutlet weak var btnKYCDetails: UIButton!
    
    @IBOutlet weak var btnKYCContctType: UIButton!
    @IBOutlet weak var btnKYCRequired: UIButton!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var txtValidUntill: UITextField!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    weak var okCPApprove : onCPApprove?
    
    @IBOutlet weak var stckVw: UIStackView!
    
    
    @IBOutlet weak var btnProcess: UIButton!
    @IBOutlet weak var stckVwKYCRqd: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var datePickerTool: UIView!
    @IBOutlet weak var btnSDNListChk: UIButton!
    
    @IBOutlet weak var btnAttachmnt: UIButton!
    
    let arrKYCReq = ["Yes", "No"]
    let arrKYCContctType = ["Trade", "Admin", "Trade&Admin"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        
        btnKYCContctType.layer.cornerRadius = 5
        btnKYCContctType.layer.borderWidth = 1
        btnKYCContctType.layer.borderColor =  AppColor.lightGray.cgColor
        
        
        btnKYCRequired.layer.cornerRadius = 5
        btnKYCRequired.layer.borderWidth = 1
        btnKYCRequired.layer.borderColor =  AppColor.lightGray.cgColor
        
        btnAttachmnt.layer.cornerRadius = 5
        btnAttachmnt.layer.borderWidth = 1
        btnAttachmnt.layer.borderColor = AppColor.lightGray.cgColor
        
        btnSDNListChk.layer.cornerRadius = 5
        btnSDNListChk.layer.borderWidth = 1
        btnSDNListChk.layer.borderColor = AppColor.lightGray.cgColor
        
        
        btnKYCContctType.setTitle("Tap to Select", for: .normal)
        btnKYCRequired.setTitle("Tap to Select", for: .normal)
        btnSDNListChk.setTitle("Tap to Select", for: .normal)
        
        
        txtValidUntill.inputView = datePickerTool
        
        mySubVw.layer.cornerRadius = 2
        mySubVw.layer.borderWidth = 1.0
        mySubVw.layer.borderColor =  AppColor.lightGray.cgColor
        
        
        parseAndAssign()
    }
    
    func parseAndAssign() {
        
        let jsonResponse = JSON(kycResp!)
        for(_,j):(String,JSON) in jsonResponse {
            
            if j["KYCContactType"].stringValue == "" {
                btnKYCContctType.setTitle("Tap to Select" , for: .normal)
            } else {
                btnKYCContctType.setTitle(j["KYCContactType"].stringValue , for: .normal)
            }
            
            if j["KYCRequired"].stringValue == "" {
                btnKYCRequired.setTitle("Tap to Select" , for: .normal)
            } else {
                btnKYCRequired.setTitle(j["KYCRequired"].stringValue , for: .normal)
            }
            
          
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight : CGFloat
            keyboardHeight = keyboardRectangle.height
            var contentInset:UIEdgeInsets = self.scrlVw.contentInset
            contentInset.bottom = keyboardHeight
            
            self.scrlVw.isScrollEnabled = true
            self.scrlVw.contentInset = contentInset
        }
    }
    
    
    /// Invoked before hiding keyboard and used to move view down
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrlVw.isScrollEnabled = true
        let contentInset:UIEdgeInsets = .zero
        self.scrlVw.contentInset = contentInset
    }
    
    @IBAction func btnAddKYCDetails(_ sender: Any) {
        
        getKYCDetailsAndNavigate()
        
    }
    
    func approveOrDeclineCP( event : Int, data:CPListData, comment:String){
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.CP.CP_APPROVE, Session.authKey,
                                  Helper.encodeURL(url: data.custId), event,(btnKYCContctType.titleLabel?.text)!, (btnKYCRequired.titleLabel?.text)!, data.refId )
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                let jsonResponse = JSON(response.result.value!)
                
                if jsonResponse.dictionaryObject != nil {
                    
                    let data = jsonResponse.dictionaryObject
                    
                    if data != nil {
                        
                        if (data?.count)! > 0 {
                            
                            switch data!["ServerMsg"] as! String {
                            case "Success":
                                let alert = UIAlertController(title: "Success", message: "Counterparty Successfully Approved", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                                    (UIAlertAction) -> Void in
                                    if let d = self.okCPApprove {
                                        d.onOkClick()
                                    }
                                    
                                    if let navController = self.navigationController {
                                        navController.popViewController(animated: true)
                                    }
                                }))
                                self.present(alert, animated: true, completion: nil)
                                break
                                
                            default:
                                NotificationBanner(title: data!["ServerMsg"] as! String   ,style: .danger).show()

                                break
                            }
                        }
                    } else {
                        
                    }
                }
                
            }))
        } else {
            
        }
    }
    
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        if isApprove {
            self.approveOrDeclineCP(event: 1, data: data as! CPListData, comment: text)
            myView.removeFromSuperviewWithAnimate()
        } else {
            
            if text == "" || text == "Enter Comment" {
                Helper.showMessage(message: "Please Enter Comment")
                return
            } else {
                self.approveOrDeclineCP(event: 2, data: data as! CPListData , comment: text)
                declView.removeFromSuperviewWithAnimate()
            }
        }
    }
    
    func getKYCDetailsAndNavigate()  {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CP.CP_KYC_DETAILS, Session.authKey, cpData.custId)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let responseJson = JSON(response.result.value!)
                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrData.count > 0) {
                        
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
                        vc.response = response.result.value
                        vc.custId = self.cpData.custId
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.view.makeToast("No Data To Show")
                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
        
    }
    
    @IBAction func btnKYCContctTypeTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnKYCContctType
        dropDown.dataSource = arrKYCContctType
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnKYCContctType.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    
    @IBAction func btnProcessTapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let approveAction = UIAlertAction(title: "Approve", style: .default, handler: { (UIAlertAction) -> Void in
            
            self.handleTap()
            self.myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
            self.myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Counterparty? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove: true)
            self.myView.data = self.cpData
            self.myView.cpvDelegate = self
            self.myView.isApprove = true
            self.view.addMySubview(self.myView)
        })
        
        
        let declineAction = UIAlertAction(title: "Decline", style: .default, handler: { (UIAlertAction) -> Void in
            
            self.handleTap()
            self.declView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
            self.declView.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Counterparty? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove:  false)
            self.declView.data = self.cpData
            self.declView.isApprove = false
            self.declView.cpvDelegate = self
            self.view.addMySubview( self.declView)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) -> Void in
        })
        
        optionMenu.addAction(approveAction)
        optionMenu.addAction(declineAction)
        optionMenu.addAction(cancelAction)
        
        
        if btnKYCContctType.titleLabel?.text == "Tap to Select" {
            Helper.showMessage(message: "Enter KYC Contact Type")
            return
        }
        
        
        if btnKYCRequired.titleLabel?.text == "Tap to Select" {
            Helper.showMessage(message: "Enter KYC Required")
            return
        }
        
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func btnKYCReqTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnKYCRequired
        dropDown.dataSource = arrKYCReq
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnKYCRequired.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    @IBAction func btnSDNListChk(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnSDNListChk
        dropDown.dataSource = arrKYCReq
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnSDNListChk.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    
    @IBAction func btnDoneTapped(sender:UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtValidUntill.text = dateFormatter.string(from: datePicker.date) as String
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    
}



extension KYCDetailsController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        self.view.endEditing(true)
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtValidUntill {
            datePickerTool.isHidden = false
            let scrollPoint:CGPoint = CGPoint(x:0, y: stckVwKYCRqd.frame.origin.y)
            scrlVw!.setContentOffset(scrollPoint, animated: true)
            
        }
        return true
    }
    
    
    
    
    
}
