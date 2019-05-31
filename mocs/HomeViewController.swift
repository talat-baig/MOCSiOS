//
//  HomeViewController.swift
//  mocs
//
//  Created by Admin on 2/20/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MaterialShowcase

class HomeViewController: UIViewController , filterViewDelegate , customPopUpDelegate {
    
    var arrayNews = NewsData()
    
    var myView = CustomPopUpView()
    
    var arrMenuTitle = [["Administrative","All Forms are found here"],["Business","All Reports are found here"],["Pending Approvals","All Approvals are found here"],["Task Manager","All Task to be managed here"], ["Employee Directory","All Employee Data is found here"], ["Help","Find the oveview of the application here"]]
    
    var arrMenuIcons = ["admin","briefcase","pencil","list","telephone", "info"]
    
    var arrSubMenuTitle = [["Travel Claim Reimbursement (TCR) Form","Employee Claims Reimburstment (ECR) Form","Travel Request Form","Travel Ticket" , "Leave Request Form"], ["Accounts Receivables (AR) Report", "Accounts Payable Report", "Available Release Report", "Sales Summary Report","Purchase Summary Report", "Funds Receipt and Allocation", "Funds Payment & Settlement","Employee Advances,Settlements & Reimbursements Summary", "Cash and Bank Balance", "Customer Ledger","Payment Ledger", "Bank Charges Summary" ,"Shipment Advise Summary", "Credit Limit Utilisation Summary","Shipment Appropriation Summary" , "Funds Remittance Summary", "Export Presentation Report","Employee Leave (LMS) Report"]]
    
    var helpDocViewer: UIDocumentInteractionController!
    
    //    var filterTransactionManger = TransitionManager()
    
    var listArray:[NewsData] = []
    
    lazy var refreshController = UIRefreshControl()
    
    @IBOutlet weak var collVwNews: UICollectionView!
    
    @IBOutlet weak var lblVersion: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var collVwMenus: UICollectionView!
    
    @IBOutlet weak var barBtnFilter: UIBarButtonItem!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var collVwHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mySubVw: UIView!
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        refreshController = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        self.collVwNews.addSubview(refreshController)
        FilterViewController.filterDelegate = self
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
        collVwNews.backgroundView = activityIndicatorView
        
        self.initialSetup()
        
        if Session.news == "" {
            populateList()
        } else {
            parseAndAssign(response: Session.news)
        }
    }
    
    
    func initialSetup() {
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "OCS-Home"
        vwTopHeader.lblSubTitle.isHidden = true
        
        
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        collVwNews.register(UINib.init(nibName: "NewsCollVwCell", bundle: nil), forCellWithReuseIdentifier: "newscell")
        collVwMenus.register(UINib.init(nibName: "HomeMenuCell", bundle: nil), forCellWithReuseIdentifier: "menuscell")
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collVwNews.collectionViewLayout = flowLayout
        collVwNews.showsHorizontalScrollIndicator = false
        
        let flowLayoutMenu = UICollectionViewFlowLayout()
        flowLayoutMenu.scrollDirection = UICollectionView.ScrollDirection.vertical
        collVwMenus.collectionViewLayout = flowLayoutMenu
        collVwMenus.showsVerticalScrollIndicator = false
        collVwMenus.reloadData()
        
        lblUserName.text = Session.user
        
        lblVersion.text =  String(format: "v%@",  Helper.getAppVersion())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if Helper.getUserDefaultForBool(forkey: "isAfterLogin") == true {
            self.showCaseFilter()
            Helper.setUserDefault(forkey: "isAfterLogin", valueBool: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showCaseFilter() {
        
        let showcase = MaterialShowcase()
        showcase.setTargetView(barButtonItem: barBtnFilter)
        showcase.targetTintColor = UIColor.red
        showcase.targetHolderRadius = 50
        showcase.targetHolderColor = UIColor.white
        showcase.aniComeInDuration = 0.3
        showcase.aniRippleColor = UIColor.white
        showcase.aniRippleAlpha = 0.2
        showcase.primaryText = "FILTER"
        showcase.secondaryText = "You can change/select Filters by tapping on this icon"
        showcase.primaryTextSize = 21
        showcase.secondaryTextSize = 18
        showcase.secondaryTextColor = UIColor.white.withAlphaComponent(0.8)
        showcase.isTapRecognizerForTargetView = false
        // Delegate to handle other action after showcase is dismissed.
        showcase.delegate = self
        showcase.show(completion: {
            // You can save showcase state here
            debugPrint("complete bar button action")
        })
        
    }
    
    @objc func openSubMenu(index : Int) {
        
        let subMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "SubMenuViewController") as! SubMenuViewController
        subMenuVC.arrMenuTitles = arrSubMenuTitle[index]
        subMenuVC.navHeader = arrMenuTitle[index].first ?? ""
        subMenuVC.isFilter = index == 0 ? false : true
        self.navigationController?.pushViewController(subMenuVC, animated: true)
    }
    
    func openFile( urlPath : URL) {
        self.helpDocViewer = UIDocumentInteractionController.init(url: urlPath)
        self.helpDocViewer.delegate = self
        self.helpDocViewer.name = "Help"
        self.helpDocViewer.presentPreview(animated: true)
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
    
    func openHelpDoc() {
        
        let newPath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newUrl = newPath.appendingPathComponent("mOCSHelp_iOS.pdf")
        
        if Helper.isFileExists(fileName: "mOCSHelp_iOS.pdf") {
            self.openFile(urlPath: newUrl)
        } else {
            self.downloadFile(destinationUrl: newUrl)
        }
    }
    
    @objc func openMoreVC(row : Int) {
        
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailsController") as! HomeDetailsController
        detail.newsData = listArray[row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func cancelFilter(filterString: String) {
    }
    
    func applyFilter(filterString: String) {
    }
    
    @objc func populateList(){
        
        if internetStatus != .notReachable {
            
//            self.view.showLoading()
//            activityIndicatorView.startAnimating()
            let url = String.init(format: Constant.API.NEWS, Session.authKey)
            
            Alamofire.request(url).responseData(completionHandler: { response in
                self.refreshController.endRefreshing()
//                self.view.hideLoading()
//                self.activityIndicatorView.stopAnimating()
                if Helper.isResponseValid(vc: self, response: response.result,tv: nil){
                    let jsonResponse = JSON(response.result.value!)
                    Session.news = jsonResponse.rawString()!
                    self.parseAndAssign(response: jsonResponse.rawString()!)
                }
            })
        } else {
            Helper.showNoInternetMessg()
            //                Helper.showNoInternetState(vc: self, tb: tableView,action: #selector(populateList))
        }
    }
    
    @IBAction func logout_click(_ sender: Any) {
        self.openLogoutPopUp()
    }
    
    func parseAndAssign(response:String){
        
        var jsonResponse = JSON.init(parseJSON: response)
        let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
        if jsonArray.count > 0{
            
            self.listArray.removeAll()
            
            for(_,j):(String,JSON) in jsonResponse {
                let data:NewsData = NewsData()
                data.id = j["ID"].stringValue
                data.title = j["Title"].stringValue
                data.description = j["Description"].stringValue
                data.company = j["Company"].stringValue
                data.department = j["Department"].stringValue
                data.imgSrc = j["ImageSRC"].stringValue.replacingOccurrences(of: " ", with: "%20")
                if(data.company == Session.company || data.company == "" || data.company == "00"){
                    listArray.append(data)
                }
            }
            self.collVwNews.reloadData()
        } else {
            Helper.showMessage(message: "No Latest News Available", style: .info)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.collVwHeightConstraint.constant = self.collVwMenus.contentSize.height;
    }
    
    
    func onRightBtnTap() {
        self.logOutFromApp()
        self.myView.removeFromSuperviewWithAnimate()
    }
    
    func logOutFromApp() {
        
        Helper.clearSession()
        if FilterViewController.selectedDataObj.count != 0 {
            FilterViewController.selectedDataObj.removeAll()
        }
        let storyBoard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        let mainPage: UIViewController = storyBoard.instantiateViewController(withIdentifier: "loginController")
        self.present(mainPage, animated: false, completion: nil)
    }
    
    func openLogoutPopUp() {
        
        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        myView.setDataToCustomView(title: "Logout Requested?", description: "Do you wish to Logout?", leftButton: "NO", rightButton: "YES" , isTxtVwHidden: true, isApprove: false , isWithoutData: true)
        myView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        myView.cpvDelegate = self
        self.view.window?.addSubview(myView)
    }
    
}


extension HomeViewController: MaterialShowcaseDelegate {
    
    func showCaseWillDismiss(showcase: MaterialShowcase) {
    }
    
    func showCaseDidDismiss(showcase: MaterialShowcase) {
    }
}


extension HomeViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collVwNews {
            return listArray.count
        } else {
            return arrMenuTitle.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collVwNews {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newscell", for: indexPath as IndexPath) as! NewsCollVwCell
            cell.setDataToView(newsData: listArray[indexPath.row])
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuscell", for: indexPath as IndexPath) as! HomeMenuCell
            cell.imgVw.image = UIImage(named:  self.arrMenuIcons[indexPath.row])
            cell.lblTitle.text = arrMenuTitle[indexPath.row].first
            cell.lblDesc.text = arrMenuTitle[indexPath.row].last
            return cell
        }
    }
    
    func collectionView(_ collectionView : UICollectionView,layout  collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        if collectionView == self.collVwNews {
            return CGSize(width: collectionView.frame.size.width/1.05, height: 265)
        } else {
            return CGSize(width: collectionView.frame.size.width/2.09, height: 190)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collVwNews {
            self.openMoreVC(row: indexPath.row)
        } else {
            if indexPath.row == 2 {
                
                let paVC = UIStoryboard(name: "PendingApproval", bundle: nil).instantiateViewController(withIdentifier: "PendingApprovalsController") as! PendingApprovalsController
                self.navigationController?.pushViewController(paVC, animated: true)
            } else if indexPath.row == 3 {
                
                let tmVC = UIStoryboard(name: "TaskManager", bundle: nil).instantiateViewController(withIdentifier: "TaskManagerController") as! TaskManagerController
                self.navigationController?.pushViewController(tmVC, animated: true)
                
            } else if indexPath.row == 4 {
                
                let empDirVC = UIStoryboard(name: "Employee", bundle: nil).instantiateViewController(withIdentifier: "EmployeeController") as! EmployeeController
                self.navigationController?.pushViewController(empDirVC, animated: true)
                
            }  else if indexPath.row == 5 {
                
                self.openHelpDoc()
            } else {
                
                self.openSubMenu(index: indexPath.row)
            }
        }
    }
}



extension HomeViewController: UIDocumentInteractionControllerDelegate {
    
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




