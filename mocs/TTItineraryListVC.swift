//
//  TTItineraryListVC.swift
//  mocs
//
//  Created by Talat Baig on 9/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NotificationCenter
import DropDown

class TTItineraryListVC: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ITINERARY DETAILS")
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          tableView.register(UINib(nibName: "ItineraryListCell", bundle: nil), forCellReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
