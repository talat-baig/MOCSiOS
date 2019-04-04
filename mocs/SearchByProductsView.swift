//
//  SearchByProductsView.swift
//  mocs
//
//  Created by Talat Baig on 12/19/18.
//  Copyright © 2018 Rv. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import SearchTextField


protocol passProductDelegate {
    func sendProductName( prodName : String)
}

class SearchByProductsView : UIView, UIGestureRecognizerDelegate {
    
    var passDelegate : passProductDelegate?

    var prodArr : [String] = []
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var mySearchTextField: SearchTextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = AppColor.univPopUpBckgColor
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.addGestureRecognizer(gestureRecognizer)
        
//        let prod : [String] = ["India","Pakistan","Rice","Wheat","Dal","Grass","Mango","Pulses", "Lentils" , "Spices", "Pear","Apple", "Papaya", "Parrot", "Plum"]
//        mySearchTextField.filterStrings(prod)
        mySearchTextField.filterStrings(self.prodArr)

        mySearchTextField.theme.font = UIFont.systemFont(ofSize: 14)
        mySearchTextField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        mySearchTextField.theme.borderWidth = 1.0
        mySearchTextField.theme.bgColor = UIColor.white
        mySearchTextField.delegate = self
    }
    
    func passArrayToView(prodArr : [String]) {
        self.prodArr = prodArr
        mySearchTextField.filterStrings(self.prodArr)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    /// Action method for Send button. Further calls onSubmitTap method that sends email with Invoice number to given emailIds
    @IBAction func btnSubmitTapped(_ sender: Any) {
      
        guard let prodStr = mySearchTextField.text else {
            return
        }
        
        if let d = passDelegate {
            d.sendProductName(prodName: prodStr)
            self.removeFromSuperviewWithAnimate()
        }
    }
    
    /// Action method for Cancel Button.
    @IBAction func btnCancelTapped(_ sender: Any) {
       
        self.removeFromSuperviewWithAnimate()
    }
 
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.endEditing(true)
    }
    
    /// Invoke before displaying keyboard and used to move view up
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight : CGFloat
            keyboardHeight = keyboardRectangle.height - 60
            var contentInset:UIEdgeInsets = self.scrlVw.contentInset
            contentInset.bottom = keyboardHeight
            
            self.scrlVw.isScrollEnabled = false
            self.scrlVw.contentInset = contentInset
        }
    }
    
    /// Invoke before Hiding keyboard and used to move view up
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrlVw.isScrollEnabled = false
        let contentInset:UIEdgeInsets = .zero
        self.scrlVw.contentInset = contentInset
    }
}

// MARK: - UITextField delegate methods
extension SearchByProductsView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mySearchTextField {
            self.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == mySearchTextField {
            let scrollPoint:CGPoint = CGPoint(x:0, y:textField.frame.size.height +  btnSubmit.frame.size.height + 20 )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
        return true
    }
    
}
