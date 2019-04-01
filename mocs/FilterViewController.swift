//
//  FilterViewController.swift
//  mocs
//
//  Created by Admin on 2/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RATreeView


protocol filterViewDelegate {
    func applyFilter(filterString : String)
    func cancelFilter(filterString : String)
}

protocol clearFilterDelegate {
    func clearAll()
}

class FilterViewController: UIViewController, RATreeViewDelegate, RATreeViewDataSource, onFilterButtonTap {
    
    var selectedLocation : [DataObject] = []
    
    var dataObj : [DataObject] = []
    var treeView : RATreeView!
    
    static var selectedDataObj : [DataObject] = []
    
    @IBOutlet weak var collVwFilter: UICollectionView!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    
    @IBOutlet weak var vwTreeTable: UIView!
    @IBOutlet weak var vwInner: UIView!
    
    @IBOutlet weak var vwButtons: UIView!
    static var filterDelegate: filterViewDelegate?
    static var clearFilterDelegate: clearFilterDelegate?
    
    //Added By RV : 13 May 18
    var delegate: onFilterButtonTap?
    var headerVwFilter : FilterHeaderView?
    
    @IBOutlet weak var vwBtnClear: UIView!
    
    @IBOutlet weak var btnClear: UIButton!
    
    @IBOutlet weak var vwCollection: UIView!
    @IBOutlet weak var collVw: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTreeView()
        populateFilterList()
        
        
        Helper.setupCollVwFitler(collVw: self.collVwFilter)

        //Added By RV : 13 May 18
        headerVwFilter = Bundle.main.loadNibNamed("FilterHeaderView", owner: nil, options: nil)![0] as? FilterHeaderView
        headerVwFilter?.frame = CGRect.init(x: 0, y: 0, width:  self.view.frame.size.width, height: 70 )
        headerVwFilter?.delegate = self
        self.view.addSubview(headerVwFilter!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FilterViewController.selectedDataObj.count == 0 {
            self.populateFilterList()
        }
        treeView.separatorStyle = RATreeViewCellSeparatorStyleNone
        treeView.reloadData()
        self.collVwFilter.reloadData()
        headerVwFilter?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if FilterViewController.selectedDataObj.count == 0 {
            // self.cancelFilter()
        }
    }
    
    func setupTreeView() -> Void {
        treeView = RATreeView(frame: CGRect(x:0, y: 0, width: self.vwTreeTable.frame.size.width, height: self.vwTreeTable.frame.size.height))
        treeView.register(UINib(nibName: String(describing: CompanyFilterCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CompanyFilterCell.self))
        treeView.register(UINib(nibName: String(describing: LocationFilterCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LocationFilterCell.self))
        treeView.register(UINib(nibName: String(describing: BusinessUnitFilterCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BusinessUnitFilterCell.self))
        
        treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        treeView.allowsMultipleSelection = true
        treeView.delegate = self;
        treeView.dataSource = self;
        treeView.treeFooterView = UIView()
        treeView.backgroundColor = .clear
        vwTreeTable.addSubview(treeView)
    }
    
    
    
    @objc func populateFilterList() {
        
        if Session.filterList == "" {
            if (internetStatus != .notReachable) {
                let url = String.init(format: Constant.API.FILTER_LIST, Session.authKey)
                self.view.showLoading()
                Alamofire.request(url).responseData(completionHandler: ({ response in
                    self.view.hideLoading()
                    if Helper.isResponseValid(vc: self, response: response.result) {
                        
                        let jsonResponse = JSON(response.result.value!)
                        Session.filterList = jsonResponse.rawString()!
                        self.parseAndAssign(response: Session.filterList)
                    }
                }))
            } else {
                Helper.showNoInternetStateTreeVw(vc: self, treeVw: treeView, action:#selector(populateFilterList))
                
            }
        } else {
            parseAndAssign(response: Session.filterList)
        }
    }
    
    func parseAndAssign(response:String){
        
        let jsonResponse = JSON.init(parseJSON: response)
        
        if jsonResponse.arrayObject == nil {
            Helper.showNoInternetStateTreeVw(vc: self, treeVw: treeView, action: #selector(populateFilterList))
            return
        }
        
        let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
        
        if jsonArr.count > 0 {
            
            let companies = jsonResponse[0]["Companies"].stringValue
            let companiesJson = JSON.init(parseJSON: companies)
            
            if companiesJson.arrayObject == nil {
                Helper.showNoInternetStateTreeVw(vc: self, treeVw: treeView, action: #selector(populateFilterList))
                return
            }
            
            let companiesJsonArr = companiesJson.arrayObject as! [[String:AnyObject]]
            var dataObject : [DataObject] = []
            
            if companiesJsonArr.count > 0 {
                
                for j in 0..<companiesJsonArr.count {
                    
                    let company = companiesJson[j]["Company"].stringValue
                    let locs = companiesJson[j]["Locations"]
                    
                    
                    var loc:[DataObject] = []
                    for k in 0..<locs.count {
                        
                        let location = locs[k]["Location"].stringValue
                        let busUnit = locs[k]["BusinessUnits"]
                        
                        var bu:[DataObject] = []
                        for l in 0..<busUnit.count {
                            
                            let comp = Company()
                            comp.compName = company
                            
                            let lastTenChar = company.suffix(5)
                            let compStr = String(lastTenChar)
                            
                            let sliced  = compStr.slice(from: "(", to: ")")
                            comp.compCode = sliced ?? "0"
//                            print(comp.compCode)
                            
                            let loc = Location()
                            loc.locName = location
                            
                            let newBUString = busUnit[l]["BU"].stringValue
                            let buSliced  = newBUString.slice(from: "(", to: ")")

                            //  print(buSliced!)
                            let newBName = busUnit[l]["BU"].stringValue
                            
                            bu.append(DataObject(name: newBName,
                                                 code: buSliced ?? "0",
                                                 children: [],
                                                 company: comp,
                                                 location :loc ))
                        }
                        
                        loc.append( DataObject(name: locs[k]["Location"].stringValue,
                                               code: locs[k]["Location"].stringValue,
                                               children: bu))
                    }
                    dataObject.append(DataObject(name: companiesJson[j]["Company"].stringValue, code:   companiesJson[j]["Company"].stringValue.slice(from: "(", to: ")")!, children: loc))
                }
            } else {
                vwBtnClear.isHidden = true
                btnClear.isHidden = true
            }
            
            self.dataObj = dataObject
            self.treeView.treeFooterView = nil
            DispatchQueue.main.async {
                self.treeView.reloadData()
            }
        } else {
            
        }
    }
    
    func updateFilterHeader() {
        if FilterViewController.selectedDataObj.count > 0 {
            headerVwFilter?.lable.text = String(format : "%d selected",FilterViewController.selectedDataObj.count)
            headerVwFilter?.isHidden = false
        }else{
            headerVwFilter?.isHidden = true
            //            collVwFilter.reloadData()
        }
        
    }
    
    func cancelFilter() {
        
        if FilterViewController.selectedDataObj.count != 0 {
            FilterViewController.selectedDataObj.removeAll()
        }
        self.collVwFilter.reloadData()
        let fString = ""
        if let d = FilterViewController.filterDelegate {
            d.cancelFilter(filterString: fString )
            self.sideMenuViewController?.hideMenuViewController()
        }
    }
    
    static func setFilterString() {
        
    }
    
    
    
    static func getFilterString(noBU : Bool = false ) -> String {
        
        var newStrArr : [String]  = []
        var newStr = String()
        for newObj in self.selectedDataObj {
            
            if noBU {
                newStr = Helper.encodeURL(url:(newObj.company?.compCode)!) + "+" + Helper.encodeWhiteSpaces(url:(newObj.location?.locName)!)
            } else {
                newStr = Helper.encodeURL(url:(newObj.company?.compCode)!) + "+" + Helper.encodeWhiteSpaces(url: (newObj.location?.locName)!) + "+" +  newObj.code!
            }
            newStrArr.append(newStr)
        }
        
        let filterString = newStrArr.joined(separator: ",")
        return filterString
    }
    
    func onDone() {
        let fString = FilterViewController.getFilterString()
        self.collVwFilter.reloadData()
        
        headerVwFilter?.isHidden = true
        
        for newItem in selectedLocation {
            newItem.location?.isExpanded = false
            newItem.company?.isExpanded = false
        }
        
        for i in 0..<dataObj.count{
            dataObj[i].company?.isExpanded = false
            dataObj[i].location?.isExpanded = false
        }
        
        if let d = FilterViewController.filterDelegate {
            d.applyFilter(filterString: fString )
            self.sideMenuViewController?.hideMenuViewController()
        }
    }
    
    func onCancel() {
        
        let fString = ""
        self.sideMenuViewController?.hideMenuViewController()
        headerVwFilter?.isHidden = true
        
        for newItem in selectedLocation {
            newItem.location?.isExpanded = false
            newItem.company?.isExpanded = false
        }
        
        for i in 0..<dataObj.count{
            dataObj[i].company?.isExpanded = false
            dataObj[i].location?.isExpanded = false
        }
        
    }
    
    
    @IBAction func btnClearAllTapped(_ sender: Any) {
        
        if FilterViewController.selectedDataObj.count != 0 {
            
            for newObj in FilterViewController.selectedDataObj {
                newObj.company?.isExpanded = false
                newObj.location?.isExpanded = false
                newObj.isSelect = false
            }
            self.treeView.reloadRows(forItems: [FilterViewController.selectedDataObj], with: RATreeViewRowAnimationNone)
            FilterViewController.selectedDataObj.removeAll()
        }
        
        if let d = FilterViewController.clearFilterDelegate {
            d.clearAll()
        }
        
        updateFilterHeader()
        self.collVwFilter.reloadData()
        
    }
    
    
    //MARK: RATreeView data source
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? DataObject {
            return (item.children?.count)!
        } else {
            return self.dataObj.count
        }
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? DataObject {
            return item.children![index]
        } else {
            return dataObj[index] as AnyObject
        }
    }
    
    func treeView(_ treeView: RATreeView, heightForRowForItem item: Any) -> CGFloat {
        return 60
    }
    
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        
        let cellCompany = treeView.dequeueReusableCell(withIdentifier: String(describing: CompanyFilterCell.self)) as! CompanyFilterCell
        let cellLocation = treeView.dequeueReusableCell(withIdentifier: String(describing: LocationFilterCell.self)) as! LocationFilterCell
        let cellBU = treeView.dequeueReusableCell(withIdentifier: String(describing: BusinessUnitFilterCell.self)) as! BusinessUnitFilterCell
        
        let item = item as! DataObject
        let level = treeView.levelForCell(forItem: item)
        
        if item.isSelect {
            cellBU.btnCheck.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        } else {
            cellBU.btnCheck.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        
        if level == 0 {
            
            cellCompany.selectionStyle = .none
            cellCompany.setupCellViews(title: item.name!)
            
            if (item.company?.isExpanded)! {
                cellCompany.imgVw.image = #imageLiteral(resourceName: "collapse")
            } else {
                cellCompany.imgVw.image = #imageLiteral(resourceName: "expand")
            }
            return cellCompany
            
        } else if level == 1 {
            
            cellLocation.selectionStyle = .none
            cellLocation.setupCellViews(title: item.name!)
            
            if (item.location?.isExpanded)! {
                cellLocation.imgVw.image = #imageLiteral(resourceName: "collapse")
            } else {
                cellLocation.imgVw.image = #imageLiteral(resourceName: "expand")
            }
            return cellLocation
        } else {
            
            cellBU.selectionStyle = .none
            cellBU.setupCellViews(title: item.name!)
            //enableDisableApply()
            return cellBU
        }
    }
    
    func treeView(_ treeView: RATreeView, didSelectRowForItem item: Any) {
        
        let item = item as! DataObject
        let level = treeView.levelForCell(forItem: item)
        
        if level == 2 {
            if let index = FilterViewController.selectedDataObj.index(where: {$0 == item}) {
                item.isSelect = false
                FilterViewController.selectedDataObj.remove(at: index)
            } else {
                item.isSelect = true
                FilterViewController.selectedDataObj.append(item)
            }
            updateFilterHeader()
        } else if level == 0  {
            let cell = treeView.cell(forItem: item) as! CompanyFilterCell
            let state = treeView.isCellExpanded(cell)
            
            if !state {
                item.company?.isExpanded = true
                treeView.collapseRow(forItem: item)
            } else {
                item.company?.isExpanded = false
                treeView.expandRow(forItem: item)
            }
        } else {
            
            let cell = treeView.cell(forItem: item) as! LocationFilterCell
            let state = treeView.isCellExpanded(cell)
            item.location?.isExpanded = !(item.location?.isExpanded)!
            
            if let index = selectedLocation.index(where: {$0 == item}) {
            } else {
                selectedLocation.append(item)
            }
            
            if !state {
                treeView.collapseRow(forItem: item)
            } else {
                treeView.expandRow(forItem: item)
            }
        }
        treeView.reloadRows(forItems: [item], with: RATreeViewRowAnimationNone)
    }
    
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterViewController.selectedDataObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionCell", for: indexPath as IndexPath) as! FilterCollectionViewCell
        let newObj = FilterViewController.selectedDataObj[indexPath.row]
        let  newStr = (newObj.company?.compName)! + "|" + (newObj.location?.locName)! + "|" +  newObj.name!
        cell.lblTitle.text = newStr
        cell.lblTitle.font =  UIFont.systemFont(ofSize: 17.0)
        //        cell.lblTitle.preferredMaxLayoutWidth = 100
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




