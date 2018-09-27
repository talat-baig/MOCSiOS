//
//  TravelTicketAddEditVC.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NotificationCenter
import DropDown

class TravelTicketAddEditVC: UIViewController , IndicatorInfoProvider, UIGestureRecognizerDelegate {
    
    var ttData = TTData()
    
    var arrCompany = ["Technogen IT Services","Phoenix Global Trade Solutions","Phoenix Global DMCC"]
    var arrTrvlrName = ["Talat","Ravi","Hardik"]
    //    var arrDept = ["Talat","Ravi","Hardik"]
    
    
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var btnTrvllerName: UIButton!
    
    @IBOutlet weak var btnDept: UIButton!
    
    @IBOutlet weak var swtchGuest: UISwitch!
    @IBOutlet weak var swtchPurpose: UISwitch!
    
    @IBOutlet weak var swtchTrvlType: UISwitch!
    
    @IBOutlet weak var btnTrvlMode: UIButton!
    
    @IBOutlet weak var btnTrvlClass: UIButton!
    
    @IBOutlet weak var btnDebtAcNo: UIButton!
    
    @IBOutlet weak var vwTrvlComp: UIView!
    @IBOutlet weak var vwTrvlName: UIView!
    @IBOutlet weak var vwDept: UIView!
    @IBOutlet weak var vwTrvlMode: UIView!
    @IBOutlet weak var vwTrvlClass: UIView!
    @IBOutlet weak var vwDebtAcNme: UIView!
    
    @IBOutlet weak var lblTrvType: UILabel!
    
    @IBOutlet weak var lblPurpse: UILabel!
    
    @IBOutlet weak var vwTrvType: UIView!
    
    @IBOutlet weak var vwPurpose: UIView!
    
    @IBOutlet weak var stckVw: UIStackView!
    
    
    @IBOutlet weak var txtDept: UITextField!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalSetup()
        
        let ttAddEditVC = self.parent as! TTBaseViewController
        ttAddEditVC.saveTTAddEditReference(vc: self)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        
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
        //        stckVw.frame  = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height + 200)
        
        Helper.addBordersToView(view: vwTrvlComp)
        Helper.addBordersToView(view: vwDept)
        Helper.addBordersToView(view: vwTrvlMode)
        Helper.addBordersToView(view: vwTrvlName)
        Helper.addBordersToView(view: vwDebtAcNme)
        Helper.addBordersToView(view: vwTrvlClass)
        Helper.addBordersToView(view: vwTrvType)
        Helper.addBordersToView(view: vwPurpose)
        
        
        swtchGuest.addTarget(self, action: #selector(guestType(mySwitch:)), for: UIControlEvents.valueChanged)
        swtchPurpose.addTarget(self, action: #selector(purposeType(mySwitch:)), for: UIControlEvents.valueChanged)
        swtchTrvlType.addTarget(self, action: #selector(trvType(mySwitch:)), for: UIControlEvents.valueChanged)
        
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lastView : UIView! = mySubVw.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos + 100
        print(sizeOfContent)
        scrlVw.contentSize.height = sizeOfContent
    }
    
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func trvType(mySwitch: UISwitch) {
        if mySwitch.isOn {
            lblTrvType.text = "International"
        } else {
            lblTrvType.text = "Domestic"
        }
    }
    
    @objc func guestType(mySwitch: UISwitch) {
        if mySwitch.isOn {
            //            lbl.text = "International"
        } else {
            //            lblTrvType.text = "Domestic"
        }
    }
    
    @objc func purposeType(mySwitch: UISwitch) {
        if mySwitch.isOn {
            lblPurpse.text = "Personal"
        } else {
            lblPurpse.text = "Official"
        }
    }
    
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        let home = self.parent as! TTBaseViewController
        
        home.deptStr = txtDept.text!
        
        home.moveToViewController(at: 1, animated: true)
    }
    
    
    @IBAction func btnCompanyTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnCompany
        dropDown.dataSource = arrCompany
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnCompany.setTitle(item, for: .normal)
        }
        dropDown.show()
        
    }
    
    @IBAction func btnTrvlrNameTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnTrvllerName
        dropDown.dataSource = arrTrvlrName
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnTrvllerName.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
}

extension TravelTicketAddEditVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.handleTap()
        return true
    }
}

extension TravelTicketAddEditVC: WC_HeaderViewDelegate {
    
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
