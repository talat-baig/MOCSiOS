//
//  CustomPopUpView.swift
//  mocs
//
//  Created by Talat Baig on 5/16/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol customPopUpDelegate {
    func onRightBtnTap(data:AnyObject , text : String, isApprove : Bool) -> Void
}

protocol wunderlistPopupDelegate {
    func onRightBtnTap() -> Void
}

class CustomPopUpView: UIView, UIGestureRecognizerDelegate, UITextViewDelegate {
    
    /// text view for comments
    @IBOutlet weak var txtVwComments: UITextView!
    
     /// Left Button
    @IBOutlet weak var btnLeft: UIButton!
    
     /// Right Button
    @IBOutlet weak var btnRight: UIButton!

     /// Image view
    @IBOutlet weak var imgVw: UIImageView!
    
     /// Label for Subtitle
    @IBOutlet weak var lblSubtitle: UILabel!
    
     /// Label for title
    @IBOutlet weak var lblTitle: UILabel!
    
     /// Scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
     /// Delegate object for custom pop-up view
    var cpvDelegate: customPopUpDelegate?
    var wunderDelegate: wunderlistPopupDelegate?
    
    var isFromEmpDirectory = false
    var isWarning = false

    
     /// Object of type AnyObject
    var data : AnyObject?
    
     /// Boolean Flag
    var isApprove = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomPopUpView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomPopUpView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.addGestureRecognizer(gestureRecognizer)
        
        txtVwComments.delegate = self
        
        self.backgroundColor = AppColor.univPopUpBckgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib(nibName: "CustomPopUpView")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        debugPrint("Remove NotificationCenter Deinit")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.endEditing(true)
    }
    
    /// Invoked before keyboard will show
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight : CGFloat
            keyboardHeight = keyboardRectangle.height
            var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardHeight
            
            self.scrollView.isScrollEnabled = false
            self.scrollView.contentInset = contentInset
        }
    }
    
    /// Invoked before keyboard will hide
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.isScrollEnabled = false
        let contentInset:UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInset
    }
    
    /// Action method for left button tapped
    @IBAction func btnLeftTapped(_ sender: Any) {
        self.removeFromSuperviewWithAnimate()
    }
    
    /// Action method for right button tapped
    @IBAction func btnRightTapped(_ sender: Any) {
        
        if isFromEmpDirectory {
            
            if let d = wunderDelegate {
               
                d.onRightBtnTap()
            }
        } else if isWarning {
            self.removeFromSuperviewWithAnimate()
        } else {
            
            if let d = cpvDelegate {
                var comment = ""
                
                if !txtVwComments.isHidden {
                    comment = txtVwComments.text
                }
                d.onRightBtnTap(data: data! , text : comment , isApprove: isApprove)
            }
        }
    }
    
    /// Set data passed from view controller to custom pop-up view UI elements
    /// - Parameters:
    ///   - title: Pop-up title
    ///   - description: Pop-up subtitle text or description text
    ///   - leftButton: Left button text
    ///   - rightButton: Right button text
    ///   - isTxtVwHidden: Bool Flag to know if text view is hidden or not
    ///   - isApprove: Bool flag to know if pop-up is for Approve or Decline
    func setDataToCustomView(title: String, description: String, leftButton: String = "", rightButton: String = "" ,isTxtVwHidden : Bool  = false , isApprove : Bool = true ,  isFromEmpDirectory : Bool = false , isWarning : Bool = false, isOkButton : Bool = false) {
        
        self.lblTitle.text = title
        self.lblSubtitle.text = description
        
        if isOkButton {
            self.btnRight.setTitle(rightButton,for: .normal)
            self.btnLeft.isHidden = true
        } else {
            self.btnLeft.setTitle(leftButton,for: .normal)
            self.btnRight.setTitle(rightButton,for: .normal)
        }
        
        self.isApprove = isApprove
        self.isFromEmpDirectory = isFromEmpDirectory
        self.isWarning = isWarning

        if isFromEmpDirectory {
            imgVw.image = UIImage(named: "wunderlist")
        } else if isWarning {
            imgVw.image = UIImage(named: "warning")
        } else {
            imgVw.image = UIImage(named: "approve_questn")
        }
        
        
        
        if isTxtVwHidden {
            txtVwComments.isHidden = true
            
        } else {
            txtVwComments.isHidden = false
            self.txtVwComments.textColor = UIColor.lightGray
            
            if isApprove {
                self.txtVwComments.text = "Enter Comment (Optional)"
            } else {
                self.txtVwComments.text = "Enter Comment"
            }
        }
    }
    
 // MARK: - UITextView Delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        let scrollPoint:CGPoint = CGPoint(x:0, y:textView.frame.size.height +  btnLeft.frame.size.height + 20 )
        scrollView!.setContentOffset(scrollPoint, animated: true)
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
        
            if isApprove {
                self.txtVwComments.text = "Enter Comment"
            } else {
                self.txtVwComments.text = "Enter Comment"
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
}

// MARK: - UIScrollViewDelegate Method to disable scroll for user
extension CustomPopUpView: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
}
