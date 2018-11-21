//
//  RODetailsViewController.swift
//  mocs
//
//  Created by Talat Baig on 11/19/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class RODetailsViewController: UIViewController {

    var roNum = ""
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "RODetailsCell", bundle: nil), forCellReuseIdentifier: "rocell")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Report [Vessel-wise]"
        vwTopHeader.lblSubTitle.text = roNum
    
    }
    

    
}


extension RODetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 196
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rocell") as! RODetailsCell
        cell.layer.masksToBounds = true
        
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension RODetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}


extension RODetailsViewController: WC_HeaderViewDelegate {
    
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

