//
//  TRIAllocationController.swift
//  mocs
//
//  Created by Admin on 3/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class TRIAllocationController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ALLOCATION ITEMS")
    }
    
    /// Array of JSON data
    var arrayList:[JSON] = []
    
    /// Response String
    var response:String?
    
    /// View Outer
    @IBOutlet weak var vwOuter: UIView!
    
    /// Table View
    @IBOutlet weak var tableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        populateList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Parse response to JSON and Populate Table view with array data
    func populateList() {
        if let data = response {
            var jsonArray = JSON.init(parseJSON: data).array!
            if jsonArray.count > 0 {
                
                for i in 0..<jsonArray.count {
                    arrayList.append(jsonArray[i])
                }
                tableView.reloadData()
            }
        }
    }
}

// Mark: - Tableview delegate and datasource methods
extension TRIAllocationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TRIAllocationCell
        cell.selectionStyle = .none
        cell.setDataToView(data: data)
        
        return cell
    }
    
}
