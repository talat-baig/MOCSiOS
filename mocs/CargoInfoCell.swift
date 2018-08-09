//
//  CargoInfoCell.swift
//  mocs
//
//  Created by Talat Baig on 7/17/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol onCargoMoreClickListener: NSObjectProtocol {
    func onClick(optionMenu:UIViewController, sender : UIButton ) -> Void
}

protocol onCargoOptionIemClickListener: NSObjectProtocol {

    func onCancelClick() -> Void
    func onReceiveClick(sender : UIButton) -> Void
}

class CargoInfoCell: UITableViewCell {
    
    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var vesselName: UILabel!
    
    @IBOutlet weak var whrSrDate: UILabel!
    
    @IBOutlet weak var lblMt: UIStackView!
    @IBOutlet weak var lblWhtTerms: UILabel!
    
    @IBOutlet weak var lblProduct: UILabel!
    
    @IBOutlet weak var lblWHRId: UILabel!
    @IBOutlet weak var lblUom: UILabel!
    @IBOutlet weak var lblBagSize: UILabel!
    
    @IBOutlet weak var lblQuality: UILabel!
    
    @IBOutlet weak var lblQtyRcvd: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    
    @IBOutlet weak var btnMore: UIButton!
    
    weak var menuDelegate : onCargoMoreClickListener?
    weak var optionMenuDelegate : onCargoOptionIemClickListener?
    var data : WHRListData?
    
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwOuter.layer.shadowOpacity = 0.25
        vwOuter.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwOuter.layer.shadowRadius = 1
        vwOuter.layer.shadowColor = UIColor.black.cgColor
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDataToView(data:WHRListData?){

        self.data = data
        vesselName.text = data?.vesselName
        whrSrDate.text = data?.whrDate
        lblQtyRcvd.text = data?.qtyRcvd
        lblUom.text = data?.uom
        lblWhtTerms.text = data?.wtTerms
        lblProduct.text = data?.product
        lblBagSize.text = data?.bagSize
        lblQuality.text = data?.quality
        lblBrand.text = data?.brand
        lblWHRId.text = data?.whrId

    }

    
    @IBAction func moreClick(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)

        let recvAction = UIAlertAction(title: "Receive", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionMenuDelegate?.responds(to: Selector(("onReceiveClick"))) != nil){
                self.optionMenuDelegate?.onReceiveClick(sender: sender)
            }
        })

        optionMenu.addAction(recvAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionMenuDelegate?.responds(to: Selector(("onCancelClick"))) != nil){
                self.optionMenuDelegate?.onCancelClick()
            }
        })
        
//        if sender.tag == 1 {
            optionMenu.addAction(cancelAction)
//        }

        
        if ((menuDelegate?.responds(to: Selector(("onClick:")))) != nil ){
            menuDelegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
        
        
        
        
    }
    
}
