//
//  HomeViewController.swift
//  mocs
//
//  Created by Admin on 2/20/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MaterialShowcase

class HomeViewController: UIViewController , filterViewDelegate {
   

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barBtnFilter: UIBarButtonItem!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    var filterTransactionManger = TransitionManager()
    var listArray:[NewsData] = []
    lazy var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshController = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshController)
        FilterViewController.filterDelegate = self
        
        if Session.news == "" {
            populateList()
        } else {
            parseAndAssign(response: Session.news)
        }
//        populateList()
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = "OCS-Home"
        vwTopHeader.lblSubTitle.isHidden = true

        self.title = "OCS-Home"
//        fatalError()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        if Helper.getUserDefaultForBool(forkey: "isAfterLogin") == true {
            self.showCaseFilter()
            Helper.setUserDefault(forkey: "isAfterLogin", valueBool: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        
    }
    
    
    func showCaseFilter() {
        
        let showcase = MaterialShowcase()
        showcase.setTargetView(barButtonItem: barBtnFilter)
        showcase.targetTintColor = UIColor.red
        showcase.targetHolderRadius = 50
        showcase.targetHolderColor = UIColor.white
        showcase.aniComeInDuration = 0.3
        showcase.aniRippleColor = UIColor.white
        showcase.aniRippleAlpha = 0.2
        showcase.primaryText = "FILTER"
        showcase.secondaryText = "You can change/select Filters by tapping on this icon"
        showcase.primaryTextSize = 21
        showcase.secondaryTextSize = 18
        showcase.secondaryTextColor = UIColor.white.withAlphaComponent(0.8)

        showcase.isTapRecognizerForTagretView = false
        // Delegate to handle other action after showcase is dismissed.
        showcase.delegate = self
        showcase.show(completion: {
            // You can save showcase state here
            debugPrint(" complete bar button action")
        })
        
    }
    
    @objc func openMoreVC(sender:UIButton) {
        let buttonRow = sender.tag
        
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailsController") as! HomeDetailsController
        detail.newsData = listArray[buttonRow]
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func cancelFilter(filterString: String) {
        self.populateList()
    }
    
    func applyFilter(filterString: String) {
        self.populateList()
    }
    

    @objc func populateList(){
//        if Session.news == "" {
            if internetStatus != .notReachable {
                let url = String.init(format: Constant.API.NEWS, Session.authKey)
                refreshController.beginRefreshing()
                self.refreshController.beginRefreshing()

                Alamofire.request(url).responseData(completionHandler: { response in
                    self.refreshController.endRefreshing()

                    if Helper.isResponseValid(vc: self, response: response.result,tv: self.tableView){
                        let jsonResponse = JSON(response.result.value!)
                        Session.news = jsonResponse.rawString()!
                        self.parseAndAssign(response: jsonResponse.rawString()!)
                    }
                })
            } else {
                Helper.showNoInternetMessg()
                Helper.showNoInternetState(vc: self, tb: tableView,action: #selector(populateList))
            }
//        } else {
//            parseAndAssign(response: Session.news)
//            self.refreshController.endRefreshing()
//        }
    }
 
    func parseAndAssign(response:String){
        var jsonResponse = JSON.init(parseJSON: response)
        let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
        if jsonArray.count > 0{
            
            self.listArray.removeAll()
            
            for(_,j):(String,JSON) in jsonResponse {
                let data:NewsData = NewsData()
                data.id = j["ID"].stringValue
                data.title = j["Title"].stringValue
                data.description = j["Description"].stringValue
                data.company = j["Company"].stringValue
                data.department = j["Department"].stringValue
                data.imgSrc = j["ImageSRC"].stringValue.replacingOccurrences(of: " ", with: "%20")
                if(data.company == Session.company || data.company == "" || data.company == "00"){
                    listArray.append(data)
                }
            }
            self.tableView.reloadData()
        }else{
            Helper.showMessage(message: "No Latest News Available", style: .info)
        }
    }
}


extension HomeViewController: MaterialShowcaseDelegate {
    func showCaseWillDismiss(showcase: MaterialShowcase) {
        print("Showcase \(showcase.primaryText) will dismiss.")
    }
    func showCaseDidDismiss(showcase: MaterialShowcase) {
       
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = listArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeAdapter
        cell.btnMore.tag = indexPath.row
        cell.btnMore.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cell.btnMore.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.btnMore.layer.shadowOpacity = 1.0
        cell.btnMore.layer.shadowRadius = 1.0
        cell.btnMore.clipsToBounds = true
        cell.btnMore.addTarget(self, action: #selector(self.openMoreVC(sender:)), for: UIControlEvents.touchUpInside)
        cell.setDataToView(data: data)
        return cell
    }
    
}

extension HomeViewController: WC_HeaderViewDelegate {
   
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)

    }
    
}
