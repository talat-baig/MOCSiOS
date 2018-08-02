//
//  EmployeeController.swift
//  mocs
//
//  Created by Admin on 3/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import Contacts
import ContactsUI
import UIKit

import Alamofire
import SwiftyJSON

/// Employee List Screen
class EmployeeController: UIViewController , CNContactViewControllerDelegate , UIGestureRecognizerDelegate, addNewContactDelegate{
    
    /// Employee sections String array
    var empSections : [String] = []
    
    /// Array of Employee data
    var empRows : [EmployeeData] = []
    
    /// Array of String and Employee data
    var empObjectsArr = [String: [EmployeeData]]()
    
    /// Temporary array of String and Employee data
    var tempObjectsArr = [String: [EmployeeData]]()
    
    /// Top Header view
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    /// Search bar
    @IBOutlet weak var srchBar: UISearchBar!
    
    /// Table Veiw
    @IBOutlet weak var tableView: UITableView!
    
    /// Refresh Control
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        UINavigationBar.appearance().barTintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().tintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : AppColor.universalHeaderColor]
        
        self.navigationController?.isNavigationBarHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Employee Directory"
        vwTopHeader.lblSubTitle.isHidden = true
        
        srchBar.delegate = self
        srchBar.enablesReturnKeyAutomatically = true
        populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// Method Opens phone's add new contact screen
    func openAddNewContact(phNo: String) {
        if #available(iOS 9.0, *) {
            let store = CNContactStore()
            let contact = CNMutableContact()
            let homePhone = CNLabeledValue(label: "", value: CNPhoneNumber(stringValue :phNo ))
            contact.phoneNumbers = [homePhone]
            let controller = CNContactViewController(forUnknownContact : contact)
            controller.contactStore = store
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    /// Method that has API call to fetch list of Employee data and Populates table view with the data
    @objc func populateList(){
        
        if internetStatus != .notReachable{
            var data:[EmployeeData] = []
            self.view.showLoading()
            let url:String = String.init(format: Constant.EMPLOYEE.LIST, Session.authKey)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result, tv:self.tableView){
                    let responseJson = JSON(response.result.value!)
                    
                    for(_,j):(String,JSON) in responseJson{
                        let emp = EmployeeData()
                        emp.deskNo = j["DeskNo"].stringValue
                        emp.skypeId = j["SkypeID"].stringValue
                        emp.voIP = j["VoIP"].stringValue
                        emp.whatsApp = j["WhatsApp"].stringValue
                        emp.emailId = j["Email ID"].stringValue
                        emp.id = j["Employee Id"].stringValue
                        
                        let empName = j["Employee Name"].stringValue
                        emp.name = empName.trimmingCharacters(in: .whitespaces)
                        
                        data.append(emp)
                    }
                    
                    data.sort { $0.name < $1.name }
                    
                    let emps = Array(Set(data.compactMap({ $0.name.first })))
                    
                    for emp in emps.map({ String($0) }) {
                        self.empObjectsArr[emp] = data.filter({ $0.name.hasPrefix(emp) })
                        self.tempObjectsArr[emp] = data.filter({ $0.name.hasPrefix(emp) })
                    }
                    
                    self.empSections = [String](self.empObjectsArr.keys)
                    self.empSections = self.empSections.sorted(by: { $0 < $1 })
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
            }))
        }else{
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView,action: #selector(populateList))
        }
    }
    
    /// Method that calls API for fetching Employee Id by passing Employee Id.
    /// - Parameter data: parameter of type EmployeeData
    func getEmployeeDetails(data:EmployeeData){
        if internetStatus != .notReachable{
            self.view.showLoading()
            let url:String = String.init(format: Constant.EMPLOYEE.DETAILS, Session.authKey,data.id)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    if data.id == "" {
                        self.view.makeToast("Details not found")
                    } else {
                        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailsController") as! DetailsController
                        detail.response = response.result.value!
                        detail.empId = data.id
                        self.navigationController?.pushViewController(detail, animated: true)
                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
}

// MARK: - UISearchBar Delegate methods
extension EmployeeController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.empObjectsArr = tempObjectsArr
        } else {
            
            let filteredDictionary = tempObjectsArr.mapValues { $0.filter { $0.name.hasPrefix(searchText) } }.filter { !$0.value.isEmpty }
            self.empObjectsArr = filteredDictionary
        }
        tableView.reloadData()
    }
}

// MARK: - UITableView Delegate, UITableView Datasource and onMoreClickListener  methods
extension EmployeeController: UITableViewDelegate, UITableViewDataSource, onMoreClickListener{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.empSections.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return self.empSections.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let empKey = self.empSections[section]
        if let empValues = empObjectsArr[empKey] {
            return empValues.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmployeeAdapter
        cell.btnMore.tag = indexPath.row
        cell.btnMore.accessibilityIdentifier = String(format: "%d", indexPath.section)
        cell.delegate = self
        cell.selectionStyle = .none
        
        let empkey = empSections[indexPath.section]
        if let empValues = self.empObjectsArr[empkey] {
            let data = empValues[indexPath.row]
            cell.setDataToView(data: data)
        }
        
        return cell
    }
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        self.handleTap()
        let section = Int(sender.accessibilityIdentifier!)
        let indexPath = IndexPath(row: sender.tag, section: section!)
        let cell: EmployeeAdapter = self.tableView.cellForRow(at: indexPath) as! EmployeeAdapter
        cell.addNewCnctDelegate = self
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMore
                
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.handleTap()
        
        let empkey = empSections[indexPath.section]
        if let empValues = self.empObjectsArr[empkey] {
            let data = empValues[indexPath.row]
            self.getEmployeeDetails(data: data)
        }
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return empSections
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return empSections.index(of: title)!
    }
    
}

// MARK: - Header View delegate methods
extension EmployeeController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}

