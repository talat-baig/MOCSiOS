////
////  LMSAttachmentVC.swift
////  mocs
////
////  Created by Talat Baig on 1/22/19.
////  Copyright © 2019 Rv. All rights reserved.
////
//
//
//import UIKit
//import AVFoundation
//import XLPagerTabStrip
//import Floaty
//import SwiftyDropbox
//import Alamofire
//import SwiftyJSON
//import FileBrowser
//import MaterialShowcase
//
//
//
//
//class LMSAttachmentVC: UIViewController ,IndicatorInfoProvider , UIDocumentPickerDelegate {
//
//    var arrayList:[VoucherData] = []
//
//    var moduleName = String()
//
//    var lmsData = LMSReqData()
//
//    var uf_delegate:uploadFileDelegate?
//
//    var dbRequest : SwiftyDropbox.UploadRequest<Files.FileMetadataSerializer, Files.UploadErrorSerializer>?
//
//    var ucNotifyDelegate : UC_NotifyComplete?
//
//    var fileInfoObj : FileInfo?
//
//    var isFromView : Bool = false
//
//    var docFileViewer: UIDocumentInteractionController!
//
//    var imagePicker = UIImagePickerController()
//
//
//    var refreshControl: UIRefreshControl = UIRefreshControl()
//
//    @IBOutlet weak var tableView: UITableView!
//
//    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return IndicatorInfo(title: "ATTACHMENTS")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getAttachmentsData))
//
//        let floaty = Floaty()
//
//        floaty.paddingX = 15
//        floaty.paddingY = 30
//
//        floaty.friendlyTap = true
//        floaty.buttonColor = UIColor(red:37.0/255.0, green:108.0/255.0, blue:230.0/255.0, alpha:1.0)
//        floaty.plusColor = .white
//        floaty.addItem("Take Picture", icon: UIImage(named: "camera")!, handler: { item in
//
//            self.imagePicker.delegate = self
//            self.imagePicker.allowsEditing = true
//            self.imagePicker.modalTransitionStyle = .crossDissolve
//
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
//                switch authStatus {
//                case .authorized:
//                    self.showCameraPicker()
//                case .denied:
//                    self.alertPromptToAllowCameraAccessViaSettings()
//                case .notDetermined:
//                    self.permissionPrimeCameraAccess()
//                default:
//                    break
//                }
//            } else {
//                let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
//                })
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//            floaty.close()
//        })
//
//        floaty.addItem("Select File", icon: #imageLiteral(resourceName: "fileExplorer"), handler: { item in
//
//            let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.text","com.apple.iwork.pages.pages", "public.data"], in: UIDocumentPickerMode.import)
//
//            documentPicker.delegate = self
//
//            /// Set Document picker navigation bar text color
//            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : AppColor.universalHeaderColor], for: .normal)
//            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//            self.present(documentPicker, animated: true, completion: nil)
//
//            floaty.close()
//        })
//
//        floaty.addItem("Photo Library", icon:UIImage(named: "photos_library")!, handler: { item in
//
//            self.showMediaAlbum()
//            floaty.close()
//        })
//
//        self.view.addSubview(floaty)
//
//        if isFromView {
//            floaty.isHidden = true
////            self.populateList(response: vouchResponse)
//        } else {
//            floaty.isHidden = false
//
//        }
//
//        showEmptyState()
//        tableView.addSubview(refreshControl)
//
//        self.uf_delegate = self
//    }
//
//    func showEmptyState(){
//        Helper.showNoItemState(vc:self , messg: "List is Empty\nTry to load by tapping below button" , tb:tableView,  action:#selector(getAttachmentsData))
//    }
//
//
//    func getAttachmentsData() {
//
//        let docRefId = String(format: "%@D%d",self.ecrData.headRef ,self.ecrData.counter)
//
//        if internetStatus != .notReachable {
//
//            var url = String()
//
//
//                url =  String.init(format: Constant.DROPBOX.LIST,
//                                   Session.authKey,
//                                   Helper.encodeURL(url: self.moduleName),
//                                   Helper.encodeURL(url: self.ecrData.headRef))
//
//
//            self.view.showLoading()
//            Alamofire.request(url).responseData(completionHandler: ({ response in
//                self.view.hideLoading()
//                self.refreshControl.endRefreshing()
//                if Helper.isResponseValid(vc: self, response: response.result){
//                    self.populateList(response: response.result.value)
//                }
//            }))
//        } else {
//            Helper.showNoInternetMessg()
//        }
//
//    }
//}
