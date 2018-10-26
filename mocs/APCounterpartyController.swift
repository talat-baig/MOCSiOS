//
//  APCounterpartyController.swift
//  mocs
//
//  Created by Talat Baig on 10/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class APCounterpartyController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "APCounterpartyCell", bundle: nil), forCellReuseIdentifier: "apcounterypartycell")
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Accounts Payable Report"
        vwTopHeader.lblSubTitle.isHidden = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleTap() {
        self.srchBar.endEditing(true)
    }
}



extension APCounterpartyController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 250.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apcounterypartycell") as! APCounterpartyCell
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
//        if cpListData.count > 0 {
//            DispatchQueue.main.async {
////                cell.setDataToView(data: self.cpListData[indexPath.row])
//            }
//        }
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension APCounterpartyController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
        
    }
}


extension APCounterpartyController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if  searchText.isEmpty {
//            self.cpListData = newArray
//        } else {
//            let filteredArray = newArray.filter {
//                $0.cpName.localizedCaseInsensitiveContains(searchText)
//            }
//            self.cpListData = filteredArray
//        }
//        tblVwCP.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        srchBar.text = ""
//        self.srchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.srchBar.endEditing(true)
    }
}

extension APCounterpartyController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}

