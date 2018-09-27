//
//  TravelTicketInformationVC.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import DropDown

class TravelTicketInformationVC: UIViewController, IndicatorInfoProvider , UIGestureRecognizerDelegate{

   
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var stckVw: UIStackView!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var mySubVw: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCarrier: UIButton!
    
    @IBOutlet weak var txtBookingDate: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtTicktNo: UITextField!
    @IBOutlet weak var txtTicktPnrNo: UITextField!
    @IBOutlet weak var txtTicktCost: UITextField!
    @IBOutlet weak var txtTrvlStatus: UITextField!
    @IBOutlet weak var txtComments: UITextView!
    @IBOutlet weak var txtInvoiceNo: UITextField!
    
    @IBOutlet weak var switchAdvance: UISwitch!
    
    @IBOutlet weak var btnAdvances: UIButton!
    @IBOutlet weak var btnApprovedBy: UIButton!
    @IBOutlet weak var btnTrvlAgent: UIButton!
    @IBOutlet weak var btnCurrncy: UIButton!

    
    @IBOutlet weak var vwCarrier: UIView!
    @IBOutlet weak var vwTicktNo: UIView!
    @IBOutlet weak var vwTicktIssueDte: UIView!
    @IBOutlet weak var vwTicktExpiryDte: UIView!
    @IBOutlet weak var vwPNRNo: UIView!
    @IBOutlet weak var vwtrvlAgent: UIView!
    @IBOutlet weak var vwTrvlStatus: UIView!
    @IBOutlet weak var vwTicktCost: UIView!
    @IBOutlet weak var vwInvoice: UIView!
    @IBOutlet weak var vwApprvdBy: UIView!
    @IBOutlet weak var vwCommnts: UIView!
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TICKET INFORMATION")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        let ttBaseVC = self.parent as? TTBaseViewController
        ttBaseVC?.saveTTInfoReference(vc: self)
    }
    
    func initalSetup() {
        
        
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
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.isHidden = true
        
        Helper.addBordersToView(view: vwTicktIssueDte)
        Helper.addBordersToView(view: vwTrvlStatus)
        Helper.addBordersToView(view: vwTrvlStatus)
        Helper.addBordersToView(view: vwtrvlAgent)
        Helper.addBordersToView(view: vwTicktExpiryDte)
        Helper.addBordersToView(view: vwApprvdBy)
        Helper.addBordersToView(view: vwTicktCost)
        Helper.addBordersToView(view: vwTicktNo)
        Helper.addBordersToView(view: vwCarrier)
        Helper.addBordersToView(view: vwPNRNo)
        Helper.addBordersToView(view: vwInvoice)
        Helper.addBordersToView(view: vwCommnts)

        
//        btnCurrncy.layer.cornerRadius = 3
//        btnCurrncy.layer.borderWidth = 0.5
//        btnCurrncy.layer.borderColor = AppColor.lightGray.cgColor
//
        btnAdvances.layer.cornerRadius = 3
        btnAdvances.layer.borderWidth = 0.5
        btnAdvances.layer.borderColor = UIColor.lightGray.cgColor
        
        
//        swtchTrvlType.addTarget(self, action: #selector(trvType(mySwitch:)), for: UIControlEvents.valueChanged)
        
        
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
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 1350 )
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        
    }
    
}


extension TravelTicketInformationVC: UITextFieldDelegate , UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
//        datePickerTool.isHidden = true
        self.view.endEditing(true)
        return true
    }
}





