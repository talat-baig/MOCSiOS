//
//  AddNewRecordRcptVC.swift
//  mocs
//
//  Created by Talat Baig on 7/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import DropDown

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
    
    let arrUOM = ["Mt","Kg"]
    
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
        
        vwRcptDate.layer.borderWidth = 1
        vwRcptDate.layer.borderColor = UIColor.lightGray.cgColor
        vwRcptDate.layer.cornerRadius = 5
        vwRcptDate.layer.masksToBounds = true;
        
        vwReleaseOrderNum.layer.borderWidth = 1
        vwReleaseOrderNum.layer.borderColor = UIColor.lightGray.cgColor
        vwReleaseOrderNum.layer.cornerRadius = 5
        vwReleaseOrderNum.layer.masksToBounds = true;
        
        vwQtyRcvd.layer.borderWidth = 1
        vwQtyRcvd.layer.borderColor = UIColor.lightGray.cgColor
        vwQtyRcvd.layer.cornerRadius = 5
        vwQtyRcvd.layer.masksToBounds = true;
        
        vwUOM.layer.borderWidth = 1
        vwUOM.layer.borderColor = UIColor.lightGray.cgColor
        vwUOM.layer.cornerRadius = 5
        vwUOM.layer.masksToBounds = true;
        
        vwDescription.layer.borderWidth = 1
        vwDescription.layer.borderColor = UIColor.lightGray.cgColor
        vwDescription.layer.cornerRadius = 5
        vwDescription.layer.masksToBounds = true;
        
        btnUom.setTitle("Mt", for: .normal)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomPopUpView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomPopUpView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        
//        let lastView : UIView! = mySubVw.subviews.last
//        let height = lastView.frame.size.height
//        let pos = lastView.frame.origin.y
//        let sizeOfContent = height + pos + 30
//        
//        scrlVw.contentSize.height = sizeOfContent
    }
    
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
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
        }
        
//        if textField == txtDesc {
////            datePickerTool.isHidden = false
//            let scrollPoint:CGPoint = CGPoint(x:0, y:  stckVwQty.frame.origin.y + 10 )
//            scrlVw!.setContentOffset(scrollPoint, animated: true)
//        }
        
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
