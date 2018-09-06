//
//  CPPrimaryViewController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CPPrimaryViewController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var mySubVw: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //scrlVw.contentSize.height = 800
    }

    override func viewWillAppear(_ animated: Bool) {
//        scrlVw.contentSize.height = 650
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
