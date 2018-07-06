//
//  EmployeeAdapter.swift
//  mocs
//
//  Created by Admin on 3/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


protocol addNewContactDelegate {
    func openAddNewContact( phNo : String)
}

/// Employee Cell
class EmployeeAdapter: UITableViewCell {

    /// Label for Employee name
    @IBOutlet weak var lblEmployeeName: UILabel!
    
    /// Label for Employee code
    @IBOutlet weak var lblEmployeeCode: UILabel!
    
    /// Button More
    @IBOutlet weak var btnMore: UIButton!
    
    /// Inner view
    @IBOutlet weak var innerView: UIView!
    
    /// onMoreClickListener delegate object
    weak var delegate:onMoreClickListener?
    
    /// Object of type employee data
    weak var data:EmployeeData!
    
    /// Add new contact delegate
    var addNewCnctDelegate : addNewContactDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerView.layer.shadowOpacity = 0.25
        innerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        innerView.layer.shadowRadius = 1
        innerView.layer.shadowColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Method to assign data of type EmployeeData to views
    public func setDataToView(data:EmployeeData){
        lblEmployeeName.text = data.name.trimmingCharacters(in: .whitespacesAndNewlines)
        lblEmployeeCode.text = data.id.trimmingCharacters(in: .whitespacesAndNewlines)
        self.data = data
    }
    
    /// Action method called when tap on "More" . Opens Alert view where user can interact with contact details.
    @IBAction func more_click(_ sender: UIButton) {
        
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).numberOfLines = 2
        
        if (delegate?.responds(to: Selector(("onClick:"))) != nil){
            
            let moreOption = UIAlertController(title: data.name, message: data.id, preferredStyle: .actionSheet)
            
            /// For watsapp option
            let whatsApp = UIAlertAction(title: ("\(data.whatsApp)"), style: .default, handler: { (UIAlertAction) -> Void in
                let urlWhats = "whatsapp://send?phone=+\(self.data.whatsApp)&text="
                if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                    if let whatsappURL = URL(string: urlString) {
                        if UIApplication.shared.canOpenURL(whatsappURL) {
                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                        } else {
                            Helper.showMessage(message: "Please Install Watsapp")
                        }
                    }
                }
            })
            let watImg = #imageLiteral(resourceName: "watsapp")
            whatsApp.setValue(watImg, forKey: "image")
            
            /// For Dialer option
            let dialApp = UIAlertAction(title: ("Call \(data.whatsApp)"), style: .default, handler: { (UIAlertAction) -> Void in
                if let url = URL(string: "tel://\(self.data.whatsApp)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            let dailer = #imageLiteral(resourceName: "phone_call")
            dialApp.setValue(dailer, forKey: "image")
            
            /// For Adding new contact option
            let newContact = UIAlertAction(title: "Add To Contact", style: .default, handler: { (UIAlertAction) -> Void in
                if let d = self.addNewCnctDelegate {
                    d.openAddNewContact(phNo: self.data.whatsApp)
                }
            })
            let newNum = #imageLiteral(resourceName: "add_contact")
            newContact.setValue(newNum, forKey: "image")
            
            /// For Skype Option
            let skype = UIAlertAction(title: ("\(data.skypeId)"), style: .default, handler: { (UIAlertAction) -> Void in
                let skypeUrl = URL(string: "skype:\(self.data.skypeId)?chat")!
                if UIApplication.shared.canOpenURL(skypeUrl) {
                    UIApplication.shared.open(skypeUrl, options: [:], completionHandler: nil)
                }
                else {
                    Helper.showMessage(message: "Please Install Skype")
                }
            })
            let skypeImg = #imageLiteral(resourceName: "skype_icon")
            skype.setValue(skypeImg, forKey: "image")
            
            /// For Email Option
            let email = UIAlertAction(title: "\(data.emailId)", style: .default, handler: { (UIAlertAction) -> Void in
                if let url = URL(string: "mailto:\(self.data.emailId)") {
                    UIApplication.shared.open(url)
                }
            })
            let emailIcn = #imageLiteral(resourceName: "email_icon")
            email.setValue(emailIcn, forKey: "image")
            
           /// VOIP option
            let voIP = UIAlertAction(title: "\(data.voIP)", style: .default, handler: { (UIAlertAction) -> Void in
               
            })
            let voipIcn = #imageLiteral(resourceName: "voip")
            voIP.setValue(voipIcn, forKey: "image")
            
            /// Following conditions to be added to check if data is available, accordingly buttons are added to view
            if data.whatsApp != "" {
                if data.whatsApp != "NA" {
                    moreOption.addAction(whatsApp)
                    moreOption.addAction(dialApp)
                }
            }
            
            if data.skypeId != "" {
                if data.skypeId != "NA" {
                    moreOption.addAction(skype)
                }
            }

            if data.voIP != "" {
                if data.voIP != "NA" {
                    moreOption.addAction(voIP)
                }
            }
            
            if data.emailId != "" {
                if data.emailId != "NA" {
                    moreOption.addAction(email)
                }
            }
            
            if data.whatsApp != "" {
                if data.whatsApp != "NA" {
                    moreOption.addAction(newContact)
                }
            }
                
            moreOption.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            delegate!.onClick(optionMenu: moreOption, sender: sender)
        }
    }
}
