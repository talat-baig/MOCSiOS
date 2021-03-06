//
//  AddNewRecordRcptVC.swift
//  mocs
//
//  Created by Talat Baig on 7/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import NotificationBannerSwift


protocol onRRcptSubmit: NSObjectProtocol {
    func onOkClick() -> Void
}


class AddNewRecordRcptVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var txtRcptDate: UITextField!
    
    @IBOutlet weak var txtRONum: UITextField!
    
    @IBOutlet weak var btnUom: UIButton!
    
    @IBOutlet weak var txtQtyRcvd: UITextField!
    
    @IBOutlet weak var txtDesc: UITextView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var mySubVw: UIView!
    
    @IBOutlet weak var vwRcptDate: UIView!
    
    @IBOutlet weak var stckVwQty: UIStackView!
    
    @IBOutlet weak var vwReleaseOrderNum: UIView!
    
    @IBOutlet weak var vwQtyRcvd: UIView!
    
    @IBOutlet weak var vwUOM: UIView!
    
    @IBOutlet weak var vwDescription: UIView!
    
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var okSubmitDelegate : onRRcptSubmit?
    
    @IBOutlet weak var lblReqQty: UILabel!
    
    @IBOutlet weak var lblRcptQty: UILabel!
    
    @IBOutlet weak var lblBalQty: UILabel!
    
    @IBOutlet weak var vwTillDateVal: UIView!
    
    var roRefId : String = ""
    
    var whrData = WHRListData()
    
    let arrUOM = ["MT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Record Receipt"
        vwTopHeader.lblSubTitle.isHidden = true
        
        txtRcptDate.inputView = datePickerTool
        
        Helper.addBordersToView(view: vwRcptDate)
        Helper.addBordersToView(view: vwReleaseOrderNum)
        Helper.addBordersToView(view: vwQtyRcvd)
        Helper.addBordersToView(view: vwUOM)
        Helper.addBordersToView(view: vwDescription)
        
        btnUom.setTitle("MT", for: .normal)
        
        vwTillDateVal.layer.borderWidth = 1
        vwTillDateVal.layer.borderColor = UIColor.lightGray.cgColor
        
        lblReqQty.text =  String(format:"%.2f",Double(whrData.reqQty ) ?? 0.0)
        lblRcptQty.text = String(format:"%.2f",Double(whrData.rcptQty ) ?? 0.0)
        lblBalQty.text =  String(format:"%.2f",Double(whrData.balQty  ) ?? 0.0)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomPopUpView.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomPopUpView.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(doThisWhenNotify),
                                               name: .relOrderNotify,
                                               object: nil)
        
    }
    
    @objc func doThisWhenNotify() {
        print("Populated RO List")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        
        guard let rcptDate = txtRcptDate.text, !rcptDate.isEmpty else {
            Helper.showMessage(message: "Please enter Receipt Date")
            return
        }
        
        guard let roNumbr = txtRONum.text, !roNumbr.isEmpty else {
            Helper.showMessage(message: "Please enter RO Number")
            return
        }
        
        guard let qtyRcvd = txtQtyRcvd.text, !qtyRcvd.isEmpty else {
            Helper.showMessage(message: "Please enter Quantity Received")
            return
        }
        
        self.handleTap()
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            
            let url = String.init(format: Constant.RO.ADD_RECEIPT, Session.authKey, Session.email)
            print(url)
            
            
            let newRecord = ["ROReferenceID": self.roRefId, "IsDeleted": "0", "ROReceiveReleaseOrderNo": roNumbr, "ROReceiveReceiptDate": rcptDate , "ROReceiveQuantityReceived":  txtQtyRcvd.text as Any, "ROReceiveQuantityReceivedinmt":  txtQtyRcvd.text as Any , "ROReceiveUOM":  btnUom.titleLabel?.text as Any , "ROReceiveDescription": txtDesc.text as Any, "ROReceivedByUser": Session.user, "ROReceivedDate" : "" , "ROGUID" : whrData.whrNum, "ROExRelease": "0"] as [String : Any]
            
            
            Alamofire.request(url, method: .post, parameters: newRecord, encoding: JSONEncoding.default)
                .responseString(completionHandler: {  response in
                    self.view.hideLoading()
                    debugPrint(response.result.value as Any)
                    
                    let jsonResponse = JSON.init(parseJSON: response.result.value!)
                    print(jsonResponse)
                    
                    if jsonResponse["ServerMsg"].stringValue == "Success" {
                        let success = UIAlertController(title: "Success", message: "Receipt Added Successfully", preferredStyle: .alert)
                        success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
                            
                            NotificationCenter.default.post(name: .relOrderNotify, object: self)
                            
                            if let viewController = self.navigationController?.viewControllers.first(where: {$0 is ReleaseOrderController}) {
                                self.navigationController?.popToViewController(viewController, animated: false)
                            }
                        }))
                        self.present(success, animated: true, completion: nil)
                    } else if jsonResponse["ServerMsg"].stringValue == "Sorry you cannot Process this request, Receipt Qty is greater than the Received Quantity, please check" {
                        
                        NotificationBanner(title: "", subtitle: "Sorry you cannot Process this request, Receipt Qty is greater than the Received Quantity, please check", style: .danger).show()
                        
                    } else {
                        
                        NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again later", style:.info).show()
                    }
                })
        }
    }
    
    @IBAction func btnUOMTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnUom
        dropDown.dataSource = arrUOM
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnUom.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    
    @IBAction func btnDoneTapped(sender:UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtRcptDate.text = dateFormatter.string(from: datePicker.date) as String
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
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
    
}



extension AddNewRecordRcptVC: UITextFieldDelegate , UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtRcptDate {
            datePickerTool.isHidden = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            let newMinDate = dateFormatter.date(from: whrData.whrDate)
            datePicker.minimumDate = newMinDate
            datePicker.maximumDate = Date.distantFuture
            
        }
        return true
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == txtDesc {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwReleaseOrderNum.frame.origin.y )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
    }
    
}


extension AddNewRecordRcptVC: WC_HeaderViewDelegate {
    
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
