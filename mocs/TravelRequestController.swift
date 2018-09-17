//
//  TravelRequestController.swift
//  mocs
//
//  Created by Talat Baig on 9/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TravelRequestController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    @IBOutlet weak var srchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        
        srchBar.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.isHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Travel Requests"
        vwTopHeader.lblSubTitle.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func populateList() {
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }

}

extension TravelRequestController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if  searchText.isEmpty {
//            self.arrayList = newArray
//        } else {
//            let filteredArray = newArray.filter {
//                $0.headRef.localizedCaseInsensitiveContains(searchText)
//            }
//            self.arrayList = filteredArray
//        }
//        tableView.reloadData()
    }
}


extension TravelRequestController: UITableViewDataSource, UITableViewDelegate, onMoreClickListener, onTReqItemClickListener {
    
    
    func onViewClick(data: TravelRequestData) {
       
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as! BaseViewController
//        vc.response = tcrResponse
//        vc.isFromView = isFromView
//        vc.tcrBaseDelegate = self
//        vc.notifyChilds = self
//        vc.title = tcrData.headRef
//        vc.voucherResponse = response.result.value
//        vc.tcrData = tcrData
//        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func onEditClick(data: TravelRequestData) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TRBaseViewController") as! TRBaseViewController
//        vc.response = tcrResponse
//        vc.isFromView = isFromView
//        vc.tcrBaseDelegate = self
//        vc.notifyChilds = self
//        vc.title = tcrData.headRef
//        vc.voucherResponse = response.result.value
//        vc.tcrData = tcrData
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func onDeleteClick(data: TravelRequestData) {
        
    }
    
    func onSubmitClick(data: TravelRequestData) {
        
    }
    
    func onEmailClick(data: TravelRequestData) {
        
    }
    
    
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if arrayList.count > 0 {
//            tableView.backgroundView?.isHidden = true
//            tableView.separatorStyle = .singleLine
//        } else {
//            tableView.backgroundView?.isHidden = false
//            tableView.separatorStyle = .none
//        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 305
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        handleTap()
   
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TRBaseViewController") as! TRBaseViewController
       
        self.navigationController!.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let view = tableView.dequeueReusableCell(withIdentifier: "TravelRequestAdapter") as! TravelRequestAdapter
        view.btnMore.tag = indexPath.row
        view.setDataToView(data: nil)
        view.delegate = self
        view.trvlReqItemClickListener = self
        return view
    }
    
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: TravelRequestAdapter = self.tableView.cellForRow(at: indexPath) as! TravelRequestAdapter
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMore
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func onViewClick(data: TravelClaimData) {
//        viewClaim(data: data ,isFromView: true)
    }
    
//    func viewClaim(data:TravelClaimData, counter: Int = 0, isFromView : Bool){
//        if internetStatus != .notReachable{
//            let url = String.init(format: Constant.TCR.VIEW, Session.authKey,
//                                  data.headRef,data.counter)
//            self.view.showLoading()
//            Alamofire.request(url).responseData(completionHandler: ({ response in
//                self.view.hideLoading()
//                if Helper.isResponseValid(vc: self, response: response.result){
//
//                    self.getVouchersDataAndNavigate(tcrData: data, isFromView: isFromView, tcrResponse: response.result.value)
//                }
//            }))
//        } else {
//            Helper.showNoInternetMessg()
//        }
//    }
//
    
    
//    func onEditClick(data: TravelClaimData) {
//        viewClaim(data: data, counter:data.counter , isFromView: false)
//    }
//
//    func onDeleteClick(data: TravelClaimData) {
//        let alert = UIAlertController(title: "Delete Claim?", message: "Are you sure you want to delete this claim? After deleting you'll not be able to rollback", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
//            self.deleteClaim(data: data)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func onSubmitClick(data: TravelClaimData) {
//
//        let currentDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM yyyy"
//        dateFormatter.calendar = Calendar(identifier: .iso8601)
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        let travelEndDate = dateFormatter.date(from: data.endDate)
//
//        if travelEndDate! > currentDate {
//            Helper.showMessage(message: "Travel end date cannot be greater then current date")
//            return
//
//        } else if data.totalAmount == "0.00" {
//            Helper.showMessage(message: "Please add expense before submitting")
//            return
//
//        } else {
//
//            let alert = UIAlertController(title: "Submit Claim?", message: "Are you sure you want to submit this claim? After submitting you'll not be able to edit the claim", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
//
//            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
//
//                self.submitInvoice(data:data)
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//    }
//
//    func onEmailClick(data: TravelClaimData) {
//
//        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
//        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
//            self.sendEmail(data: data)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
}


extension TravelRequestController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}

