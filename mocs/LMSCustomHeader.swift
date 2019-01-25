//
//  LMSCustomHeader.swift
//  mocs
//
//  Created by Talat Baig on 1/21/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSCustomHeader: UITableViewCell {

    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var dept: UILabel!
    @IBOutlet weak var repMngr: UILabel!
    @IBOutlet weak var empCode: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var tblVwSummary: LMSGridTableView!
    
    var data : LMSGridData?
    var arrayList : [LMSGridData] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwOuter.layer.cornerRadius = 5.0

        vwOuter.layer.shadowOpacity = 0.20
        vwOuter.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        vwOuter.layer.shadowRadius = 2.0
        vwOuter.layer.shadowColor = UIColor.black.cgColor
        vwOuter.layer.masksToBounds = false

        btnApply.layer.cornerRadius = 5
        btnApply.layer.shadowRadius = 1.0
        btnApply.layer.shadowOpacity = 0.20
        btnApply.layer.masksToBounds = false
        btnApply.layer.shadowOffset =  CGSize.init(width: 0, height: 2)
        
        self.tblVwSummary.register(UINib(nibName: "LMSGridCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tblVwSummary.separatorStyle = .none
//
        tblVwSummary.delegate = self
        tblVwSummary.dataSource = self

    }
    
    func setDataToViews(data : [LMSGridData]) {
        empName.text = Session.user
        dept.text = Session.department
        empCode.text = Session.empCode
        repMngr.text = Session.reportMngr
        self.arrayList = data

        if self.arrayList.count > 0 {
            tblVwSummary.reloadData()
        }
    }
    
    
    
    
}

extension LMSCustomHeader {
    
//    func setTableViewDatasourceDelegate <D: UITableViewDelegate & UITableViewDataSource> (_ dataSourceDelegate : D,forRow row :Int) {
//
//        tblVwSummary.delegate = dataSourceDelegate
//        tblVwSummary.dataSource = dataSourceDelegate
//        tblVwSummary.reloadData()
//    }
}

extension LMSCustomHeader : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.arrayList.count > 0 {
            
            if section == 0 {
                return 1
            } else {
                return self.arrayList.count
            }
            
        } else {

        }
        return self.arrayList.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LMSGridCell
        cell.selectionStyle =  .none
        
        
        if indexPath.section == 0 {
            cell.setStaticData()
        } else {
            let gridData = self.arrayList[indexPath.row]
            cell.setDataToView(gridData: gridData)
        }
        return cell
        
    }
    
}



