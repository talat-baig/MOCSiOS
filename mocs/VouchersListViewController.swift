//
//  VouchersListViewController.swift
//  mocs
//
//  Created by Talat Baig on 3/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import AVFoundation
import XLPagerTabStrip
import Floaty
import SwiftyDropbox
import Alamofire
import SwiftyJSON
import FileBrowser

protocol UC_NotifyComplete {
    func notifyUCVouchers(messg : String, success : Bool) -> Void
}

class VouchersListViewController: UIViewController, IndicatorInfoProvider , UIDocumentPickerDelegate {
    
    var arrayList:[VoucherData] = []
    var tcrData = TravelClaimData()
    /// -- ECR Data
    //    var ecrData = ECRClaimData()
    var moduleName = String()
    var imagePicker = UIImagePickerController()
    var delegate:uploadFileDelegate?
    var docFileViewer: UIDocumentInteractionController!
    var isFromView : Bool = false
    var vouchResponse : Data?
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var fileInfoObj : FileInfo?
    var dbRequest : SwiftyDropbox.UploadRequest<Files.FileMetadataSerializer, Files.UploadErrorSerializer>?
    var ucNotifyDelegate : UC_NotifyComplete?
    
    @IBOutlet weak var tblVwVouchers: UITableView!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "VOUCHERS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getVouchersData))
        
        let floaty = Floaty()
        
        floaty.paddingX = 15
        floaty.paddingY = 30
        
        floaty.friendlyTap = true
        floaty.buttonColor = UIColor(red:37.0/255.0, green:108.0/255.0, blue:230.0/255.0, alpha:1.0)
        floaty.plusColor = .white
        floaty.addItem("Take Picture", icon: UIImage(named: "camera")!, handler: { item in
            
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
            floaty.close()
        })
        
      
        
        floaty.addItem("Select File", icon: #imageLiteral(resourceName: "fileExplorer"), handler: { item in
            let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.text","com.apple.iwork.pages.pages", "public.data"], in: UIDocumentPickerMode.import)
            documentPicker.delegate = self
            
            /// Set Document picker navigation bar text color
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : AppColor.universalHeaderColor], for: .normal)
            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(documentPicker, animated: true, completion: nil)
            
            floaty.close()
        })
        
        
        floaty.addItem("Photo Library", icon:UIImage(named: "photos_library")!, handler: { item in
        
            self.showMediaAlbum()
            floaty.close()
        })
        
        self.view.addSubview(floaty)
        
        if isFromView {
            floaty.isHidden = true
            self.populateList(response: vouchResponse)
        } else {
            floaty.isHidden = false
            showEmptyState()
            tblVwVouchers.addSubview(refreshControl)
        }
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tblVwVouchers.register(UINib.init(nibName: "AttachmentCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    
    func showMediaAlbum() {
        self.imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            
            let data = Helper.getDataFromFileUrl(fileUrl: url)
            let myView = Bundle.main.loadNibNamed("UploadFileCustomView", owner: nil, options: nil)![0] as! UploadFileCustomView
            myView.frame = (self.navigationController?.view.frame)!
            myView.data = data
            myView.extensn = url.pathExtension
            let image = Helper.getImage(ext: url.pathExtension) ?? #imageLiteral(resourceName: "file.png")
            myView.setImageToView(image: image , docArray: self.arrayList)
            myView.uploadDelegate = self
            DispatchQueue.main.async {
                self.navigationController?.view.addSubview(myView)
            }
        }
    }
    
   
    func getDataFromFile(file : FBFile) -> Data? {
        
        var pData = Data()
        do {
            let fileData = try Data.init(contentsOf: file.filePath)
            pData = fileData
        } catch {
        }
        return pData
        
    }
    
    func showEmptyState(){
        Helper.showNoItemState(vc:self , messg: "List is Empty\nTry to load by tapping below button" , tb:tblVwVouchers,  action:#selector(getVouchersData))
    }
    
    func uploadImageData( fileInfo : FileInfo, comp : @escaping(Bool, String)-> ()) {
        
        GlobalVariables.shared.isUploadingSomething = true
        
        let docRefId = String(format: "%@D%d",self.tcrData.headRef ,self.tcrData.counter)
        
        let path = Helper.getModifiedPath( path: Constant.DROPBOX.DROPBOX_BASE_PATH + "/" + Constant.MODULES.TCR + "/" + Session.company + "/" + Session.location + "/"  + Session.user + "/" + docRefId + "/" + fileInfo.fName + "." + fileInfo.fExtension)
        
        DropboxClientsManager.authorizedClient = DropboxClient.init(accessToken: Session.dbtoken)
        dbRequest = DropboxClientsManager.authorizedClient?.files.upload(path: path, input: fileInfo.fData!)
            .response { response, error in
              
                DispatchQueue.main.async() {
                    if let response = response {
                        self.addItemToServer(dModName: Constant.MODULES.TCR, company: Session.company, location: Session.location, bUnit: Session.user, docRefId: docRefId, docName: fileInfo.fName, docDesc: fileInfo.fDesc, docFilePath: Helper.getOCSFriendlyaPath(path: response.pathDisplay!), compHandler: { result in
                            
                            comp(result, "")
                        })
                    } else if error != nil {
                        comp(false, (error?.description)!)
                    }
                }
            }
            .progress { progressData in
                
                self.updateCellProgressvalue(selectedIndexPath: fileInfo.notifInfo.notifIdentifier, withProgress: Float(progressData.fractionCompleted))
        }
    }
    
    
    func downloadFile( path : String, fileName : String, comp : @escaping(Bool) -> ()) {
        let path = Helper.getModifiedPath( path:  path)
        
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destURL = directoryURL.appendingPathComponent(fileName + "." + URL(fileURLWithPath: path).pathExtension)
        
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destURL
        }
        
        DropboxClientsManager.authorizedClient = DropboxClient.init(accessToken: Session.dbtoken)
        DropboxClientsManager.authorizedClient?.files.download(path: path, overwrite: true,destination: destination)
            .response { response, error in
                if let response = response {
                    comp(true)
                } else if let error = error {
                    print(error)
                    comp(false)
                }
            }
            .progress { progressData in
                if progressData.fractionCompleted == 1.0 {
                    comp(true)
                }
        }
        
    }
    
    
    func updateCellProgressvalue(selectedIndexPath: IndexPath, withProgress: Float) {
        
        if let cell = self.tblVwVouchers.cellForRow(at: selectedIndexPath) as?  AttachmentCell {
            
            cell.updateProgressAtindexpath(indexPath: selectedIndexPath, progress: withProgress)
        }
    }
    
    
    func addItemToServer(dModName : String, company: String, location: String, bUnit : String, docRefId : String, docName: String, docDesc : String, docFilePath : String, compHandler : @escaping(Bool)->()) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.DROPBOX.ADD_ITEM,
                                  Session.authKey,Helper.encodeURL(url: dModName), Helper.encodeURL(url: company), Helper.encodeURL(url:location),Helper.encodeURL(url: bUnit), docRefId,
                                  Helper.encodeURL(url: docName),
                                  Helper.encodeURL(url: docDesc), Helper.encodeURL(url:docFilePath))
            Alamofire.request(url).responseData(completionHandler: ({ response in
                
                if Helper.isResponseValid(vc: self, response: response.result) {
                    compHandler(true)
                } else {
                    compHandler(false)
                }
            }))
        } else {
            compHandler(false)
            Helper.showNoInternetMessg()
        }
        
    }
    
    
    
    @objc func deleteFileTapped(sender:UIButton) {
        
        let buttonRow = sender.tag
        
        if GlobalVariables.shared.isUploadingSomething {
            self.view.makeToast("File uploading is in progress, Please wait..")
            return
        }
        
        let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete the voucher?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            
            self.deleteItemFromServer(docId: self.arrayList[buttonRow].documentID, comp: { (result) in
                if result {
                    self.arrayList.remove(at: buttonRow)
                    self.tblVwVouchers.reloadData()
                    if self.arrayList.count == 0 {
                        self.showEmptyState()
                    }
                } else {
                    Helper.showMessage(message: "No Internet Available, Please check your connection")
                }
            })
        })
        
        let cancel = UIAlertAction(title: "GO BACK", style: .destructive, handler: { (action) -> Void in })
        
        deleteAlert.addAction(cancel)
        deleteAlert.addAction(yesAction)
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc func fileDownloadTapped(sender:UIButton) {
        
        let buttonRow = sender.tag
        
        if Helper.isFileExists(fileName: arrayList[buttonRow].documentName + "." + URL(fileURLWithPath: arrayList[buttonRow].documentPath).pathExtension) {
            
            let path = Helper.getPathFromDirectory(directoryName: "", savedFileName: arrayList[buttonRow].documentName, ext: URL(fileURLWithPath: arrayList[buttonRow].documentPath).pathExtension)
            self.docFileViewer = UIDocumentInteractionController.init(url: path)
            
            /// Configure Document Interaction Controller
            self.docFileViewer.delegate = self
            self.docFileViewer.name = ""
            self.docFileViewer.presentPreview(animated: true)
            
        } else {
            Helper.showLoading(vc: self)
            self.downloadFile(path: arrayList[buttonRow].documentPath, fileName : arrayList[buttonRow].documentName, comp: { result in
                Helper.hideLoading(vc: self)
                if result {
                } else {
                    Helper.showMessage(message: "Sorry! Unable to download file")
                }
                self.tblVwVouchers.reloadData()
                
            })
        }
    }
    
    func deleteItemFromServer(docId : String, comp : @escaping(Bool) -> ()){
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.DROPBOX.REMOVE_ITEM,
                                  Session.authKey,docId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    self.view.makeToast("File Deleted")
                    comp(true)
                }
            }))
        } else {
            comp(false)
            Helper.showNoInternetMessg()
        }
        
    }
    
    @objc func getVouchersData() {
        
        let docRefId = String(format: "%@D%d",self.tcrData.headRef ,self.tcrData.counter)
        
        if internetStatus != .notReachable {
            
            var url = String()
            
            if(tcrData.headStatus.caseInsensitiveCompare("draft") == ComparisonResult.orderedSame) {
                url =  String.init(format: Constant.DROPBOX.LIST,
                                   Session.authKey,
                                   Helper.encodeURL(url: self.moduleName),
                                   Helper.encodeURL(url: docRefId))
            } else {
                url =  String.init(format: Constant.DROPBOX.LIST,
                                   Session.authKey,
                                   Helper.encodeURL(url: self.moduleName),
                                   Helper.encodeURL(url: self.tcrData.headRef))
                
            }
            
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    self.populateList(response: response.result.value)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    @objc func populateList(response : Data?) {
        
        //        self.tblVwVouchers.tableFooterView = nil
        guard response != nil else {
            return
        }
        
        let jsonResponse = JSON(response)
        
        if jsonResponse.arrayObject == nil {
            Helper.showNoItemState(vc:self , messg: "List is Empty\nNo attachment found" , tb:tblVwVouchers)
            return
        }
        
        let array = jsonResponse.arrayObject as! [[String:AnyObject]]
        
        
        if array.count > 0 {
            
            self.arrayList.removeAll()
            
            for(_,j):(String,SwiftyJSON.JSON) in jsonResponse{
                let data = VoucherData()
                data.documentID = j["DocumentID"].stringValue
                data.moduleName = j["DocumentModuleName"].stringValue
                data.companyName = j["DocumentCompanyName"].stringValue
                data.location = j["DocumentLocation"].stringValue
                data.businessUnit = j["DocumentBusinessUnit"].stringValue
                data.documentName = j["DocumentName"].stringValue
                data.documentDesc = j["DocumentDescription"].stringValue
                data.documentPath = j["DocumentPhysicalPath"].stringValue
                data.documentCategory = j["DocumentCategory"].stringValue
                data.documentType = j["DocumentType"].stringValue
                data.addDate = j["AddedByUser"].stringValue
                data.addedUser = j["AddedDate"].stringValue
                self.arrayList.append(data)
              
            }
            self.tblVwVouchers.tableFooterView = nil
            self.tblVwVouchers.reloadData()
            
        } else {
            
            if isFromView {
                Helper.showNoItemState(vc:self , messg: "List is Empty\nNo attachment found" , tb:tblVwVouchers)
            } else {
                self.view.makeToast("No attachment found")
            }
        }
    }
    
    
    func addRowWithCell(fileInfo : FileInfo) {
        
        let newVoucherData = VoucherData()
        
        newVoucherData.documentName = fileInfo.fName
        newVoucherData.documentDesc = fileInfo.fDesc
        newVoucherData.isFileDownloaded = false
        newVoucherData.isFileUploading = true
        
        self.arrayList.append(newVoucherData)
        
        let indx = self.arrayList.endIndex
        
        let newFileInfo = FileInfo()
        newFileInfo.fData = fileInfo.fData
        newFileInfo.fName = fileInfo.fName
        newFileInfo.fDesc = fileInfo.fDesc
        newFileInfo.fExtension = fileInfo.fExtension
        newFileInfo.fUploadState = fileInfo.fUploadState
        newFileInfo.notifInfo.notifIdentifier = IndexPath(row:indx - 1, section: 0)
        newFileInfo.notifInfo.notifName = "UploadVoucher"
        
        let fIndx = GlobalVariables.shared.uploadQueue.index(where: {$0.fName == fileInfo.fName})
        GlobalVariables.shared.uploadQueue[fIndx!] = newFileInfo
        //---
        for new in GlobalVariables.shared.uploadQueue {
            debugPrint(new.fName)
            debugPrint(new.notifInfo.notifName)
        }
        
        ///
        self.tblVwVouchers.tableFooterView = nil
        self.tblVwVouchers.reloadData()
        self.uploadFilesFromQueue()
        
    }
    

    
    func uploadFilesFromQueue() {
        
        if GlobalVariables.shared.isUploadingSomething {
            return
        }
        
        let newFile = GlobalVariables.shared.uploadQueue.filter({ $0.fUploadState == false }).first
        
        self.fileInfoObj = newFile
        
        guard let newUpload = newFile else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.uploadImageData(fileInfo : newUpload ,comp: { result,errmessg  in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            GlobalVariables.shared.isUploadingSomething = false
            GlobalVariables.shared.uploadQueue.filter({ $0.fUploadState == false }).first?.fUploadState = true
            
            self.uploadFilesFromQueue()
            
            if result {
                
            } else {
                
                if let d = self.ucNotifyDelegate {
                    
                    if errmessg.debugDescription.contains("conflict") {
                        d.notifyUCVouchers(messg: "Unable to Upload. File with this name already exists. Please enter different name.", success: false)
                    } else {
                        d.notifyUCVouchers(messg: "Sorry! Unable to Upload Voucher. Please try Again", success: false)
                    }
                    self.getVouchersData()
                }
                self.dbRequest?.cancel()
                return
            }
            
            let allUploadedFiles = GlobalVariables.shared.uploadQueue.filter({ $0.fUploadState == true })
            
            if allUploadedFiles.count == GlobalVariables.shared.uploadQueue.count {
                
                if allUploadedFiles.count > 1 {
                    if let d = self.ucNotifyDelegate {
                        d.notifyUCVouchers(messg: "Vouchers uploaded successfully", success: true)
                    }
                } else {
                    if let d = self.ucNotifyDelegate {
                        d.notifyUCVouchers(messg: "Voucher uploaded successfully", success:  true)
                    }
                }
                
                GlobalVariables.shared.uploadQueue.removeAll()
                self.getVouchersData()
            }
            
            
        })
        
    }
}

extension VouchersListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePicker.dismiss(animated: true, completion: { () -> Void in
            self.view.showLoading()
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

                let compressData = UIImageJPEGRepresentation(image, 0.5) //max value is 1.0 and minimum is 0.0
                
                let myView = Bundle.main.loadNibNamed("UploadFileCustomView", owner: nil, options: nil)![0] as! UploadFileCustomView
                myView.frame = (self.navigationController?.view.frame)!
                myView.data = compressData
                myView.uploadDelegate = self
                myView.setImageToView(image: image, docArray: self.arrayList)
                myView.extensn = "jpg"
                self.navigationController?.view.addSubview(myView)
                self.view.hideLoading()
            }
        })
    }
}

extension VouchersListViewController: UITableViewDataSource, UITableViewDelegate, uploadFileDelegate {
    
    func uploadFile(data: Data, fileName: String, ext: String, fileDesc: String) {
        
        self.view.makeToast("Your file upload is in progress, we'll notify when uploaded")
        
        let uploadFileData = FileInfo()
        
        uploadFileData.fData = data
        uploadFileData.fName = fileName
        uploadFileData.fDesc = fileDesc
        uploadFileData.fExtension = ext
        
        GlobalVariables.shared.uploadQueue.append(uploadFileData)
        
        self.addRowWithCell(fileInfo : uploadFileData)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrayList.count > 0{
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newVoucher = arrayList[indexPath.row]
        
        let cellView = tableView.dequeueReusableCell(withIdentifier: "cell") as! AttachmentCell
        cellView.title.text = newVoucher.documentName
        
        
        if newVoucher.documentDesc == "" {
            
            cellView.fileDesc.isHidden = true
        } else {
            cellView.fileDesc.isHidden = false
            cellView.fileDesc.text = newVoucher.documentDesc
        }
        
        cellView.selectionStyle = .none
        
        if newVoucher.isFileUploading {
            cellView.progressBar.isHidden = false
            cellView.progressBar.progress = 0.0
            //            cellView.selectionStyle = .none
            cellView.btnDelete.isHidden = true
            cellView.contentView.backgroundColor = AppColor.univVoucherCell
            
        } else {
            cellView.progressBar.isHidden = true
            cellView.contentView.backgroundColor = UIColor.clear
            
            
            if isFromView {
                cellView.btnDelete.isHidden = true
            } else {
                cellView.btnDelete.isHidden = false
            }
        }
        
        if !Helper.isFileExists(fileName: arrayList[indexPath.row].documentName + "." + URL(fileURLWithPath: arrayList[indexPath.row].documentPath).pathExtension)  {
            cellView.btnStatus.setImage(#imageLiteral(resourceName: "download"), for: .normal)
            cellView.status.text = "(Tap to Download)"
        } else {
            cellView.status.text = "Downloaded.(Tap to View)"
            cellView.btnStatus.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        }
        
        
        cellView.btnStatus.tag = indexPath.row
        cellView.btnDelete.tag = indexPath.row
        
        cellView.btnDelete.addTarget(self, action: #selector(self.deleteFileTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        return cellView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if GlobalVariables.shared.isUploadingSomething {
            self.view.makeToast("File uploading is in progress, Please wait..")
            return
        }
        
        if Helper.isFileExists(fileName: arrayList[indexPath.row].documentName + "." + URL(fileURLWithPath: arrayList[indexPath.row].documentPath).pathExtension) {
            
            let path = Helper.getPathFromDirectory(directoryName: "", savedFileName: arrayList[indexPath.row].documentName, ext: URL(fileURLWithPath: arrayList[indexPath.row].documentPath).pathExtension)
            self.docFileViewer = UIDocumentInteractionController.init(url: path)
            
            /// Configure Document Interaction Controller
            self.docFileViewer.delegate = self
            self.docFileViewer.name = ""
            self.docFileViewer.presentPreview(animated: true)
            
        } else {
            
            Helper.showLoading(vc: self)
            self.downloadFile(path: arrayList[indexPath.row].documentPath, fileName : arrayList[indexPath.row].documentName, comp: { result in
                Helper.hideLoading(vc: self)
                if result {
                } else {
                    Helper.showMessage(message: "Sorry! Unable to download file")
                }
                self.tblVwVouchers.reloadData()
                
            })
        }
        
    }
    
}

// MARK: - UIDocumentInteractionControllerDelegate method
extension VouchersListViewController: UIDocumentInteractionControllerDelegate {
    
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





