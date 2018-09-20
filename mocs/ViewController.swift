//
//  ViewController.swift
//  mocs
//
//  Created by Rv on 21/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class ViewController: UIViewController {
    
    @IBOutlet weak var btnShowPasswd: UIButton!
    @IBOutlet weak var editUsername: UITextField!
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var iconClick : Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        editUsername.autocorrectionType = .default
        iconClick = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func onLoginClickListener(_ sender: Any) {
        if editUsername.text == ""{
            Helper.showMessage(message: "Please Enter Username")
        } else if editPassword.text == ""{
            Helper.showMessage(message: "Please Enter Password")
        } else {
            let url = String(format:Constant.API.LOGIN,editUsername.text!,Helper.encodeURL(url:  editPassword.text!),UIDevice.current.identifierForVendor!.uuidString)
            loginToOcs(url: url)
        }
    }
    
    func loginToOcs(url:String){
        self.view.showLoading()
        self.view.endEditing(true)
        Alamofire.request(url).responseData(completionHandler: ({ response in
            self.view.hideLoading()
            
            
            if Helper.isResponseValid(vc: self, response: response.result){
                
                //index -> Index of Array
                //subjson -> JsonObject from Array
                let jsonResponse = JSON(response.result.value!)
                for(_,subjson):(String,JSON) in jsonResponse{

                    Session.login = true
                    Session.authKey = subjson["AuthID"].stringValue
                    Session.email = subjson["OfficialEmailId"].stringValue
                    Session.user = subjson["EmailID"].stringValue
                    Session.company = subjson["Company"].stringValue
                    Session.location = subjson["Location"].stringValue
                    Session.department = subjson["Department"].stringValue
                    Session.dbtoken = subjson["DBToken"].stringValue
                    Session.empCode = subjson["EmployeeCode"].stringValue
                    Session.reportMngr = subjson["ReportingManager"].stringValue
                    Session.designation = subjson["Designation"].stringValue

                    
                    self.getCurrency()
                    debugPrint(Session.authKey)
                    debugPrint(Session.empCode)
                    debugPrint(Session.reportMngr)
                    debugPrint(Session.designation)

                    let storyBoard: UIStoryboard = UIStoryboard(name:"Home",bundle:nil)
                    let mainPage = storyBoard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
                    
                    Helper.setUserDefault(forkey: "isAfterLogin", valueBool: true)
                    self.present(mainPage, animated: true, completion: nil)
                }
            }
        }))
        
    }
    
    func getCurrency() {
        
        if Session.currency == "" {
            
            if internetStatus != .notReachable {
                
                let url = String.init(format: Constant.API.CURRENCY_TYPE, Session.authKey)
                self.view.showLoading()
                
                Alamofire.request(url).responseData(completionHandler: ({ response in
                    
                    self.view.hideLoading()
                    
                    if Helper.isResponseValid(vc: self, response: response.result){
                        let jsonString = JSON(response.result.value!)
                        Session.currency = jsonString.rawString()!
                        print(jsonString)
                    } else {
                        
                    }
                }))
                
            } else {
                
            }
        }
        
    }
    
    
    
    @IBAction func btnShowPasswordTapped(_ sender: Any) {
        
        if iconClick {
            editPassword.isSecureTextEntry = false
            btnShowPasswd.setImage(#imageLiteral(resourceName: "eye_show"), for: .normal)
            iconClick = false
        } else {
            editPassword.isSecureTextEntry = true
            btnShowPasswd.setImage(#imageLiteral(resourceName: "eye_hide"), for: .normal)
            iconClick = true
        }
    }
    
    func showLoading(){
        self.view.makeToastActivity(.center)
    }
    
    func hideLoading(){
        self.view.hideToastActivity()
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField {
            
        case editUsername :
            editPassword.becomeFirstResponder()
            break
            
        case editPassword :
            self.view.endEditing(true)
            //btnLogin.sendActions(for: .touchUpInside)
            break
            
        default:
            break
        }
        return true
    }
}







