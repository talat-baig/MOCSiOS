//
//  DOProductController.swift
//  mocs
//
//  Created by Admin on 3/1/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class DOProductController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"PRODUCTS")
    }
    
    var response:JSON?
    var arrayList:[DOProductData] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var rono: UILabel!
    @IBOutlet weak var bagSize: UILabel!
    @IBOutlet weak var vessel: UILabel!
    @IBOutlet weak var doQty: UILabel!
    @IBOutlet weak var doUQM: UILabel!
    @IBOutlet weak var doQtyMT: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var doPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func parseAndAssign(){
        for(_,j):(String,JSON) in response!{
            var data = DOProductData()
            data.releaseOrderNo = j["Release Order No."].stringValue
            data.product = j["Product"].stringValue
            data.quality = j["Quality"].stringValue
            data.bagSize = j["Bag Size"].stringValue
            data.brand = j["Brand"].stringValue
            data.roNo = j["RO No."].stringValue
            data.vessel = j["Vessel"].stringValue
            data.doUom = j["RO Uom"].stringValue
            data.roAvailQty = j["RO Avail Quantity"].stringValue
            data.roAvailQtyMt = j["RO Avail Quantity (mt)"].stringValue
            data.weightTerm = j["Weight Terms"].stringValue
            data.doUom = j["DO Uom"].stringValue
            data.doQty = j["DO Quantity"].stringValue
            data.doQtyMt = j["DO Quantity"].stringValue
            data.doPrice = j["Price"].stringValue
            arrayList.append(data)
        }
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0);
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        self.tableView(self.tableView, didSelectRowAt: indexPath)
    }
    
    func setData(data:DOProductData){
        quantity.text! = data.quality
        brand.text! = data.brand
        rono.text! = data.roNo
        bagSize.text! = data.bagSize
        vessel.text! = data.vessel
        doQty.text! = data.doQty
        doQtyMT.text! = data.doQtyMt
        doUQM.text! = data.doUom
        weight.text! = data.weightTerm
        doPrice.text! = data.doPrice
    }
    

}
extension DOProductController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data = arrayList[indexPath.row]
        var view = tableView.dequeueReusableCell(withIdentifier: "cell")
        view?.textLabel?.text = data.product
        return view!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = arrayList[indexPath.row]
        setData(data: data)
    }
}

