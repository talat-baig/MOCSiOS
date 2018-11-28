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

class AvlRelBaseViewController: UIViewController {
    
    /// Top Header
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
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
