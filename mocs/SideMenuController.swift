//
//  SideMenuController.swift
//  mocs
//
//  Created by Admin on 2/20/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import ThreeLevelAccordian
import Alamofire
import Toast_Swift
import RATreeView


class SideMenuController: UIViewController, TLADelegate, RATreeViewDataSource, RATreeViewDelegate {
    func didSelectItemAtIndex(_ index: Int) {
        
    }
    
    @IBOutlet weak var stckVwHome: UIStackView!
    @IBOutlet weak var vwTreeTable: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var menuTable: UITableView!
    var cell = [TLACell]()
    var delegateController: TLAViewController!
    var selectedItem : MenuDataObject?
    var helpDocViewer: UIDocumentInteractionController!
    var wunderPopup = CustomPopUpView()
    
    let approvalsArr = ["1.1.1 Travel Claims Reimburstment (TCR) Form","1.1.2 Employee Claims Reimburstment (ECR) Form", "1.1.3 Travel Request Form", "1.1.4 Travel Ticket" , "3.1.1 Purchase Contract (PC)","3.1.2 Sales Contract (SC)" , "3.1.3 Delivery Orders (DO)", "3.1.4 Travel Claims Reimbursement (TCR)", "3.1.5 Employee Claims & Payments (ECR EPR)", "3.1.6 Admin Receive Invoice (ARI)", "3.1.7 Trade Received Invoice (TRI)", "3.1.8 Release Order (RO)", "3.1.9 Counterparty Profile" , "3.1.10 Travel Request", "Employee Directory","Task Manager" , "2.2.1 Accounts Receivables (AR) Report", "2.2.2 Accounts Payable Report", "2.2.3 Available Release Report", "2.2.4 Sales Summary Report"]
    
    
    var mdataObj : [MenuDataObject] = []
    var treeView : RATreeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.mdataObj = setupTreeViewData()
        setupTreeView()
        lblUserName.text = Session.user
    }
    
    func setupTreeViewData() ->  [MenuDataObject] {
        
        let tcr_form = MenuDataObject(name: "1.1.1 Travel Claims Reimburstment (TCR) Form", storybdNAme: "TravelClaim", vcName: "TravelClaimController", imageName: #imageLiteral(resourceName: "home"))
        
        let ecr_form = MenuDataObject(name: "1.1.2 Employee Claims Reimburstment (ECR) Form", storybdNAme: "EmployeeClaim", vcName: "EmployeeClaimController", imageName: #imageLiteral(resourceName: "task_tick"))
        
        let trf_form = MenuDataObject(name: "1.1.3 Travel Request Form", storybdNAme: "TravelRequest", vcName: "TravelRequestController", imageName: #imageLiteral(resourceName: "task_tick"))

        let trvl_tkct = MenuDataObject(name: "1.1.4 Travel Ticket", storybdNAme: "TravelTicket", vcName: "TravelTicketController", imageName: #imageLiteral(resourceName: "task_tick"))

        
        let form = MenuDataObject(name: "1.1 Forms" , children: [tcr_form, ecr_form, trf_form, trvl_tkct], storybdNAme: "", vcName: "", imageName: #imageLiteral(resourceName: "document"))
        
        let administrative = MenuDataObject(name: "Administrative", children: [form], storybdNAme: "", vcName: "", imageName: #imageLiteral(resourceName: "profile") )
        
        
        let arReport = MenuDataObject(name: "2.2.1 Accounts Receivables (AR) Report", storybdNAme: "ARReport", vcName: "ARReportController", imageName: #imageLiteral(resourceName: "empty"))
        let apReport = MenuDataObject(name: "2.2.2 Accounts Payable Report", storybdNAme: "AccountsPayable", vcName: "APReportController", imageName: #imageLiteral(resourceName: "empty"))
        let avlRelReport = MenuDataObject(name: "2.2.3 Available Release Report", storybdNAme: "AvblReleases", vcName: "AvlRelBaseViewController", imageName: #imageLiteral(resourceName: "empty"))
        let salesSummRpt = MenuDataObject(name: "2.2.4 Sales Summary Report", storybdNAme: "SalesSummary", vcName: "SalesSummaryReportController", imageName: #imageLiteral(resourceName: "empty"))

        let reports = MenuDataObject(name: "2.2 Reports" , children: [arReport, apReport,avlRelReport, salesSummRpt ], storybdNAme: "ARReport", vcName: "", imageName: #imageLiteral(resourceName: "pie_chart"))
        let business = MenuDataObject(name: "Business", children: [reports], storybdNAme: "", vcName: "", imageName: #imageLiteral(resourceName: "briefcase"))
        
        let pc = MenuDataObject(name: "3.1.1 Purchase Contract (PC)", storybdNAme: "PurchaseContract", vcName: "PurchaseContractController", imageName: #imageLiteral(resourceName: "empty"))
        let sc = MenuDataObject(name: "3.1.2 Sales Contract (SC)", storybdNAme: "SalesContract", vcName: "SalesContractController", imageName: #imageLiteral(resourceName: "empty"))
//        let sc = MenuDataObject(name: "3.1.2 Sales Contract (SC)", storybdNAme: "SalesContract", vcName: "SummaryForApprovalController", imageName: #imageLiteral(resourceName: "empty"))

        let dc = MenuDataObject(name: "3.1.3 Delivery Orders (DO)", storybdNAme: "DeliveryOrder", vcName: "DeliveryOrderController", imageName: #imageLiteral(resourceName: "empty"))
        let tcr = MenuDataObject(name: "3.1.4 Travel Claims Reimbursement (TCR)", storybdNAme: "TCR", vcName: "TCRController", imageName: #imageLiteral(resourceName: "empty"))
        let ecr = MenuDataObject(name: "3.1.5 Employee Claims & Payments (ECR EPR)", storybdNAme: "EmployeePayment", vcName: "EmployeePaymentController", imageName: #imageLiteral(resourceName: "empty"))
        let ari = MenuDataObject(name: "3.1.6 Admin Receive Invoice (ARI)", storybdNAme: "AdminReceive", vcName: "AdminReceiveController", imageName: #imageLiteral(resourceName: "empty"))
        let tri = MenuDataObject(name: "3.1.7 Trade Received Invoice (TRI)", storybdNAme: "TradeInvoice", vcName: "TradeInvoiceController", imageName: #imageLiteral(resourceName: "empty"))
        let ro = MenuDataObject(name: "3.1.8 Release Order (RO)", storybdNAme: "ReleaseOrder", vcName: "ReleaseOrderController", imageName: #imageLiteral(resourceName: "empty"))

        let ca = MenuDataObject(name: "3.1.9 Counterparty Profile", storybdNAme: "CounterpartyApproval", vcName: "CounterpartyProfileController", imageName: #imageLiteral(resourceName: "empty"))
        let trf = MenuDataObject(name: "3.1.10 Travel Request", storybdNAme: "TravelReqApproval", vcName: "TravelReqApprovalVC", imageName: #imageLiteral(resourceName: "empty"))

        
        let pendgApprvl = MenuDataObject(name: "Pending Approvals", children: [pc,sc,dc,tcr,ecr,ari,tri,ro,ca,trf], storybdNAme: "", vcName: "", imageName: #imageLiteral(resourceName: "pencil"))
        
        let empDir = MenuDataObject(name: "Employee Directory", children: [], storybdNAme: "Employee", vcName: "EmployeeController", imageName: #imageLiteral(resourceName: "telephone"))
        
        let taskMngr = MenuDataObject(name: "Task Manager", children:[] , storybdNAme: "TaskManager", vcName: "TaskManagerController", imageName: #imageLiteral(resourceName: "list"))
        
        let help = MenuDataObject(name: "Help", children: [], storybdNAme: "", vcName: "", imageName: #imageLiteral(resourceName: "info"))
        
        return [administrative, business, pendgApprvl, empDir, taskMngr, help]
    }
    
    
    
    
    func setupTreeView() -> Void {
        
        treeView = RATreeView(frame: CGRect(x:0, y: 0, width: self.vwTreeTable.frame.size.width, height: self.vwTreeTable.frame.size.height - 20))
        
        treeView.register(UINib(nibName: String(describing: LevelOneCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LevelOneCell.self))
        treeView.register(UINib(nibName: String(describing: LevelZeroCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LevelZeroCell.self))
        treeView.register(UINib(nibName: String(describing: LevelTwoCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LevelTwoCell.self))
        
        treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        treeView.allowsMultipleSelection = false
        treeView.delegate = self;
        treeView.dataSource = self;
        treeView.treeFooterView = UIView()
        treeView.backgroundColor = .clear
        vwTreeTable.addSubview(treeView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func treeView(_ treeView: RATreeView, didSelectRowForItem item: Any) {
        
        let item = item as! MenuDataObject
        let level = treeView.levelForCell(forItem: item)
        var storyBoard: UIStoryboard? = nil
        var controller: UIViewController? = nil
        
        if level == 2 {
            
            
        } else if level == 0 {
            
            let cell = treeView.cell(forItem: item) as! LevelZeroCell
            let state = treeView.isCellExpanded(cell)
            self.selectedItem = item
            
            for newObj in self.mdataObj {
                
                if newObj == self.selectedItem {
                    
                    if !state {
                        newObj.isExpanded = true
                        treeView.collapseRow(forItem: newObj)
                    } else {
                        newObj.isExpanded = false
                        treeView.expandRow(forItem: newObj)
                    }
                } else {
                    
                    if newObj.isExpanded {
                        
                        newObj.isExpanded = false
                        treeView.collapseRow(forItem: newObj)
                    }
                }
                treeView.reloadRows(forItems: [newObj], with: RATreeViewRowAnimationNone)
            }
            
        } else {
            
            let cell = treeView.cell(forItem: item) as! LevelOneCell
            let state = treeView.isCellExpanded(cell)
            
            if !state {
                item.isExpanded = true
                treeView.collapseRow(forItem: item)
            } else {
                item.isExpanded = false
                treeView.expandRow(forItem: item)
            }
            
        }
        
        if approvalsArr.contains(item.name!) {
            let strybdName =  item.storybrdName
            let vcName =  item.vcName
            storyBoard = UIStoryboard(name: strybdName, bundle: nil)
            controller = storyBoard?.instantiateViewController(withIdentifier: vcName)
            
            if controller != nil {
                self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: controller!), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }
        } else if item.name == "Help" {
            self.openHelpDoc()
        }
//        else if item.name == "Task Manager" {
//            checkWunderListAppInstalled()
//        } else {
//
//        }
        
        treeView.reloadRows(forItems: [item], with: RATreeViewRowAnimationNone)
    }
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        
        let levelZero = treeView.dequeueReusableCell(withIdentifier: String(describing: LevelZeroCell.self)) as! LevelZeroCell
        let levelOne = treeView.dequeueReusableCell(withIdentifier: String(describing: LevelOneCell.self)) as! LevelOneCell
        let levelTwo = treeView.dequeueReusableCell(withIdentifier: String(describing: LevelTwoCell.self)) as! LevelTwoCell
        
        let item = item as! MenuDataObject
        let level = treeView.levelForCell(forItem: item)
        
        if level == 0 {
            
            levelZero.selectionStyle = .none
            levelZero.setupCellViews(title: item.name!, image: item.imageName)
            treeView.separatorStyle = RATreeViewCellSeparatorStyleNone
            
            if (item.isExpanded) {
                levelZero.imgArrow.image = #imageLiteral(resourceName: "downarrow")
            } else {
                levelZero.imgArrow.image = #imageLiteral(resourceName: "rightarrow")
            }
            
            if item.name == "Employee Directory" || item.name == "Task Manager" || item.name == "Help" {
                levelZero.imgArrow.image = #imageLiteral(resourceName: "empty")
            }
            
            return levelZero
        } else if level == 1 {
            
            levelOne.selectionStyle = .none
            treeView.separatorStyle = RATreeViewCellSeparatorStyleNone
            levelOne.setupCellViews(title: item.name!, image: item.imageName)
            
            if (item.children?.count == 0)  {
                levelOne.imgArrow.image = #imageLiteral(resourceName: "empty")
                levelOne.lblTitle.textColor = UIColor.black
                levelOne.seperatorVw.isHidden = false
            } else if (item.isExpanded) {
                levelOne.imgArrow.image = #imageLiteral(resourceName: "downarrow")
                levelOne.lblTitle.textColor = AppColor.sideMenuGreen
                levelOne.seperatorVw.isHidden = true
            } else {
                levelOne.imgArrow.image = #imageLiteral(resourceName: "rightarrow")
                levelOne.lblTitle.textColor = AppColor.sideMenuGreen
                levelOne.seperatorVw.isHidden = true
            }
            
            return levelOne
        } else {
            
           
            levelTwo.selectionStyle = .none
            levelTwo.setupCellViews(title: item.name!)
            return levelTwo
        }
    }
    
    //MARK: RATreeView data source
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? MenuDataObject {
            return (item.children?.count)!
        } else {
            return self.mdataObj.count
        }
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? MenuDataObject {
            return item.children![index]
        } else {
            return mdataObj[index] as AnyObject
        }
    }
    
    func treeView(_ treeView: RATreeView, heightForRowForItem item: Any) -> CGFloat {
        
        let item = item as! MenuDataObject
        
        let width = item.name?.count
        
        if width! >= 42 {
//            print("93")
            return 93
        } else if width == 38 {
//            print("75")
            return 75
        } else {
//            print("60")
            return 60
        }
    }
    
//    func schemeAvailable(scheme: String) -> Bool {
//        if let url = URL(string: scheme) {
//            return UIApplication.shared.canOpenURL(url)
//        }
//        return false
//    }
//
//    func open(scheme: String) {
//        if let url = URL(string: scheme) {
//            UIApplication.shared.open(url, options: [:], completionHandler: {
//                (success) in
//                print("Open \(scheme): \(success)")
//            })
//        }
//    }
//
//    func openInstallAppPopup() {
//
//        self.wunderPopup = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
//        self.wunderPopup.setDataToCustomView(title: "Wunderlist App Not Found", description: "Download it from App Store", leftButton: "NO", rightButton: "YES", isTxtVwHidden: true, isApprove: false, isFromSideMenu: true)
//        self.wunderPopup.wunderDelegate = self
//        self.wunderPopup.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        self.view.window?.addSubview(self.wunderPopup)
//    }
//
//    func checkWunderListAppInstalled() {
//
//        let wunderList = schemeAvailable(scheme: "wunderlist://")
//
//        if wunderList {
//            open(scheme: "wunderlist://")
//        } else {
//            self.openInstallAppPopup()
//        }
//    }
//
//
    func downloadFile(destinationUrl : URL) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (destinationUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        self.view.makeToast("Please wait while downloading...")
        Alamofire.download(Constant.HelpDoc.LINK, to: destination)
            .response (completionHandler : { (response) in
                
                if response.error == nil {
                    self.openFile(urlPath: destinationUrl)
                } else {
                    Helper.showMessage(message: "Failed to Download PDF. Check your internet Connection")
                }
            })
    }
    
    
    func openFile( urlPath : URL) {
        self.helpDocViewer = UIDocumentInteractionController.init(url: urlPath)
        self.helpDocViewer.delegate = self
        self.helpDocViewer.name = "Help"
        self.helpDocViewer.presentPreview(animated: true)
    }
    
    func openHelpDoc() {
        let newPath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newUrl = newPath.appendingPathComponent("mOCSHelp_iOS.pdf")
        
        if Helper.isFileExists(fileName: "mOCSHelp_iOS.pdf") {
            self.openFile(urlPath: newUrl)
        } else {
            self.downloadFile(destinationUrl: newUrl)
        }
    }
    
    
    @IBAction func home_click(_ sender: UIButton) {
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "homeViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func logout_click(_ sender: Any) {
        Helper.clearSession()
        
        if FilterViewController.selectedDataObj.count != 0 {
            FilterViewController.selectedDataObj.removeAll()
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        let mainPage: UIViewController = storyBoard.instantiateViewController(withIdentifier: "loginController")
        self.present(mainPage, animated: false, completion: nil)
    }
    
}

//extension SideMenuController: wunderlistPopupDelegate {
//
//    func onRightBtnTap() {
//        let urlStr = "itms://itunes.apple.com/in/app/wunderlist-to-do-list-tasks/id406644151?mt=8"
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(URL(string: urlStr)!)
//        }
//        self.wunderPopup.removeFromSuperviewWithAnimate()
//    }
//
//}

extension SideMenuController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().barTintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().tintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : AppColor.universalHeaderColor]
        return self
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        helpDocViewer = nil
    }
}

