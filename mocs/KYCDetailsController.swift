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
import SwiftyDropbox
import Alamofire
import SwiftyJSON
import NotificationBannerSwift
import Floaty
import AVFoundation


protocol onCPApprove: NSObjectProtocol {
    func onOkCPClick() -> Void
}


class KYCDetailsController: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate, customPopUpDelegate , UIDocumentPickerDelegate {
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "KYC DETAILS")
    }
    
    var cpData = CPListData()
    var kycResp : Data?
    
    var myView = CustomPopUpView()
    var declView = CustomPopUpView()
    
    var moduleName = String()
    var imagePicker = UIImagePickerController()
    var delegate:uploadFileDelegate?
    var docFileViewer: UIDocumentInteractionController!
    var fileInfoObj : FileInfo?
    
    
    @IBOutlet weak var btnKYCDetails: UIButton!
    
    @IBOutlet weak var btnKYCContctType: UIButton!
    @IBOutlet weak var btnKYCRequired: UIButton!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var txtValidUntill: UITextField!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    weak var okCPApprove : onCPApprove?
    var newDate = String()
    var docUrlStr = String()
    var docFileName = String()

    @IBOutlet weak var stckVw: UIStackView!
    
    @IBOutlet weak var btnProcess: UIButton!
    @IBOutlet weak var stckVwKYCRqd: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var datePickerTool: UIView!
    @IBOutlet weak var btnSDNListChk: UIButton!
    
    @IBOutlet weak var btnAttachmnt: UIButton!
    
    var dbRequest : SwiftyDropbox.UploadRequest<Files.FileMetadataSerializer, Files.UploadErrorSerializer>?
    
    
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
        btnAttachmnt.setTitleColor( UIColor.lightGray , for: .normal)
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
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        newDate = formatter.string(from: date)
        
        parseAndAssign()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 600 )
    }
    
    
    func parseAndAssign() {
        
        var item = String()
        let jsonResponse = JSON(kycResp!)
        for(_,j):(String, SwiftyJSON.JSON) in jsonResponse {
            
            if j["KYCContactType"].stringValue == "" {
                btnKYCContctType.setTitle("Tap to Select" , for: .normal)
            } else {
                btnKYCContctType.setTitle(j["KYCContactType"].stringValue , for: .normal)
            }
            
            if j["KYCRequired"].stringValue == "" {
                btnKYCRequired.setTitle("Tap to Select" , for: .normal)
                item = "Tap to Select"
            } else {
                btnKYCRequired.setTitle(j["KYCRequired"].stringValue , for: .normal)
                item = j["KYCRequired"].stringValue
            }
            
        }
        
        enableDisableKYCBtn(item: item )
        btnAttachmnt.isEnabled = false
    }
    
    func enableDisableKYCBtn(item : String) {
        
        if item == "Yes" {
            stckVw.isHidden = false
        } else {
            stckVw.isHidden = true
        }
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
    
    func approveOrDeclineCP( event : Int, cpData:CPListData, comment:String){
        
        let kycReq = btnKYCRequired.titleLabel?.text
        let sdnList = btnSDNListChk.titleLabel?.text

        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CP.CP_APPROVE, Session.authKey,
                                  Helper.encodeURL(url: cpData.custId), event,(btnKYCContctType.titleLabel?.text)!, (btnKYCRequired.titleLabel?.text)!, cpData.refId )
            
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
                                
                                if kycReq == "Yes" && sdnList == "No" {
                                    self.approveKYCForCP(data: cpData, fileName: self.docFileName , docRefId: self.newDate, url: self.docUrlStr )
                                } else {
                                    self.showSuccessAlert()
                                }
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
    
    
    
    func showSuccessAlert() {
        
        let alert = UIAlertController(title: "Success", message: "Counterparty Successfully Approved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
            (UIAlertAction) -> Void in
            if let d = self.okCPApprove {
                d.onOkCPClick()
            }
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func approveKYCForCP(data : CPListData, fileName : String, docRefId : String, url : String) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CP.CP_KYC_APPROVE, Session.authKey,
                                  (btnKYCContctType.titleLabel?.text)!,(btnKYCRequired.titleLabel?.text)!, txtValidUntill.text!,(btnSDNListChk.titleLabel?.text)! , Helper.encodeURL(url: self.docUrlStr), 0 , cpData.refId, self.docFileName, Helper.encodeURL(url:cpData.cpName), newDate)
            
            print("kyc approve",url)
            
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
                                    self.showSuccessAlert()
                                break
                                
                            default:
                                NotificationBanner(title: data!["ServerMsg"] as! String ,style: .danger).show()
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
        
//        var commnt = ""
//        if text == "" || text == "Enter Comment" || text == "Enter Comment (Optional)" {
//            commnt = ""
//        } else {
//            commnt = text
//        }
        
        if isApprove {
            
            var newText : String = ""
            newText = text
            
            if text == "Enter Comment (Optional)" {
                newText = " "
            }
            self.approveOrDeclineCP(event: 1, cpData: data as! CPListData, comment: newText)
            myView.removeFromSuperviewWithAnimate()
        } else {
            
            if text == "" || text == "Enter Comment" {
                Helper.showMessage(message: "Please Enter Comment")
                return
            } else {
                self.approveOrDeclineCP(event: 2, cpData: data as! CPListData , comment: text)
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
                        self.view.makeToast("No KYC Details Found")
                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
        
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            
            let data = Helper.getDataFromFileUrl(fileUrl: url)
            let myView = Bundle.main.loadNibNamed("UploadFileCustomView", owner: nil, options: nil)![0] as! UploadFileCustomView
            myView.frame = (self.navigationController?.view.frame)!
            myView.data = data
            myView.extensn = url.pathExtension
            let image = Helper.getImage(ext: url.pathExtension) ?? #imageLiteral(resourceName: "file.png")
            myView.setImageToView(image: image )
            myView.uploadDelegate = self
            DispatchQueue.main.async {
                self.navigationController?.view.addSubview(myView)
            }
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
    
    
    
    @IBAction func btnAttachmntTapped(_ sender: Any) {
        
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnProcessTapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
    
        let approveAction = UIAlertAction(title: "Approve", style: .default, handler: { (UIAlertAction) -> Void in
            
            
            if self.btnKYCContctType.titleLabel?.text == "Tap to Select" {
                Helper.showMessage(message: "Enter KYC Contact Type")
                return
            }
            
            if self.btnKYCRequired.titleLabel?.text == "Tap to Select" {
                Helper.showMessage(message: "Enter KYC Required")
                return
            }
            
            if self.btnKYCRequired.titleLabel?.text == "Yes" {
                
                if self.txtValidUntill.text == "" {
                    Helper.showMessage(message: "Enter KYC Valid Until")
                    return
                }
                
                if self.btnSDNListChk.titleLabel?.text == "Tap to Select" {
                    Helper.showMessage(message: "Enter SDN List Check")
                    return
                }
            }
            
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
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    

    
    func uploadImageData( cpData : CPListData, fileInfo : FileInfo, comp : @escaping(Bool, String, String)-> ()) {

        
        let path = Helper.getModifiedPath( path: Constant.DROPBOX.DROPBOX_BASE_PATH + "/" + "frmContactManager" + "/" + cpData.cpName + "/" + Constant.MODULES.CP + "/" +  "KYC Information" + "/" + self.newDate + "/" + fileInfo.fName + "." + fileInfo.fExtension)
        
        DropboxClientsManager.authorizedClient = DropboxClient.init(accessToken: Session.dbtoken)
        dbRequest = DropboxClientsManager.authorizedClient?.files.upload(path: path, input: fileInfo.fData!)
            .response { response, error in
                
                
                DispatchQueue.main.async() {
                    if let response = response {
                        print(response.pathDisplay)
                        print(response.name)
                    
                        comp(true, response.pathDisplay ?? "" , response.name )
                        
                    } else if error != nil {
                        comp(false, (error?.description)!, "")
                        print(error?.description)
                    }
                }
            }
            .progress { progressData in
        }
    }
    
    
    @IBAction func btnKYCReqTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnKYCRequired
        dropDown.dataSource = arrKYCReq
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnKYCRequired.setTitle(item, for: .normal)
            self?.enableDisableKYCBtn(item: item)
        }
        dropDown.show()
    }
    
    
    @IBAction func btnSDNListChk(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnSDNListChk
        dropDown.dataSource = arrKYCReq
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnSDNListChk.setTitle(item, for: .normal)
            self?.btnAttachmnt.isEnabled = true
            self?.btnAttachmnt.setTitleColor( UIColor.black , for: .normal)
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



extension KYCDetailsController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  uploadFileDelegate {
    
    func uploadFile(data: Data, fileName: String, ext: String, fileDesc: String) {
        
        self.view.makeToast("Your file upload is in progress, we'll notify when uploaded")
        
        let uploadFileData = FileInfo()
        
        uploadFileData.fData = data
        uploadFileData.fName = fileName
        uploadFileData.fDesc = fileDesc
        uploadFileData.fExtension = ext
        
        self.view.showLoading()
        self.uploadImageData(cpData: cpData, fileInfo : uploadFileData ,comp: { result, str1, str2  in
            self.view.hideLoading()
            
            if result {
                Helper.showVUMessage(message: "Attachment uploaded successfully", success: true)
                self.btnAttachmnt.setTitle(str2, for: .normal)
                self.docUrlStr = str1
                self.docFileName = str2
            } else {
                self.dbRequest?.cancel()
                return
            }
        })
    }
    
    
    
    func openCamera(){
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.imagePicker.modalTransitionStyle = .crossDissolve
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .authorized:
                self.showCameraPicker()
            case .denied:
                self.alertPromptToAllowCameraAccessViaSettings()
            case .notDetermined:
                self.permissionPrimeCameraAccess()
            default:
                break
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func openGallery(){
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.text","com.apple.iwork.pages.pages", "public.data"], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        
        /// Set Document picker navigation bar text color
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : AppColor.universalHeaderColor], for: .normal)
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePicker.dismiss(animated: true, completion: { () -> Void in
            self.view.showLoading()
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                let compressData = UIImageJPEGRepresentation(image, 0.5)
                
                let myView = Bundle.main.loadNibNamed("UploadFileCustomView", owner: nil, options: nil)![0] as! UploadFileCustomView
                myView.frame = (self.navigationController?.view.frame)!
                myView.data = compressData
                myView.uploadDelegate = self
                myView.setImageToView(image: image)
                myView.extensn = "jpg"
                self.navigationController?.view.addSubview(myView)
                self.view.hideLoading()
            }
        })
    }
    
    
    func alertPromptToAllowCameraAccessViaSettings() {
        let appName =  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        
        let alert = UIAlertController(title: appName + " Would Like To Access the Camera", message: "Please grant permission to use the Camera", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { alert in
            if let appSettingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettingsURL as URL, options: [:], completionHandler: nil)
            }
        })
        
        let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
        }
        alert.addAction(declineAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func permissionPrimeCameraAccess() {
        
        let appName =  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        
        let alert = UIAlertController( title: appName + " Would Like To Access the Camera", message: "Please grant permission to use the Camera", preferredStyle: .alert )
        let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
            self.showCameraPicker()
        })
        alert.addAction(allowAction)
        let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
        }
        alert.addAction(declineAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showCameraPicker() {
        self.imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(self.imagePicker, animated: true, completion: nil)
    }
    
}

extension KYCDetailsController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().barTintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : AppColor.universalHeaderColor]
        return self.navigationController!
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        docFileViewer = nil
    }
}

