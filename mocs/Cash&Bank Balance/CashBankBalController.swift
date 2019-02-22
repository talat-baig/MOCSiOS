//
//  CashBankBalController.swift
//  mocs
//
//  Created by Talat Baig on 2/22/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class CashBankBalController: UIViewController {

    var searchString = ""
    var currentPage : Int = 1
//    var arrayList:[ECREmpData] = []
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var btnMore: UIButton!
    //    @IBOutlet weak var btnMore: UIView!
    
    @IBOutlet weak var filterVw: UIView!
    @IBOutlet weak var vwContent: UIView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
}
