//
//  SalesSummaryReportController.swift
//  mocs
//
//  Created by Talat Baig on 12/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class SalesSummaryReportController: UIViewController, filterViewDelegate, clearFilterDelegate {
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var collVw: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SSOverallCell", bundle: nil), forCellReuseIdentifier: "overallcell")
        
        self.tableView.register(UINib(nibName: "SSChartCell", bundle: nil), forCellReuseIdentifier: "chartcell")
        
        self.tableView.register(UINib(nibName: "SSListCell", bundle: nil), forCellReuseIdentifier: "listcell")
        
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(fetchAllSSData))
        tableView.addSubview(refreshControl)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 5.0
        collVw.collectionViewLayout = flowLayout
        
        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self
        
        fetchAllSSData()
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Sales Summary"
        vwTopHeader.lblSubTitle.isHidden = true

    }
    
    
    func clearAll() {
        self.collVw.reloadData()
        self.fetchAllSSData()
    }
    
    func applyFilter(filterString: String) {
        
//        if !dataEntry.isEmpty || apData != nil {
//            dataEntry.removeAll()
//            apData = nil
//        }
        
        if filterString.contains(",") {
            Helper.showMessage(message: "Please select only one filter")
            return
        }
        self.fetchAllSSData()
        self.collVw.reloadData()
    }
    
    func cancelFilter(filterString: String) {
//        self.apData = nil
//        self.dataEntry.removeAll()
    }
    
    @objc func fetchAllSSData() {
    
    }

}


// MARK: - UITableViewDataSource methods
extension SalesSummaryReportController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if self.dataEntry.count > 0 {
//            tableView.backgroundView?.isHidden = true
//            tableView.separatorStyle = .singleLine
//        } else {
//            tableView.backgroundView?.isHidden = false
//            tableView.separatorStyle = .none
//        }
        
        switch section {
        case 0,2:
//            if self.apData != nil {
                return 1
//            } else {
//                return 0
//            }
        case 1:
//            if self.dataEntry.count > 0 {
                return 1
//            } else {
//                return 0
//            }
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0.0
        
        switch indexPath.section {
            
        case 0:
//            if let invCount = self.apData?.totalInvoice.count {
//
//                if invCount > 2 && invCount <= 4 {
//                    height = 180
//                } else if invCount > 2 && invCount <= 6 {
//                    height = 215
//                } else {
                    height = 215
//                }
//            }
//            print("case 0:", height)
            break
        case 1:  height = 300.0
            break
        case 2:
//            if let invCount = self.apData?.totalInvoice.count {
            
                
//                if invCount > 2 && invCount <= 4 {
//                    height = 270
//                } else if invCount > 2 && invCount <= 6 {  // 3,4,5,6
                    height = 295
//                } else { // 1,2
//                    height = 230
//                }
//            }
            break
        default: height = 200.0
            break
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "overallcell") as! SSOverallCell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.isUserInteractionEnabled = false
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartcell") as! SSChartCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listcell") as! SSListCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
        } else {
        }
    }
    
}



extension SalesSummaryReportController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterViewController.selectedDataObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionCell", for: indexPath as IndexPath) as! FilterCollectionViewCell
        let newObj = FilterViewController.selectedDataObj[indexPath.row]
        let  newStr = (newObj.company?.compName)! + "|" + (newObj.location?.locName)! + "|" +  newObj.name!
        cell.lblTitle.text = newStr
        cell.lblTitle.preferredMaxLayoutWidth = 100
        return cell
    }
    
    func collectionView(_ collectionView : UICollectionView,layout  collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        let newObj = FilterViewController.selectedDataObj[indexPath.row]
        let  newStr = (newObj.company?.compName)! + "|" + (newObj.location?.locName)! + "|" +  newObj.name!
        let size: CGSize = newStr.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0)])
        return size
    }
    
    
}


// MARK: - WC_HeaderViewDelegate methods
extension SalesSummaryReportController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
