//
//  AvlRelBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 11/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AvlRelBaseViewController: UIViewController,filterViewDelegate , clearFilterDelegate {
    
    /// Top Header
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collVw: UICollectionView!
    let arrImgName = [ "vessel", "product", "warehouse"]
    let arrTitle = ["Vessel", "Product" , "Warehouse"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "AvlRelBaseCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "Available Releases"
        vwTopHeader.lblSubTitle.isHidden = true
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        flowLayout.minimumInteritemSpacing = 5.0
//        collVw.collectionViewLayout = flowLayout

        Helper.setupCollVwFitler(collVw: self.collVw)

        FilterViewController.filterDelegate = self
        FilterViewController.clearFilterDelegate = self


    }
    
    func cancelFilter(filterString: String) {
    }
    
    
    func applyFilter(filterString: String) {
       self.collVw.reloadData()
    }
    
    func clearAll() {
        self.collVw.reloadData()
    }
    
    @objc func navigateToList(sender: UIButton) {
        
        if FilterViewController.getFilterString() == "" {
            self.view.makeToast("Please Select Filter")
            return
        }
        
        if sender.tag == 0 {
//            getVesselData()
            let vessl = self.storyboard?.instantiateViewController(withIdentifier: "VesselListViewController") as! VesselListViewController
            self.navigationController?.pushViewController(vessl, animated: true)
        } else if sender.tag == 1 {
            let prod = self.storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            self.navigationController?.pushViewController(prod, animated: true)

        } else {
            let ware = self.storyboard?.instantiateViewController(withIdentifier: "WarehouseListViewController") as! WarehouseListViewController
            self.navigationController?.pushViewController(ware, animated: true)
        }
    }
    
}

extension AvlRelBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AvlRelBaseCell
        let tintedImage = UIImage(named: arrImgName[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.btnAvlRel.setImage(tintedImage, for: .normal)
        cell.btnAvlRel.tintColor = UIColor.white
        cell.lblTitle.text = arrTitle[indexPath.row]
        
        cell.btnAvlRel.tag = indexPath.row
        cell.btnAvlRel.addTarget(self, action: #selector(self.navigateToList(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}


// Mark: - WC_HeaderViewDelegate delegate methods
extension AvlRelBaseViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
}


extension AvlRelBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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




