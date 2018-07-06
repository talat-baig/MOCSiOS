//
//  ECRVoucherListVC.swift
//  mocs
//
//  Created by Talat Baig on 6/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class ECRVoucherListVC: UIViewController,IndicatorInfoProvider {

    @IBOutlet weak var tableView: UITableView!
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "VOUCHERS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.register(UINib.init(nibName: "AttachmentCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension ECRVoucherListVC: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
//        if arrayList.count > 0{
//            tableView.backgroundView?.isHidden = true
//            tableView.separatorStyle = .singleLine
//        } else {
//            tableView.backgroundView?.isHidden = false
//            tableView.separatorStyle = .none
//        }
//        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellView = tableView.dequeueReusableCell(withIdentifier: "cell") as! AttachmentCell
        cellView.title.text = "test"
        cellView.status.text = "Tap to Download"
        cellView.selectionStyle = .none
        
        cellView.btnStatus.tag = indexPath.row
        cellView.btnDelete.tag = indexPath.row
        
        
        return cellView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
}
