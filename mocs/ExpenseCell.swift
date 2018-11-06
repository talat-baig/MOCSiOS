//
//  ExpenseCell.swift
//  mocs
//
//  Created by Admin on 3/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var vendor: UILabel!
    @IBOutlet weak var payment: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var nwOuter: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.shadowOpacity = 0.25
        nwOuter.layer.shadowOffset = CGSize(width: 0, height: 2)
        nwOuter.layer.shadowRadius = 1
        nwOuter.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setDataToView(data:ExpenseListData){
        date.text! = data.expDate
        category.text! = data.expCategory
        vendor.text! = data.expVendor
        comments.text! = data.expComments
        
        if data.expAmount == "" {
            payment.text! = "-"
        } else {
            payment.text! = String.init(format: "%@ %@ by %@", data.expCurrency,data.expAmount,data.expPaymentType)
        }
    }
    
    @IBAction func delete_click(_ sender: Any) {
        
    }
}
