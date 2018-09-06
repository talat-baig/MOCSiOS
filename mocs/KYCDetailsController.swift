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

class KYCDetailsController: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate {
  
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "KYC DETAILS")
    }
    
    
    
    @IBOutlet weak var btnKYCDetails: UIButton!
    
    @IBOutlet weak var btnKYCContctType: UIButton!
    @IBOutlet weak var btnKYCRequired: UIButton!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var txtValidUntill: UITextField!
    @IBOutlet weak var scrlVw: UIScrollView!

    @IBOutlet weak var stckVwKYCRqd: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var datePickerTool: UIView!
    @IBOutlet weak var btnSDNListChk: UIButton!
    
    @IBOutlet weak var btnAttachmnt: UIButton!
    
    let arrKYCReq = ["Yes", "No"]
    let arrKYCContctType = ["Trade", "Admin", "Trade & Admin"]
    
    
    
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
        
        //        let kycVC = self.storyboard?.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
