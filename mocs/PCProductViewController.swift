//
//  PCProductViewController.swift
//  mocs
//
//  Created by Admin on 2/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class PCProductViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRODUCT")
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblQuality: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblBagSize: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblSKU: UILabel!
    @IBOutlet weak var lblQtyMT: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceTax: UILabel!
    
    var arrayList:[ProductData] = []
    var response:Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        parseAndAssign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseAndAssign(){
        let jsonRes = JSON(self.response)
        let arrayRes = jsonRes.arrayObject as! [[String:AnyObject]]
        let productJson = JSON.init(parseJSON: arrayRes[0]["Products"]! as! String)
        for(_,j):(String,JSON) in productJson{
            let data = ProductData()
            data.lotNo = j["Lot No"].stringValue
            data.productName = j["Product"].stringValue
            data.quality = j["Quality"].stringValue
            data.brand = j["Brand"].stringValue
            data.bagSize = j["Bag size"].stringValue
            data.quantity = j["Quanity"].stringValue
            data.sku = j["SKU"].stringValue
            data.quantityMT = j["Quanity (MT)"].stringValue
            data.price = j["Price"].stringValue
            data.priceWithTax = j["Product Price with Tax"].stringValue
            arrayList.append(data)
        }
        self.tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0);
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        self.tableView(self.tableView, didSelectRowAt: indexPath)
    }
    
    func setValues(data:ProductData){
        lblProduct.text! = data.productName
        lblQuality.text! = data.quality
        lblBrand.text! = data.brand
        lblBagSize.text! = data.bagSize
        lblQty.text! = data.quantity
        lblSKU.text! = data.sku
        lblQtyMT.text! = data.quantityMT
        lblPrice.text! = data.price
        lblPriceTax.text = data.priceWithTax
    }
    
}
extension PCProductViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = data.lotNo
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = arrayList[indexPath.row]
        setValues(data: data)
    }
}
