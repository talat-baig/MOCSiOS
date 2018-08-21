//
//  EPRListView.swift
//  mocs
//
//  Created by Talat Baig on 4/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol addEPRAdvancesDelegate {
    func onAddTap(eprIdString : String, tempArr : [TCREPRListData]) -> Void
    func onCancelTap()
}


class EPRListView: UIView {
    
    var arrayList : [TCREPRListData] = []
    var delegate : addEPRAdvancesDelegate?
    var newEPRString = String()

    @IBOutlet weak var tblVwEPR: UITableView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tblVwEPR.register(UINib(nibName: "EPRListCell", bundle: nil), forCellReuseIdentifier: "eprCell")
        
//        self.tblVwEPR.separatorStyle = .none
        
    }
    
    func setEprData(arrData : [TCREPRListData]){
        
        self.arrayList = arrData
        
        self.tblVwEPR.reloadData()
    }
    
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        var eprStringArr = [String]()
        
        for newObj in self.arrayList {
            if newObj.isSelect {
                eprStringArr.append(newObj.eprRefId)
            }
        }
        
         newEPRString = eprStringArr.joined(separator: ",")
        if let d = delegate {
            d.onAddTap(eprIdString: newEPRString, tempArr : self.arrayList)
            self.removeFromSuperviewWithAnimate()
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        if let d = delegate {
            d.onCancelTap()
            self.removeFromSuperviewWithAnimate()
        }
    }
    
}


extension EPRListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eprData = arrayList[indexPath.row]
        
        let cell = tblVwEPR.dequeueReusableCell(withIdentifier: "eprCell") as! EPRListCell
        cell.layer.masksToBounds = true
        cell.setupDataToView(tcrEPRData: eprData, isSelected: eprData.isSelect)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eprData = self.arrayList[indexPath.row]
        eprData.isSelect = !eprData.isSelect
    
        tblVwEPR.reloadData()
    }
    
   
}

