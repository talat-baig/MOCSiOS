//
//  RelationshipController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON


class RelationshipController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "RELATIONSHIP")
    }
    
    var response : Data?
    
    @IBOutlet weak var lblAssociateType: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblCompany: UILabel!

    
    @IBOutlet weak var lblBVertical: UILabel!
    
    @IBOutlet weak var lblCommodity: UILabel!
    
    @IBOutlet weak var lblProduct: UILabel!
    
    @IBOutlet weak var lblNotes: UILabel!
    
    @IBOutlet weak var lblAddedBy: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func parseAndAssign() {
        
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse {
            
            if j["Company"].stringValue == "" {
                lblCompany.text! = "-"
            } else {
                lblCompany.text! = j["Company"].stringValue
            }
            
            if j["AssociateType"].stringValue == "" {
                lblAssociateType.text! = "-"
            } else {
                lblAssociateType.text! = j["AssociateType"].stringValue
            }
    
            if j["Location"].stringValue == "" {
                lblLocation.text! = "-"
            } else {
                lblLocation.text! = j["Location"].stringValue
            }
            
            if j["Businessgroup"].stringValue == "" {
                lblBVertical.text! = "-"
            } else {
                lblBVertical.text! = j["Businessgroup"].stringValue
            }
       
            if j["Commodity"].stringValue == "" {
                lblCommodity.text! = "-"
            } else {
                lblCommodity.text! = j["Commodity"].stringValue
            }
            
            if j["Product"].stringValue == "" {
                lblProduct.text! = "-"
            } else {
                lblProduct.text! = j["Product"].stringValue
            }
            
            if j["Notes"].stringValue == "" {
                lblNotes.text! = "-"
            } else {
                lblNotes.text! = j["Notes"].stringValue
            }
            
            if j["Addedbysysdt"].stringValue == "" {
                lblDate.text! = "-"
            } else {
                lblDate.text! = j["Addedbysysdt"].stringValue
            }
            
            if j["Addedby1"].stringValue == "" {
                lblAddedBy.text! = "-"
            } else {
                lblAddedBy.text! = j["Addedby1"].stringValue
            }
        }
    }
    

}
