//
//  ItineraryListController.swift
//  mocs
//
//  Created by Talat Baig on 9/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import DropDown

class ItineraryListController: UIViewController, IndicatorInfoProvider {

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ITINERARY DETAILS")
    }
    
    @IBOutlet weak var tableView: UITableView!

    var arrayList:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ItineraryListCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnAddItineraryTapped(_ sender: Any) {
        
        let addItrnyVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewItineraryVC") as! AddNewItineraryVC
        self.navigationController?.pushViewController(addItrnyVC, animated: true)
    }
}


extension ItineraryListController : UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 217
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let views = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItineraryListCell
        views.selectionStyle = .none
        return views
    }
    
    
    
    
    
}




