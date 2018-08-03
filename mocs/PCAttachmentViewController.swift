//
//  PCAttachmentViewController.swift
//  mocs
//
//  Created by Admin on 2/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import SwiftyDropbox

class PCAttachmentViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ATTACHMENT")
    }
    
    @IBOutlet weak var tableView: UITableView!

    var arrayList:[VoucherData] = []
    var refId:String = ""
    var moduleName:String = ""
    var docFileViewer: UIDocumentInteractionController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        tableView.register(UINib.init(nibName: "AttachmentCell", bundle: nil), forCellReuseIdentifier: "cell")
        showEmptyState()
        tableView.reloadData()
//        showEmptyState()
    }

    override func viewDidAppear(_ animated: Bool) {
        
//        tableView.register(UINib.init(nibName: "AttachmentCell", bundle: nil), forCellReuseIdentifier: "cell")
//        showEmptyState()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showEmptyState(){
        Helper.showNoItemState(vc:self ,  messg: "List is Empty\nTry to load by tapping below button" ,  tb:tableView, action:#selector(populateList))
    }

    @objc func populateList(){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.DROPBOX.LIST,
                                  Session.authKey,
                                  Helper.encodeURL(url: self.moduleName),
                                  Helper.encodeURL(url: self.refId))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let jsonResponse = JSON(response.result.value)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    if array.count > 0{
                        
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
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                        
                    }else{
                        self.view.makeToast("No attachment found")
                    }
                }
            }))
        }else{
           Helper.showNoInternetMessg()
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
                    comp(false)
                }
            }
            .progress { progressData in
                if progressData.fractionCompleted == 1.0 {
                    comp(true)
                }
        }
        
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
                self.tableView.reloadData()
                
            })
        }
    }
}
extension PCAttachmentViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayList.count > 0{
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }else{
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        }
        return arrayList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newVoucher = arrayList[indexPath.row]
        
        let cellView = tableView.dequeueReusableCell(withIdentifier: "cell") as! AttachmentCell
        cellView.title.text = newVoucher.documentName
        cellView.fileDesc.text = newVoucher.documentDesc
        cellView.btnDelete.isHidden = true
        cellView.selectionStyle = .none
        
        if !Helper.isFileExists(fileName: arrayList[indexPath.row].documentName + "." + URL(fileURLWithPath: arrayList[indexPath.row].documentPath).pathExtension)  {
            
            cellView.btnStatus.setImage(#imageLiteral(resourceName: "download"), for: .normal)
            cellView.status.text = ""
        } else {
            cellView.status.text = "Downloaded"
            cellView.btnStatus.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        }
        
        
        if newVoucher.documentDesc == "" {
            cellView.fileDesc.isHidden = true
        } else {
            cellView.fileDesc.isHidden = false
            cellView.fileDesc.text = newVoucher.documentDesc
        }
        
        
        cellView.btnStatus.tag = indexPath.row
        cellView.btnStatus.addTarget(self, action: #selector(self.fileDownloadTapped(sender:)), for: UIControlEvents.touchUpInside)
        return cellView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                self.tableView.reloadData()
                
            })
        }
        
    }
    
}

// MARK: - UIDocumentInteractionControllerDelegate method
extension PCAttachmentViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().barTintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        return self.navigationController!
        
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        docFileViewer = nil
    }
}



