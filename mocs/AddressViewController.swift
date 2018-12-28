//
//  AddressViewController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AddressViewController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
         return IndicatorInfo(title: "ADDRESS")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

 

}
