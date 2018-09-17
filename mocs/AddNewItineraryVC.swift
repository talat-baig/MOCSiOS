//
//  AddNewItineraryVC.swift
//  mocs
//
//  Created by Talat Baig on 9/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class AddNewItineraryVC: UIViewController {

    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var vwDestination: UIView!
    
    @IBOutlet weak var vwDepDate: UIView!
    
    @IBOutlet weak var vwReturnDate: UIView!

    @IBOutlet weak var vwEstdDays: UIView!
    
    @IBOutlet weak var vwAccmpndBy: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Itinerary"
        vwTopHeader.lblSubTitle.isHidden = true
        
        
        Helper.addBordersToView(view: vwDestination)
        Helper.addBordersToView(view: vwDepDate)
        Helper.addBordersToView(view: vwReturnDate)
        Helper.addBordersToView(view: vwEstdDays)
        Helper.addBordersToView(view: vwAccmpndBy)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   

}


extension AddNewItineraryVC: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}


