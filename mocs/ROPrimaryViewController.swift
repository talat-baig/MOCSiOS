//
//  ROPrimaryViewController.swift
//  mocs
//
//  Created by Talat Baig on 7/6/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class ROPrimaryViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    var response:Data!
    var roData = ROData()

    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblBUnit: UILabel!
    
    @IBOutlet weak var lblCommodity: UILabel!
    
    @IBOutlet weak var lblReleaseFor: UILabel!
    
    @IBOutlet weak var lblReqDate: UILabel!
    
    @IBOutlet weak var lblReqQty: UILabel!
    
    @IBOutlet weak var lblUom: UILabel!
    
    @IBOutlet weak var lblWhtTrms: UILabel!
    
    @IBOutlet weak var lblBalQty: UILabel!
    
    @IBOutlet weak var lblQtyRcvd: UILabel!
    
    @IBOutlet weak var lblRelOrderNo: UILabel!
    
    @IBOutlet weak var lblRcptDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        let lastView : UIView! = mySubVw.subviews.last
//        let height = lastView.frame.size.height
//        let pos = lastView.frame.origin.y
//        let sizeOfContent = height + pos + 100
//        
//        scrlVw.contentSize.height = sizeOfContent
//    }
    
    
    func parseAndAssign(){
        let jsonResponse = JSON(response)
        for(_,j):(String,JSON) in jsonResponse{
            lblCompany.text! = j["Company Name"].stringValue
            lblLocation.text! = j["Location"].stringValue
            lblBUnit.text! = j["Business Vertical"].stringValue
            lblCommodity.text! = j["Commodity"].stringValue
            lblReleaseFor.text! = j["Release For"].stringValue
            lblReqDate.text! = j["Request Date"].stringValue
            
            lblReqQty.text! = roData.reqQty
//            lblUom.text! = roData.uom
            lblWhtTrms.text! = roData.wghtTrms
            lblBalQty.text! = roData.balQty
            lblRelOrderNo.text! = roData.relOrderNum
            lblQtyRcvd.text! = roData.rcvdQty
            lblRcptDate.text! = roData.rcptDate

            
            
        }
    }

    
}
