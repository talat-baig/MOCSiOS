//
//  DebitStatementController.swift
//  mocs
//
//  Created by Talat Baig on 3/25/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DebitStatementController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "DEBIT")
    }
    
    var response:Data?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.register(UINib(nibName: "CUDebitCell", bundle: nil), forCellReuseIdentifier: "cell")
//        self.tableView.separatorStyle = .none
//        self.tableView.estimatedRowHeight = 100
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        Helper.setupTableView(tableVw : self.tableView, nibName: "CUDebitCell")
    }
    


}

extension DebitStatementController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CUDebitCell
        cell.selectionStyle = .none
        return cell
    }
    
}
