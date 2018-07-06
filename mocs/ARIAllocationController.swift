//
//  ARIAllocationController.swift
//  mocs
//
//  Created by Admin on 3/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class ARIAllocationController: UIViewController,IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ALLOCATION ITEMS")
    }
    

    @IBOutlet weak var tableView: UITableView!
    var arrayList:[JSON] = []
    var response:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /// Parse Json response and populate table view with response
    func populateList(){
        if let data = response{
            var jsonArray = JSON.init(parseJSON: data).array!
            if jsonArray.count > 0{
                for i in 0..<jsonArray.count{
                    arrayList.append(jsonArray[i])
                }
                tableView.reloadData()
            }
        }
    }
}

// Mark: - UITableViewDataSource and UITableViewDelegate methods
extension ARIAllocationController: UITableViewDataSource, UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AllocationAdapter
        cell.setDataToView(data: data)
        cell.selectionStyle = .none
        return cell
    }
}
