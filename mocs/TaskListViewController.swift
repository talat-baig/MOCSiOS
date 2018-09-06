//
//  TaskListViewController.swift
//  mocs
//
//  Created by Talat Baig on 4/16/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// Task List Screen
class TaskListViewController: UIViewController {
    
    /// Object of type TaskData
    var taskData = TaskData()
    
    /// Array of type TaskDetails object
    var arrayList : [TaskDetails] = []
    
    /// Current/Active Textfield
    weak var currentTxtFld: UITextField? = nil
    
    /// Add Note Alert Controller
    var addNoteAlert = UIAlertController()

    /// Refresh Control
    var refreshControl: UIRefreshControl = UIRefreshControl()

    /// Date Picker
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /// Date Picker Tool
    @IBOutlet var datePickerTool: UIView!
    
    /// Task List Table
    @IBOutlet weak var tableView: UITableView!
    
    /// View for Top Header
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TaskDetailsCell", bundle: nil), forCellReuseIdentifier: "listTaskCell")
        
        self.tableView.register(UINib(nibName: "AddedTaskCell", bundle: nil), forCellReuseIdentifier: "addedTaskCell")
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        
        vwTopHeader.lblTitle.text = "Task"
        vwTopHeader.lblSubTitle.text = taskData.taskName
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
//        tableView.separatorStyle = .none
        populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Method to show Empty State view
    func showEmptyState(){
        Helper.showNoTaskState(vc:self , tb:tableView, action: nil)
    }
    
    /// Tap Action event metho for Add new task button
    @IBAction func addNewTask(_ sender: Any) {
        
        addNoteAlert = UIAlertController(title: "New Task", message: "Please Enter Task Name to add", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "ADD", style: .default, handler: { (action) -> Void in
            let textField1 = self.addNoteAlert.textFields![0]
            let textField2 = self.addNoteAlert.textFields![1]
            
            guard let taskName = textField1.text else {
                return
            }
            guard let dateTxt = textField2.text else {
                return
            }
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let date = dateFormatterGet.date(from: dateTxt)
            let nDate = dateFormatterGet.string(from: date!)
            
            if taskName == "" &&  date == nil{
                Helper.showMessage(message: "Enter Date in proper format")
                return
            } else {
                self.createNewTask(name: taskName, memberId: Session.email, listId: self.taskData.serialId, dueDate: nDate)
            }
        })
        
        
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: { (action) -> Void in })
        
        addNoteAlert.addTextField { (textField: UITextField) in

            textField.keyboardType = .default
            textField.placeholder = "Enter Task Name"
            textField.delegate = self
            textField.clearButtonMode = .whileEditing
        }
        
        
        addNoteAlert.addTextField { (textField: UITextField) in

            textField.placeholder = "Select Date"
            textField.clearButtonMode = .whileEditing
            textField.inputView = self.datePickerTool
            textField.delegate = self
            textField.tag = 111
        }
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.addNoteAlert.textFields![0], queue: OperationQueue.main) { (notification) in
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let someDate = self.addNoteAlert.textFields![1].text
            
            if dateFormatterGet.date(from: someDate!) != nil && self.addNoteAlert.textFields![0].text!.count > 0{
                submitAction.isEnabled = true
            } else {
                submitAction.isEnabled = false
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.addNoteAlert.textFields![1], queue: OperationQueue.main) { (notification) in
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let someDate = self.addNoteAlert.textFields![1].text
            
            if dateFormatterGet.date(from: someDate!) != nil && self.addNoteAlert.textFields![0].text!.count > 0 {
                submitAction.isEnabled = true
            } else {
                submitAction.isEnabled = false
            }
        }
        
        submitAction.isEnabled = false
        
        addNoteAlert.addAction(cancel)
        addNoteAlert.addAction(submitAction)
        present(addNoteAlert, animated: true, completion: nil)
    }
    
    
    /// Create New Task
    /// - Parameters:
    ///    - name: Name as String
    ///    - memberId: Member Id as string
    ///    - listId: list ID as string
    ///    - dueDate: Date as string
    func createNewTask(name : String, memberId : String, listId : String, dueDate : String) {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TASK_MANAGER.CREATE_TASK, name, listId, Helper.encodeURL(url: memberId), dueDate )
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
    
    
    /// Action method for Date Picker tool Done button tap event
    @IBAction func btnDoneTapped(sender:UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if currentTxtFld?.tag == 111 {
            currentTxtFld?.insertText(dateFormatter.string(from: datePicker.date) as String)
        }
        datePickerTool.isHidden = true
        self.addNoteAlert.view.endEditing(true)
    }
    
    /// Action method for Cancel button tap event
    @IBAction func btnCancelTapped(sender:UIButton){
        
        datePickerTool.isHidden = true
        self.addNoteAlert.view.endEditing(true)
    }
    
    /// Method that calls API for List Task and Populates tableview according to Response
    @objc func populateList(){
        
        if internetStatus != .notReachable {
            var newData:[TaskDetails] = []
            self.view.showLoading()
            let url:String = String.init(format: Constant.TASK_MANAGER.LIST_TASK ,taskData.serialId)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result, tv:self.tableView){
                    let responseJson = JSON(response.result.value!)
                    let jsonArray = responseJson.arrayObject as! [[String:AnyObject]]
                    if jsonArray.count > 0 {
                        for(_,j):(String,JSON) in responseJson{
                            let data = TaskDetails()
                            data.serialId = j["SERIALID"].stringValue
                            data.tName = j["NAME"].stringValue
                            data.notes = j["NOTES"].stringValue
                            data.ownerId = j["OWNERID"].stringValue
                            data.dueDate = j["DUEDATE"].stringValue
                            
                            let isTaskComp = j["TASKCOMPLETE"].stringValue
                            let isStar = j["STARFLAG"].stringValue
                            
                            if isTaskComp == "N" {
                                data.taskComplete = false
                            } else {
                                data.taskComplete = true
                            }
                            
                            if isStar == "N" {
                                data.starTask = false
                            } else {
                                data.starTask = true
                            }
                            
                            newData.append(data)
                            let stringArray = data.notes.components(separatedBy: "<br><br>")
                            
                            for newObj in stringArray {
                                
                                let newNote = TaskDetails()
                                newNote.isNote = true
                                newNote.tName = newObj
                                newNote.serialId = data.serialId
                                newData.append(newNote)
                            }
                        }
                        self.arrayList = newData
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    } else {
                        if !self.arrayList.isEmpty {
                            self.arrayList.removeAll()
                        }
                        self.tableView.reloadData()
                        self.showEmptyState()
                    }
                } else {
                    
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView,action: #selector(populateList))
        }
    }
    
    /// Method for Add New Note button action event
    @objc func addNewNoteTapped(sender:UIButton) {
    
        let buttonRow = sender.tag
        
        let addNoteAlert = UIAlertController(title: "Add Note", message: "Please Enter your note", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "ADD", style: .default, handler: { (action) -> Void in
            let textField = addNoteAlert.textFields![0]
            
            guard let noteString = textField.text else {
                return
            }
            self.addNote(note: noteString, task: self.arrayList[buttonRow])
        })
        
        submitAction.isEnabled = false
        
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: { (action) -> Void in })
        
        addNoteAlert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.clearButtonMode = .whileEditing
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                submitAction.isEnabled = textField.text!.count > 0
            }
        }

        addNoteAlert.addAction(cancel)
        addNoteAlert.addAction(submitAction)

        present(addNoteAlert, animated: true, completion: nil)
        
    }
    
    
    /// Star task button action event method. Handles UI and calls another method for marking/Un-marking star task
    @objc func starTaskTapped(sender:UIButton) {
        let buttonRow = sender.tag
        var strFlg = "N"
        var mesg = "Un-Mark Star"
        var messgStr =  "Are you sure you want to un-mark task Star?"
        
        /// If not star
        if !self.arrayList[buttonRow].starTask {
            strFlg = "Y"
            mesg = "Mark Star"
            messgStr = "Are you sure you want to mark this task Star?"
        }
        
        
        let starAlert = UIAlertController(title: mesg, message: messgStr, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            
            self.starTask(starFlag: strFlg, task: self.arrayList[buttonRow])
        })
        
        let cancel = UIAlertAction(title: "NO", style: .destructive, handler: { (action) -> Void in })
        
        starAlert.addAction(cancel)
        starAlert.addAction(yesAction)
        
        present(starAlert, animated: true, completion: nil)
    }
    
   /// Complete task button action event method. Handles UI and calls another method for markin task as complete
    @objc func completeTaskTapped(sender:UIButton) {
        let buttonRow = sender.tag
        var completeFlg = "N"
        
        if !self.arrayList[buttonRow].taskComplete {
            completeFlg = "Y"
        }
        
        let completeTaskAlert = UIAlertController(title: "Task Done?", message: "Please enter Comment", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "DONE", style: .default, handler: { (action) -> Void in
            let textField = completeTaskAlert.textFields![0]
            
            guard let commentString = textField.text else {
                return
            }
            self.completeTask(commentStr: commentString, completedFlg: completeFlg, task: self.arrayList[buttonRow])
        })
        
        submitAction.isEnabled = false
        
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: { (action) -> Void in })
        
        completeTaskAlert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.clearButtonMode = .whileEditing
            textField.placeholder = "Enter Comment here"
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                submitAction.isEnabled = textField.text!.count > 0
            }
        }
        
        completeTaskAlert.addAction(cancel)
        completeTaskAlert.addAction(submitAction)
        
        present(completeTaskAlert, animated: true, completion: nil)
    }
    
    /// Method that calls API to mark the task as complete.
    /// - Parameters:
    ///   - commentStr: Comment text as string
    ///   - completedFlg: Completed flag
    ///   - task: Object of type task details
    func completeTask(commentStr : String, completedFlg : String, task : TaskDetails) {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TASK_MANAGER.COMPLETE_TASK, task.ownerId, completedFlg, task.serialId, commentStr)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: response.result) {
                    self.populateList()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    /// Method that calls API for to star/Un-star a task.
    /// - Parameters:
    ///   - starFlag: String value
    ///   - task: Object of type task details
    func starTask(starFlag : String, task : TaskDetails) {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TASK_MANAGER.MARK_STAR,task.ownerId, starFlag,task.serialId)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    self.populateList()
                }
            }))
        } else {
           Helper.showNoInternetMessg()
        }
    }
    
    /// Method that calls API for adding note
    /// - Parameters:
    ///   - note: String value
    ///   - task: Object of type task details
    func addNote(note : String,task : TaskDetails) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        let newDate = dateFormatter.date(from: task.dueDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let newStr = dateFormatter.string(from: newDate!)
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TASK_MANAGER.ADD_NOTE,task.serialId,task.ownerId, note, newStr)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    self.populateList()
                    //                    self.view.makeToast("Note added")
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
}

// MARK: - UITableView Delegate and Datasource methods
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayList.count > 0{
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else{
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        
        if data.isNote {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addedTaskCell") as! AddedTaskCell
            cell.setDataToViews(task: data)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "listTaskCell") as! TaskDetailsCell
            cell.setDataToViews(task: data)
            cell.btnAddNote.tag = indexPath.row
            cell.btnComplete.tag = indexPath.row
            cell.btnStarNote.tag = indexPath.row
            
            cell.btnAddNote.addTarget(self, action: #selector(self.addNewNoteTapped(sender:)), for: UIControlEvents.touchUpInside)
            cell.btnComplete.addTarget(self, action: #selector(self.completeTaskTapped(sender:)), for: UIControlEvents.touchUpInside)
            cell.btnStarNote.addTarget(self, action: #selector(self.starTaskTapped(sender:)), for: UIControlEvents.touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - UITextField Delegate methods
extension TaskListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        currentTxtFld = textField
        
        if textField.tag == 111  {
            datePickerTool.isHidden = true
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        currentTxtFld = textField
        if textField.tag == 111  {
            datePickerTool.isHidden = false
        }
        return true
    }
    
}

// MARK: - WC_HeaderViewDelegate methods
extension TaskListViewController: WC_HeaderViewDelegate {
    
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
