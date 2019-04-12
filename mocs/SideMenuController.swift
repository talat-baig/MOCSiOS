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
    
    @IBOutlet weak var lblVersionName: UILabel!
    @IBOutlet weak var stckVwHome: UIStackView!
    @IBOutlet weak var vwTreeTable: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var menuTable: UITableView!
    
    var cell = [TLACell]()
    var delegateController: TLAViewController!
    var selectedItem : MenuDataObject?
    var helpDocViewer: UIDocumentInteractionController!
    var wunderPopup = CustomPopUpView()
    
    let approvalsArr = ["1.1.1 Travel Claims Reimburstment (TCR) Form","1.1.2 Employee Claims Reimburstment (ECR) Form", "1.1.3 Travel Request Form", "1.1.4 Travel Ticket" , "1.1.5 Leave Request Form", "3.2.1 Purchase Contract (PC)","3.2.2 Sales Contract (SC)" , "3.2.3 Delivery Orders (DO)", "3.1.1 Travel Claims Reimbursement (TCR)", "3.1.2 Employee Claims & Payments (ECR EPR)" , "3.1.3 Admin Receive Invoice (ARI)", "3.2.4 Trade Received Invoice (TRI)", "3.2.5 Release Order (RO)", "3.2.6 Counterparty Profile" ,"3.1.5 Travel Request", "3.1.4 Leave Management System (LMS)" ,"Pending Approvals" ,"Employee Directory","Task Manager" , "2.1.1 Accounts Receivables (AR) Report", "2.1.2 Accounts Payable Report", "2.1.3 Available Release Report", "2.1.4 Sales Summary Report","2.1.5 Purchase Summary Report", "2.1.6 Funds Receipt and Allocation", "2.1.7 Funds Payment & Settlement","2.1.8 Employee Advances,Settlements & Reimbursements Summary", "2.1.9 Cash and Bank Balance", "2.1.10 Customer Ledger","2.1.11 Payment Ledger", "2.1.12 Bank Charges Summary" ,"2.1.13 Shipment Advise Summary", "2.1.14 Credit Limit Utilisation Summary","2.1.15 Shipment Appropriation Summary" , "2.1.16 Funds Remittance Summary", "2.1.17 Export Presentation Report","2.1.18 Employee Leave (LMS) Report"]
    
    
    var mdataObj : [MenuDataObject] = []
    var treeView : RATreeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.mdataObj = setupTreeViewData()
        setupTreeView()
        lblUserName.text = Session.user
        
        treeView.estimatedRowHeight = 55.0
        treeView.rowHeight = UITableView.automaticDimension
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        lblVersionName.text =  String(format: "Version %@",  appVersion!)
    }
    
    func setupTreeViewData() ->  [MenuDataObject] {
        
        /************************* Administrative *****************************/
        
        let tcr_form = MenuDataObject(name: "1.1.1 Travel Claims Reimburstment (TCR) Form", storybdNAme: "TravelClaim", vcName: "TravelClaimController", imageName: #imageLiteral(resourceName: "home"))
        
        let ecr_form = MenuDataObject(name: "1.1.2 Employee Claims Reimburstment (ECR) Form", storybdNAme: "EmployeeClaim", vcName: "EmployeeClaimController", imageName: #imageLiteral(resourceName: "task_tick"))
        
        let trf_form = MenuDataObject(name: "1.1.3 Travel Request Form", storybdNAme: "TravelRequest", vcName: "TravelRequestController", imageName: #imageLiteral(resourceName: "task_tick"))
        
        let trvl_tkct = MenuDataObject(name: "1.1.4 Travel Ticket", storybdNAme: "TravelTicket", vcName: "TravelTicketController", imageName: #imageLiteral(resourceName: "task_tick"))
        
        let lms_req = MenuDataObject(name: "1.1.5 Leave Request Form", storybdNAme: "LMSReq", vcName: "LMSReqController", imageName: #imageLiteral(resourceName: "task_tick"))
        
        let form = MenuDataObject(name: "1.1 Forms" , children: [tcr_form, ecr_form, trf_form, trvl_tkct,lms_req], storybdNAme: "", vcName: "", imageName: #imageLiteral(resourceName: "document"))
        
        let administrative = MenuDataObject(name: "Administrative", children: [form], storybdNAme: "", vcName: "", imageName: #imageLiteral(resourceName: "profile") )
        
        
        
        /************************* Business Reports *****************************/
        
        let arReport = MenuDataObject(name: "2.1.1 Accounts Receivables (AR) Report", storybdNAme: "ARReport", vcName: "ARReportController", imageName: #imageLiteral(resourceName: "empty"))
        
        let apReport = MenuDataObject(name: "2.1.2 Accounts Payable Report", storybdNAme: "AccountsPayable", vcName: "APReportController", imageName: #imageLiteral(resourceName: "empty"))
        
        let avlRelReport = MenuDataObject(name: "2.1.3 Available Release Report", storybdNAme: "AvblReleases", vcName: "AvlRelBaseViewController", imageName: #imageLiteral(resourceName: "empty"))
        
        let salesSummRpt = MenuDataObject(name: "2.1.4 Sales Summary Report", storybdNAme: "SalesSummary", vcName: "SalesSummaryReportController", imageName: #imageLiteral(resourceName: "empty"))
        
        let purchaseSummRpt = MenuDataObject(name: "2.1.5 Purchase Summary Report", storybdNAme: "PurchaseSummry", vcName: "PurchaseSummRptController", imageName: #imageLiteral(resourceName: "empty"))
        
        let fundsRecpt = MenuDataObject(name: "2.1.6 Funds Receipt and Allocation", storybdNAme: "FundsRecptAllocation", vcName: "FundsRcptController", imageName: #imageLiteral(resourceName: "empty"))
        
        let fundsPymnt = MenuDataObject(name: "2.1.7 Funds Payment & Settlement", storybdNAme: "FundsPayment", vcName: "FundsPaymentController", imageName: #imageLiteral(resourceName: "empty"))
        
        let ecrRept = MenuDataObject(name: "2.1.8 Employee Advances,Settlements & Reimbursements Summary", storybdNAme: "ECRReport", vcName: "ECREmployeeListController", imageName: #imageLiteral(resourceName: "empty"))
       
        let cashBnk = MenuDataObject(name: "2.1.9 Cash and Bank Balance", storybdNAme: "CashAndBalance", vcName: "CashBankBalController", imageName: #imageLiteral(resourceName: "empty"))

        let custLedger = MenuDataObject(name: "2.1.10 Customer Ledger", storybdNAme: "CustomerLedger", vcName: "CLListController", imageName: #imageLiteral(resourceName: "empty"))
        
        let pmyntLedger = MenuDataObject(name: "2.1.11 Payment Ledger", storybdNAme: "PaymentLedger", vcName: "PaymentLedgerController", imageName: #imageLiteral(resourceName: "empty"))
        
        let bnkCharges = MenuDataObject(name: "2.1.12 Bank Charges Summary", storybdNAme: "BankCharges", vcName: "BankChargesController", imageName: #imageLiteral(resourceName: "empty"))
        
        let shipmntAdvise = MenuDataObject(name: "2.1.13 Shipment Advise Summary", storybdNAme: "ShipmentAdvice", vcName: "SARefListController", imageName: #imageLiteral(resourceName: "empty"))
        
        let credUtilRpt = MenuDataObject(name: "2.1.14 Credit Limit Utilisation Summary", storybdNAme: "CreditUtilization", vcName: "CreditUtilListController", imageName: #imageLiteral(resourceName: "empty"))

        let shipmntApp = MenuDataObject(name: "2.1.15 Shipment Appropriation Summary", storybdNAme: "ShipmentAppropriation", vcName: "ShipmentAppListVC", imageName: #imageLiteral(resourceName: "empty"))
        
        let fundsRem = MenuDataObject(name: "2.1.16 Funds Remittance Summary", storybdNAme: "FundsRemittance", vcName: "FundsRemittancListVC", imageName: #imageLiteral(resourceName: "empty"))

        let expRemttnce = MenuDataObject(name: "2.1.17 Export Presentation Report", storybdNAme: "ExportPresentation", vcName: "ExportPresentationListVC", imageName: #imageLiteral(resourceName: "empty"))
        
        let lmsReprt = MenuDataObject(name: "2.1.18 Employee Leave (LMS) Report", storybdNAme: "LMSReport", vcName: "LMSReportListVC", imageName: #imageLiteral(resourceName: "empty"))

        
        let reports = MenuDataObject(name: "2.1 Reports" , children: [arReport, apReport,avlRelReport, salesSummRpt, purchaseSummRpt, fundsRecpt, fundsPymnt,ecrRept,cashBnk,custLedger,pmyntLedger,bnkCharges, shipmntAdvise,credUtilRpt,shipmntApp,fundsRem], storybdNAme: "ARReport", vcName: "", imageName: #imageLiteral(resourceName: "pie_chart"))
        
        let business = MenuDataObject(name: "Business", children: [reports], storybdNAme: "", vcName: "", imageName: #imageLiteral(resourceName: "briefcase"))
        
        /************************* Pending Approvals *****************************/
        
        let pendgApprvl = MenuDataObject(name: "Pending Approvals",children: [], storybdNAme: "PendingApproval", vcName: "PendingApprovalsController", imageName: #imageLiteral(resourceName: "pencil"))
        
        /************************* Emp Directory *****************************/
        
        let empDir = MenuDataObject(name: "Employee Directory", children: [], storybdNAme: "Employee", vcName: "EmployeeController", imageName: #imageLiteral(resourceName: "telephone"))
        
        /************************* Task Manager *****************************/
        
        let taskMngr = MenuDataObject(name: "Task Manager", children:[] , storybdNAme: "TaskManager", vcName: "TaskManagerController", imageName: #imageLiteral(resourceName: "list"))
        
        /************************* Help *****************************/
        
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
            
            if item.name == "Employee Directory" || item.name == "Task Manager" || item.name == "Help" || item.name == "Pending Approvals"{
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
        
        let level = treeView.levelForCell(forItem: item)
        
        if level == 2 {
            return UITableView.automaticDimension
        } else {
            return 60
        }
        
    }
    
    
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


extension SideMenuController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().barTintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().tintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : AppColor.universalHeaderColor]
        return self
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        helpDocViewer = nil
    }
}


