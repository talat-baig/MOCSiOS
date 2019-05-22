//
//  EPBillDetailsController.swift
//  mocs
//
//  Created by Talat Baig on 4/5/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EPBillDetailsController: UIViewController {

    var docRef = ""
    var arrayList = [EPBillDetailData]()
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblSubTitle.isHidden = false
        vwTopHeader.lblTitle.text = ""
        vwTopHeader.lblSubTitle.text = ""
        
        Helper.setupTableView(tableVw : self.tableView, nibName: "EPBillDetailsCell")
        self.populateList()
    }
    
    @objc func populateList() {
        
        var newArr : [EPBillDetailData] = []
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.ExpPresentation.EP_DETAILS, Session.authKey,FilterViewController.getFilterString(), self.docRef )
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResp = JSON(response.result.value!)
                    let arrayJson = jsonResp.arrayObject as! [[String:AnyObject]]
                    
                    if arrayJson.count > 0 {
                        
                        do {
                            // 1
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            // 2
                            newArr = try decoder.decode([EPBillDetailData].self, from: response.result.value!)
                        } catch let error { // 3
                            print("Error creating current newDataObj from JSON because: \(error)")
                        }
                        self.arrayList = newArr
                    }
                    self.tableView.setNeedsLayout()
                    self.tableView.layoutIfNeeded()
                    self.tableView.reloadData()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }

}


// MARK: - UITableViewDataSource methods
extension EPBillDetailsController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EPBillDetailsCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
                if self.arrayList.count > 0 {
                    cell.setDataToView(data: self.arrayList[indexPath.row])
                }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}



// MARK: - WC_HeaderViewDelegate methods
extension EPBillDetailsController: WC_HeaderViewDelegate {
    
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

