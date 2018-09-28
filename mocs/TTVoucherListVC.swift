//
//  TTVoucherListVC.swift
//  mocs
//
//  Created by Talat Baig on 9/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Floaty
import SwiftyDropbox
import Alamofire
import SwiftyJSON
import FileBrowser
import MaterialShowcase

class TTVoucherListVC: UIViewController, IndicatorInfoProvider {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "VOUCHERS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        tableView.register(UINib.init(nibName: "AttachmentCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension TTVoucherListVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func uploadFile(data: Data, fileName: String, ext: String, fileDesc: String) {
        
//        self.view.makeToast("Your file upload is in progress, we'll notify when uploaded")
//
//        let uploadFileData = FileInfo()
//
//        uploadFileData.fData = data
//        uploadFileData.fName = fileName
//        uploadFileData.fDesc = fileDesc
//        uploadFileData.fExtension = ext
//
//        GlobalVariables.shared.uploadQueue.append(uploadFileData)
//
//        self.addRowWithCell(fileInfo : uploadFileData)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if arrayList.count > 0{
//            tableView.backgroundView?.isHidden = true
//            tableView.separatorStyle = .singleLine
//        } else {
//            tableView.backgroundView?.isHidden = false
//            tableView.separatorStyle = .none
//        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let newVoucher = arrayList[indexPath.row]
        
        let cellView = tableView.dequeueReusableCell(withIdentifier: "cell") as! AttachmentCell
//        cellView.title.text = newVoucher.documentName
        cellView.selectionStyle = .none
//
//        if newVoucher.documentDesc == "" {
//            cellView.fileDesc.isHidden = true
//        } else {
//            cellView.fileDesc.isHidden = false
//            cellView.fileDesc.text = newVoucher.documentDesc
//        }
//
//
//        if newVoucher.isFileUploading {
//            cellView.progressBar.isHidden = false
//            cellView.progressBar.progress = 0.0
//
//            cellView.btnDelete.isHidden = true
//            cellView.contentView.backgroundColor = AppColor.univVoucherCell
//
//        } else {
//            cellView.progressBar.isHidden = true
//            cellView.contentView.backgroundColor = UIColor.clear
//
//
//            if isFromView {
//                cellView.btnDelete.isHidden = true
//            } else {
//                cellView.btnDelete.isHidden = false
//            }
//        }
//
//        if !Helper.isFileExists(fileName: arrayList[indexPath.row].documentName + "." + URL(fileURLWithPath: arrayList[indexPath.row].documentPath).pathExtension)  {
//            cellView.btnStatus.setImage(#imageLiteral(resourceName: "download"), for: .normal)
//            cellView.status.text = "(Tap to Download)"
//        } else {
//            cellView.status.text = "Downloaded.(Tap to View)"
//            cellView.btnStatus.setImage(#imageLiteral(resourceName: "view"), for: .normal)
//        }
//
//
        cellView.btnStatus.tag = indexPath.row
        cellView.btnDelete.tag = indexPath.row
        
//        cellView.btnDelete.addTarget(self, action: #selector(self.deleteFileTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        return cellView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if GlobalVariables.shared.isUploadingSomething {
//            self.view.makeToast("File uploading is in progress, Please wait..")
//            return
//        }
        
//        if Helper.isFileExists(fileName: arrayList[indexPath.row].documentName + "." + URL(fileURLWithPath: arrayList[indexPath.row].documentPath).pathExtension) {
//
//            let path = Helper.getPathFromDirectory(directoryName: "", savedFileName: arrayList[indexPath.row].documentName, ext: URL(fileURLWithPath: arrayList[indexPath.row].documentPath).pathExtension)
//            self.docFileViewer = UIDocumentInteractionController.init(url: path)
//
//            /// Configure Document Interaction Controller
//            self.docFileViewer.delegate = self
//            self.docFileViewer.name = ""
//            self.docFileViewer.presentPreview(animated: true)
//
//        } else {
//
//            Helper.showLoading(vc: self)
//            self.downloadFile(path: arrayList[indexPath.row].documentPath, fileName : arrayList[indexPath.row].documentName, comp: { result in
//                Helper.hideLoading(vc: self)
//                if result {
//                } else {
//                    Helper.showMessage(message: "Sorry! Unable to download file")
//                }
//                self.tableView.reloadData()
//
//            })
//        }
//
    }
    
}
