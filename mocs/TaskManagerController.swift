//
//  TaskManagerController.swift
//  mocs
//
//  Created by Talat Baig on 4/16/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// Task Manager screen
class TaskManagerController: UIViewController {
    
    /// Refresh Control
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    /// Array of object type Task Data
    var arrayList:[TaskData] = []
    var wunderPopup = CustomPopUpView()

    /// Table View
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnWunderlist: UIButton!
    /// Top Header
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        self.navigationController?.isNavigationBarHidden = true
        
        btnWunderlist.layer.borderWidth = 1
        btnWunderlist.layer.borderColor =  AppColor.universalHeaderColor.cgColor
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Task Manager"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Method to show Empty State View
    func showEmptyState(){
        Helper.showNoItemState(vc:self , messg: "List is Empty\nTry to load by tapping below button" , tb:tableView, action:#selector(populateList))
    }
    
    /// Method that calls API to list tasks and populate table view according to API response data
    @objc func populateList(){
        
        if internetStatus != .notReachable {
            
            var data:[TaskData] = []
            self.view.showLoading()
            
            let url:String = String.init(format: Constant.TASK_MANAGER.LIST,Session.email)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv:self.tableView){
                    
                    let responseJson = JSON(response.result.value!)
                    
                    for(_,j):(String,JSON) in responseJson{
                        let newObj = TaskData()
                        newObj.serialId = j["SERIALID"].stringValue
                        newObj.taskName = j["NAME"].stringValue
                        data.append(newObj)
                    }
                    self.arrayList = data
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                } else {
                    self.showEmptyState()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView,action: #selector(populateList))
        }
    }
    
    /// Method to Create task. Calls API for createing new task.
    /// - Parameter name: Name of task as String
    func createTask(name : String) {
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TASK_MANAGER.CREATE_LIST, name, Helper.encodeURL(url: Session.email))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    self.populateList()
                    self.view.makeToast("Task Created")
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    func schemeAvailable(scheme: String) -> Bool {
        if let url = URL(string: scheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(scheme): \(success)")
            })
        }
    }
    
    func openInstallAppPopup() {
        
        self.wunderPopup = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        self.wunderPopup.setDataToCustomView(title: "Wunderlist App Not Found", description: "Download it from App Store?", leftButton: "NO", rightButton: "YES", isTxtVwHidden: true, isApprove: false, isFromEmpDirectory: true)
        self.wunderPopup.wunderDelegate = self
        self.wunderPopup.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.window?.addSubview(self.wunderPopup)
    }
    
    func checkWunderListAppInstalled() {
        
        let wunderList = schemeAvailable(scheme: "wunderlist://")
        
        if wunderList {
            open(scheme: "wunderlist://")
        } else {
            self.openInstallAppPopup()
        }
    }
    
    
    @IBAction func btnWunderlistTapped(_ sender: Any) {
        self.checkWunderListAppInstalled()
    }
    
    /// Action method for button to Add New task 
    @IBAction func addNewTask(_ sender: Any) {
        
        let addTaskAlert = UIAlertController(title: "New Task", message: "Please Enter Task Name", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "ADD", style: .default, handler: { (action) -> Void in
            let textField = addTaskAlert.textFields![0]
            
            guard let taskName = textField.text else {
                return
            }
            self.createTask(name: taskName)
        })
        submitAction.isEnabled = false
        
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: { (action) -> Void in })
        
        addTaskAlert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.placeholder = "Enter Task Name here"
            textField.clearButtonMode = .whileEditing
            
            NotificationCenter.default.addObserver(forName:                UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                submitAction.isEnabled = textField.text!.count > 0
            }
        }
        addTaskAlert.addAction(cancel)
        addTaskAlert.addAction(submitAction)
        
        present(addTaskAlert, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate and Datasource methods
extension TaskManagerController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayList.count > 0{
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell") as! TaskListCell
        cell.setDataToView(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedData = arrayList[indexPath.row]
        let taskDetails = self.storyboard?.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
        taskDetails.taskData = selectedData
        self.navigationController?.pushViewController(taskDetails, animated: true)
    }
    
}

// MARK: - WC_HeaderViewDelegate methods
extension TaskManagerController: WC_HeaderViewDelegate {
    
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

extension TaskManagerController: wunderlistPopupDelegate {

    func onRightBtnTap() {
        let urlStr = "itms-apps://itunes.apple.com/in/app/wunderlist-to-do-list-tasks/id406644151?mt=8"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
        self.wunderPopup.removeFromSuperviewWithAnimate()
    }

}
