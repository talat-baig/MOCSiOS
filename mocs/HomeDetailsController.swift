//
//  HomeDetailsController.swift
//  mocs
//
//  Created by Talat Baig on 4/9/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class HomeDetailsController: UIViewController {
    
    var newsData = NewsData()
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var vwInner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.isHidden = true
        vwTopHeader.lblSubTitle.isHidden = true
        
        assignDataToViews()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lastView : UIView! = vwInner.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos + 100
        
        scrlVw.contentSize.height = sizeOfContent
    }
    
    func assignDataToViews() {
        
        let url = URL(string: newsData.imgSrc)
        imgVw.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "home_placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        lblHeading.text = newsData.title
        let newStr = newsData.description.replacingOccurrences(of: "<br>", with: "\n")
        lblDetails.text = Helper.removingRegexMatches(str: newStr, pattern: "<.*?>")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension HomeDetailsController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        //  self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        // self.presentRightMenuViewController(sender as AnyObject)
    }
    
}

