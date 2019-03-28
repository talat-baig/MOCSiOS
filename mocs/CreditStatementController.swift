//
//  CreditStatementController.swift
//  mocs
//
//  Created by Talat Baig on 3/25/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CreditStatementController: UIViewController ,IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "CREDIT")
    }
    
    var response:Data?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        Helper.setupTableView(tableVw : self.tableView, nibName: "CUCreditCell")

    }
    
}



extension CreditStatementController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CUCreditCell
        cell.selectionStyle = .none
        return cell
    }
    
}
