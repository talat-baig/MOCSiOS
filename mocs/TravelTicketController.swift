//
//  TravelTicketController.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class TravelTicketController: UIViewController , UIGestureRecognizerDelegate {

    var arrayList: [TravelTicketData] = []
    var newArray : [TravelTicketData] = []
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        
        populateList()
        //        self.title = "Travel Claims"
        srchBar.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.isHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Travel Tickets"
        vwTopHeader.lblSubTitle.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    
    @objc func populateList() {

    }
    
    
    
    @IBAction func btnAddNewTicketTapped(_ sender: Any) {
        
        let ttAddEdit = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketAddEditVC") as! TravelTicketAddEditVC
//        ttAddEdit.response = nil
//        ttAddEdit.okTCRSubmit = self
        self.navigationController?.pushViewController(ttAddEdit, animated: true)
    }
    
}


extension TravelTicketController: UISearchBarDelegate {
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

extension TravelTicketController: UITableViewDataSource, UITableViewDelegate , onMoreClickListener, onTTItemClickListener {
    
    func onViewClick() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TTBaseViewController") as! TTBaseViewController
        vc.isFromView = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func onEditClick() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TTBaseViewController") as! TTBaseViewController
        vc.isFromView = false
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func onDeleteClick(data: TravelTicketData) {
        
    }
    
    func onSubmitClick(data: TravelTicketData) {
        
    }
    
    func onEmailClick(data: TravelTicketData) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 286
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TTBaseViewController") as! TTBaseViewController
        vc.isFromView = false
        self.navigationController!.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let view = tableView.dequeueReusableCell(withIdentifier: "cell") as! TravelTicketCell
        view.btnMore.tag = indexPath.row
        view.setDataToView(data: nil)
        view.delegate = self
        view.ttReqClickListnr = self
        return view
    }
    
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: TravelTicketCell = self.tableView.cellForRow(at: indexPath) as! TravelTicketCell
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMore
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
  
}

extension TravelTicketController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}
