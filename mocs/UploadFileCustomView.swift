//
//  UploadFileCustomView.swift
//  mocs
//
//  Created by Talat Baig on 4/2/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol uploadFileDelegate {
    func uploadFile(data: Data, fileName : String,ext : String, fileDesc : String)
}

class UploadFileCustomView: UIView , UIGestureRecognizerDelegate{
    
    weak var currentTxtFld: UITextField? = nil

    @IBOutlet weak var innerView: CardView!
    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var imgVwFile: UIImageView!
    @IBOutlet weak var txtFileTitle: UITextField!
    @IBOutlet weak var txtFileDesc: UITextField!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var image : UIImage?
    var data : Data?
    var extensn = String()
    var uploadDelegate: uploadFileDelegate?
    var docArray : [VoucherData] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtFileTitle.delegate = self
        txtFileDesc.delegate = self

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
        
        imgVwFile.layer.borderWidth = 0.5
        imgVwFile.layer.masksToBounds = false
        imgVwFile.layer.borderColor = AppColor.universalHeaderColor.cgColor
        imgVwFile.layer.cornerRadius = imgVwFile.frame.height/2
        imgVwFile.clipsToBounds = true
    }
    
    func setImageToView(image : UIImage , docArray : [VoucherData] = [] ) {
        imgVwFile.image = image
        self.docArray = docArray
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        debugPrint("Remove NotificationCenter Deinit")
    }
    
    @IBAction func btnUploadTapped(_ sender: Any) {
     
        guard let fName = txtFileTitle.text else {
            return
        }
        
        if fName == "" {
            Helper.showMessage(message: "Please enter file name")
            return
        }
        
        let docName = docArray.filter { $0.documentName == fName }
      
        if docName.count > 0 {
            Helper.showMessage(message: "File with this name already exists")
            return
        }
        
        if let d = uploadDelegate {
            d.uploadFile(data: data!, fileName: fName, ext : extensn, fileDesc: txtFileDesc.text ?? "" )
            self.removeFromSuperview()
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
  
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
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrlVw.isScrollEnabled = false
        let contentInset:UIEdgeInsets = .zero
        self.scrlVw.contentInset = contentInset
    }
}

extension UploadFileCustomView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        currentTxtFld = textField
        
        switch textField {
            
        case txtFileTitle:
            txtFileDesc.becomeFirstResponder()
            
        case txtFileDesc:
            self.endEditing(true)
            
        default:
            break
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        currentTxtFld = textField
        
        let scrollPoint:CGPoint = CGPoint(x:0, y:textField.frame.size.height +  btnUpload.frame.size.height + 20 )
        scrlVw!.setContentOffset(scrollPoint, animated: true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentTxtFld = nil
    }
    
}




// MARK: - ScrollView delegate methods
extension UploadFileCustomView: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
}
