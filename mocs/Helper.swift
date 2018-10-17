//
//  Helper.swift
//  mocs
//
//  Created by Rv on 22/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//
import SwiftyJSON
import Alamofire
import Toast_Swift
import SystemConfiguration
import Lottie
import NotificationBannerSwift
import RATreeView

/// Cardview
@IBDesignable

class CardView: UIView {
    
    var cornerRadius: CGFloat = 2
    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 3
    var shadowColor: UIColor? = UIColor.white
    var shadowOpacity: Float = 1
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.masksToBounds = true
    }
}


extension UINavigationBar {
    
    var castShadow : String {
        get { return "anything fake" }
        set {
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 3.0
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.7
            
        }
    }
    
}

class GlobalVariables : NSObject {
    
    private override init() {}
    
    static let shared = GlobalVariables()
    
    /// For Voucher Upload
    var isUploadingSomething = Bool()
    
    var uploadQueue : [FileInfo] = []
    
    
    
}

class Helper: UIView {
    
    public static func setTitle(title:String, subtitle:String) -> UIView {
        
        
        let titleLabel = UILabel.init(frame: CGRect.zero)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subTitleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 22, width: 0, height: 0))
        subTitleLabel.backgroundColor = UIColor.clear
        subTitleLabel.textColor = UIColor.white
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.text = subtitle
        subTitleLabel.sizeToFit()
        
        let twoLineTitleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width:max(titleLabel.frame.size.width, subTitleLabel.frame.size.width), height: 30))
        twoLineTitleView.addSubview(titleLabel)
        twoLineTitleView.addSubview(subTitleLabel)
        
        
        return twoLineTitleView
    }
    
    
    class func setUserDefault(forkey: String, valueString: String = "", valueBool: Bool = false, valueInt: Int = -1) {
        let nsUserDefaults = UserDefaults.standard
        
        // For Boolean
        if (valueString == "" && valueInt == -1) {
            nsUserDefaults.set(valueBool, forKey: forkey)
        }
        
        // For string
        if (valueString != "") {
            nsUserDefaults.set(valueString, forKey: forkey)
        }
        
        // For integer
        if (valueInt != -1) {
            nsUserDefaults.set(valueInt, forKey: forkey)
        }
        nsUserDefaults.synchronize()
    }
    
    
    class func getUserDefaultForBool(forkey: String) -> Bool {
        if self.isKeyPresentInUserDefaults(key: forkey) {
            return UserDefaults.standard.bool(forKey: forkey)
        }
        return false
    }
    
    class func getUserDefaultForInt(forkey: String) -> Int {
        if self.isKeyPresentInUserDefaults(key: forkey) {
            return UserDefaults.standard.integer(forKey: forkey)
        }
        return -1
    }
    
    
    class func getUserDefaultForString(forkey: String) -> String {
        if self.isKeyPresentInUserDefaults(key: forkey) {
            return UserDefaults.standard.string(forKey: forkey)!
        }
        return ""
    }
    
    class func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    class func addBordersToView(view : UIView){
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true;
    }
    
    
    class func daysBetweenDates(startDate: Date, endDate: Date) -> Int {

        let components =  Calendar.current.dateComponents([.day], from: startDate, to: endDate).day
        return components!
    }
    
    public static func isPostResponseValid(vc: UIViewController, response : Result<String>, tv:UITableView? = nil)-> Bool{
        
        var isValid: Bool = false
        
        switch response {
        case .success:
            let jsonResponse = JSON.init(parseJSON: response.value!)
            debugPrint("Response",jsonResponse)
            if jsonResponse.dictionaryObject != nil {
                
                let data = jsonResponse.dictionaryObject
                
                if data != nil {
                    
                    if (data?.count)! > 0 {
                        
                        switch data!["ServerMsg"] as! String {
                        case "Success":
                            isValid = true
                            break
                            
                            
                        default:
                            isValid = false
                            Helper.showMessage(message: data!["ServerMsg"] as! String , style: .danger)
                            break
                        }
                    } else {
                        isValid = true
                    }
                }
                
            } else {
                NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again by reloading", style:.info).show()
            }
            
            break
        case .failure(let error):
            if error._code == NSURLErrorTimedOut{
                isValid = false
                NotificationBanner(title: "Timeout",subtitle:"Request taking time too long, Check your connection and please try again", style: .warning).show()
                if tv != nil{
                    showNoInternetState(vc: vc, tb: tv!, action: nil)
                }
            } else if error._code == -1009 {
                Helper.showNoInternetMessg()
            } else {
                NotificationBanner(title: "Opps!",subtitle:"Unexpected error occurred, Please try again later", style: .warning).show()
            }
            break
        }
        return isValid
    }
    
    
    
    public static func isResponseValid(vc: UIViewController, response:Result<Data>, tv:UITableView? = nil)-> Bool{
        var isValid: Bool = false
        
        switch response {
        case .success:
            let jsonResponse = JSON(response.value!)
            debugPrint("Response",jsonResponse)
            if jsonResponse.arrayObject is [[String:AnyObject]]{
                let data = jsonResponse.arrayObject as! [[String:AnyObject]]
                if data.count > 0 { 
                    for(_,j):(String,JSON) in jsonResponse {
                        switch j["ServerMsg"] != JSON.null ? j["ServerMsg"].stringValue : "" {
                        case "Success":
                            isValid = true
                            break
                        case "":
                            isValid = true
                            break
                        case "Authenication Failed":
                            isValid = false
                            let alert = UIAlertController(title: "Session Expired", message: "You'll be redirect to login page, Please Login again to continue", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                                Helper.clearSession()
                                if FilterViewController.selectedDataObj.count != 0 {
                                    FilterViewController.selectedDataObj.removeAll()
                                }
                                
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                                let mainPage: UIViewController = storyBoard.instantiateViewController(withIdentifier: "loginController")
                                vc.present(mainPage,animated: true,completion: nil)
                            }))
                            vc.present(alert, animated: true, completion: nil)
                            break
                        case "A Secured Link has been sent to your official email. Kindly click on the link to approve the device. The link valid for next 30 mins":
                            let alert = UIAlertController(title:"Not Authenticated!",message:"A Secured Link has been sent to your official email. Kindly click on the link to approve the device. The link valid for next 30 Mins",preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
                                
                            }))
                            vc.present(alert, animated: true, completion: nil)
                            break
                            
                        case "Email Sent...","Success. Please click on List Vouchers", "New List Added","New Task Added" ,"Note Updated" , "Purchase Contract marked as declined","Sales Contract marked as declined","ARI marked as declined", "ARI marked as approved","TRI marked as approved","TRI marked as declined","TCR marked as Declined","TCR marked as Approved","EPR | ECR marked as Declined","EPR | ECR claim marked as Approved","DO marked as Approved","DO marked as Declined":
                            isValid = true
                            break
                            
                        default:
                            isValid = false
                            NotificationBanner(title: j["ServerMsg"].stringValue,style: .danger).show()
                        }
                    }
                }else{
                    isValid = true
                }
            } else {
                NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again by reloading", style:.info).show()
            }
            break
        case .failure(let error):
            if error._code == NSURLErrorTimedOut{
                isValid = false
                NotificationBanner(title: "Timeout",subtitle:"Request taking time too long, Check your connection and please try again", style: .warning).show()
                if tv != nil{
                    showNoInternetState(vc: vc, tb: tv!, action: nil)
                }
            } else if error._code == -1009 {
                Helper.showNoInternetMessg()
            } else {
                NotificationBanner(title: "Opps!",subtitle:"Unexpected error occurred, Please try again later", style: .warning).show()
            }
            break
        }
        return isValid
    }
    
    public static func showLoading(vc:UIViewController){
        vc.view.showLoading()
    }
    
    public static func hideLoading(vc:UIViewController){
        vc.view.hideLoading()
    }
    
    public static func encodeURL(url:String) -> String{
        //return url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        //return String(utf8String: url.cString(using: String.Encoding.utf8)!)!
        
        let str = CFURLCreateStringByAddingPercentEscapes(
            nil,
            url.trimmingCharacters(in: .whitespaces) as CFString,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString,
            CFStringBuiltInEncodings.UTF8.rawValue
        )
        return str! as String
    }
    
    public static func encodeLocString(url: String) -> String {
        
        let newStr = url.replacingOccurrences(of: " ", with: "+")
        
        return newStr
    }
    
    
    public static func encodeWhiteSpaces(url: String) -> String {
        
        let newStr = url.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return newStr
    }
    
    
    public static func showNoInternetMessg() {
        Helper.showMessage(message: "Internet not reachable, Please Try Again")
    }
    
    
    public static func showMessage(message:String, style:BannerStyle? = nil ){
        if style == nil{
            NotificationBanner(title: message,style:.danger).show()
        } else {
            NotificationBanner(title: message,style:style!).show()
        }
    }
    
    public static func showVUMessage(message:String, success: Bool) {
        if success {
            NotificationBanner(title: message,style:.success).show()
        } else {
            NotificationBanner(title: message,style:.danger).show()
        }
    }
    
    public static func showNoFilterState(vc:UIViewController, tb:UITableView, isTrvReq : Bool = false , isARReport : Bool = false, action:Selector){
        
        let emptyView = EmptyState()
        emptyView.image = UIImage(named: "no_result")!
        
        
        if isARReport {
            emptyView.message = "No AR Data for the current\nTry by changing filter"
        } else if isTrvReq {
            emptyView.message = "No Travel Request Data found \nTry by again by relaoding"
        } else {
            emptyView.message = "No Pending Approval Data for the current\nTry by changing filter"
        }
        
        
        if isTrvReq {
            emptyView.buttonText = "RELOAD"
        } else {
            emptyView.buttonText = "CHANGE FILTER"
        }
        emptyView.button.addTarget(vc, action: action, for: .touchUpInside)
        tb.tableFooterView = emptyView
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        emptyView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        emptyView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.6).isActive = true
        emptyView.heightAnchor.constraint(equalTo: vc.view.heightAnchor, multiplier: 0.55).isActive = true
    }
    
    
    public static func isFileExists(fileName : String) -> Bool {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                debugPrint("FILE AVAILABLE")
                return true
            } else {
                debugPrint("FILE NOT AVAILABLE")
                return false
            }
        } else {
            debugPrint("FILE PATH NOT AVAILABLE")
            return false
        }
    }
    
    
    public static func showNoInternetStateTreeVw(vc:UIViewController, treeVw:RATreeView, action:Selector? = nil) {
        
        let emptyView = EmptyState()
        emptyView.image = UIImage(named: "no_wifi")!
        if (action != nil){
            emptyView.message = "Opps! Seems you're not connected\nPlease check your connection"
            emptyView.button.isHidden = false
            emptyView.buttonText = "TRY AGAIN"
            emptyView.button.addTarget(vc, action: action!, for: .touchUpInside)
        }else{
            emptyView.message = "Opps! Seems you're not connected\nPlease Swipe Down to Try Again"
            emptyView.button.isHidden = true
        }
        treeVw.treeFooterView = emptyView
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        emptyView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        emptyView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.6).isActive = true
        emptyView.heightAnchor.constraint(equalTo: vc.view.heightAnchor, multiplier: 0.55).isActive = true
        
    }
    
    public static func showNoInternetState(vc:UIViewController, tb:UITableView, action:Selector? = nil) {
        
        let emptyView = EmptyState()
        emptyView.image = UIImage(named: "no_wifi")!
        if (action != nil){
            emptyView.message = "Opps! Seems you're not connected\nPlease check your connection"
            emptyView.button.isHidden = false
            emptyView.buttonText = "TRY AGAIN"
            emptyView.button.addTarget(vc, action: action!, for: .touchUpInside)
        }else{
            emptyView.message = "Opps! Seems you're not connected\nPlease Swipe Down to Try Again"
            emptyView.button.isHidden = true
        }
        tb.tableFooterView = emptyView
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        emptyView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        emptyView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.6).isActive = true
        emptyView.heightAnchor.constraint(equalTo: vc.view.heightAnchor, multiplier: 0.55).isActive = true
        
    }
    
    public static func showNoItemState(vc:UIViewController, messg: String = "" , tb:UITableView, action:Selector? = nil) -> Void{
        let emptyView = EmptyState()
        emptyView.image = UIImage(named: "empty_box")!
        if action != nil{
            emptyView.message = messg
            emptyView.button.isHidden = false
            emptyView.buttonText = "LOAD ITEM"
            emptyView.button.addTarget(vc, action: action!, for: .touchUpInside)
        }else{
            emptyView.message = messg
            emptyView.button.isHidden = true
        }
        tb.tableFooterView = emptyView
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        emptyView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        emptyView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.6).isActive = true
        emptyView.heightAnchor.constraint(equalTo: vc.view.heightAnchor, multiplier: 0.55).isActive = true
    }
    
    public static func showNoTaskState(vc:UIViewController, tb:UITableView, action:Selector? = nil) -> Void{
        let emptyView = EmptyState()
        emptyView.image = UIImage(named: "no_task")!
        if action != nil{
            emptyView.message = "You have no task to do! Add task by tapping on add button"
            emptyView.button.isHidden = false
            emptyView.buttonText = "LOAD ITEM"
            emptyView.button.addTarget(vc, action: action!, for: .touchUpInside)
        }else{
            emptyView.message = "You have no task to do! Add task by tapping on add button"
            emptyView.button.isHidden = true
        }
        tb.tableFooterView = emptyView
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        emptyView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        emptyView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.6).isActive = true
        emptyView.heightAnchor.constraint(equalTo: vc.view.heightAnchor, multiplier: 0.55).isActive = true
    }
    
    
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PurchaseContractController.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
        return refreshControl
    }()
    
    public static func attachRefreshControl(vc:UIViewController, action:Selector) -> UIRefreshControl{
        let refreshControl:UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(vc, action:action, for: .valueChanged)
            refreshControl.tintColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
            return refreshControl
        }()
        return refreshControl
    }
    
    public static func clearSession(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
    }
    
    public func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            
            let results = regex.matches(in: text,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
            
        } catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            
            return []
        }}
    
    public static func removingRegexMatches(str : String, pattern:String, replaceWith:String = "") -> String {
        var newStr = ""
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSMakeRange(0, str.count)
            newStr = regex.stringByReplacingMatches(in: str, options: [], range: range, withTemplate: replaceWith)
        }catch{
            
        }
        return newStr
    }
    
    public static func convertToDateFormat2(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone =  TimeZone(abbreviation: "GMT+0:00")
        let serverDate: Date = dateFormatter.date(from: dateString)! // according to date format your date string
        return serverDate
    }
    
    
    public static func convertToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let serverDate: Date = dateFormatter.date(from: dateString)! // according to date format your date string
        return serverDate
    }
    
    public static func getPathFromDirectory(directoryName:String = "", savedFileName : String, ext : String = "") -> URL {
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var pathString = savedFileName
        
        if directoryName != "" {
            pathString = directoryName + "/" + savedFileName
        }
        let newPath =  documentsPath.appendingPathComponent(pathString).appendingPathExtension(ext)
        return newPath
    }
    
    
    
    
    public static func getModifiedPath( path : String) -> String {
        
        var newPath = path
        
        if path.contains(Constant.DROPBOX.DROPBOX_BASE_PATH) {
            newPath = path.replacingOccurrences(of: "\\", with: "/", options: .literal, range: nil)
        } else {
            newPath = Constant.DROPBOX.DROPBOX_BASE_PATH + path.replacingOccurrences(of: "\\", with: "/", options: .literal, range: nil)
        }
        return newPath
    }
    
    public static func getOCSFriendlyaPath(path:String) -> String {
        if path.contains(Constant.DROPBOX.DROPBOX_BASE_PATH){
            return path.replacingOccurrences(of: Constant.DROPBOX.DROPBOX_BASE_PATH, with: "")
        }
        return path
    }
    
    
    public static func getImage(ext : String) -> UIImage? {
        
        var selectedImg = UIImage()
        
        switch ext {
        case "pdf": selectedImg = #imageLiteral(resourceName: "pdf")
            break
        case "png", "JPG" , "jpg":  selectedImg = #imageLiteral(resourceName: "imageIcon")
            break
        case "txt", "xlsx", ".docx" , ".rtf" : selectedImg = #imageLiteral(resourceName: "file")
            break
        default:
            break
        }
        return selectedImg
    }
    
    
    
    public static func getDataFromFileUrl(fileUrl: URL) -> Data? {
        
        var pData = Data()
        do {
            let fileData = try Data.init(contentsOf: fileUrl)
            pData = fileData
        } catch {
            print(error)
        }
        return pData
    }
    
    
    
    public static func parseAndAssignCurrency() -> [String] {
        
        let jsonObj = JSON.init(parseJSON:Session.currency)
        var currArr = [String]()
        
        for(_,j):(String,JSON) in jsonObj{
            let newCurr = j["Currency"].stringValue
            currArr.append(newCurr)
        }
        return currArr
    }
    
    public static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
protocol Utility {
    
}

extension NSObject:Utility{
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var internetStatus: ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
}

//extension UITextView: UITextViewDelegate {
//
//    /// Resize the placeholder when the UITextView bounds change
//    override open var bounds: CGRect {
//        didSet {
//            self.resizePlaceholder()
//        }
//    }
//
//    /// The UITextView placeholder text
//    public var placeholder: String? {
//        get {
//            var placeholderText: String?
//
//            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//                placeholderText = placeholderLabel.text
//            }
//
//            return placeholderText
//        }
//        set {
//            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
//                placeholderLabel.text = newValue
//                placeholderLabel.sizeToFit()
//            } else {
//                self.addPlaceholder(newValue!)
//            }
//        }
//    }
//
//    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
//    ///
//    /// - Parameter textView: The UITextView that got updated
//    public func textViewDidChange(_ textView: UITextView) {
//        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//            placeholderLabel.isHidden = self.text.count > 0
//        }
//    }
//
//    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
//    private func resizePlaceholder() {
//        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
//            let labelX = self.textContainer.lineFragmentPadding
//            let labelY = self.textContainerInset.top - 2
//            let labelWidth = self.frame.width - (labelX * 2)
//            let labelHeight = placeholderLabel.frame.height
//
//            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
//        }
//    }
//
//    /// Adds a placeholder UILabel to this UITextView
//    private func addPlaceholder(_ placeholderText: String) {
//        let placeholderLabel = UILabel()
//
//        placeholderLabel.text = placeholderText
//        placeholderLabel.sizeToFit()
//
//        placeholderLabel.font = self.font
//        placeholderLabel.textColor = UIColor.lightGray
//        placeholderLabel.tag = 100
//
//        placeholderLabel.isHidden = self.text.count > 0
//
//        self.addSubview(placeholderLabel)
//        self.resizePlaceholder()
//        self.delegate = self
//    }
//
//}

extension UIView{
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    func removeFromSuperviewWithAnimate(_ animationDuration: TimeInterval = 0.15) {
        
        UIView.transition(with: self, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            
        }) { (success) in
            if (success) {
                self.removeFromSuperview()
            }
        }
    }
    
    /// Load view from view name
    ///
    /// - Parameters:
    ///   - nibName: Passing view name
    ///   - isAnimated: Passing true if need animation
    func loadViewFromNib(nibName: String, isAnimated: Bool = true) {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        if isAnimated {
            self.showAnimate()
        }
    }
    
    func addMySubview(_ view: UIView, isAnimated: Bool = true, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: leading)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: trailing)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: top)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: bottom)
        
        self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        
        if isAnimated {
            self.showAnimate()
        }
    }
    
    /// Animate the view while adding in superview with cross dissolve
    ///
    /// - Parameter animationDuration: Passing animation duration
    @objc func showAnimate(_ animationDuration: TimeInterval = 0.25) {
        
        UIView.transition(with: self, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            
        }) { (success) in
        }
    }
    
    func showLoading(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let animationView = LOTAnimationView(name: "ocs_loading")
        animationView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)
        animationView.loopAnimation = true
        animationView.play()
        
        blurEffectView.contentView.addSubview(animationView)
        animationView.center = blurEffectView.contentView.center
        
        self.addSubview(blurEffectView)
    }
    
    func hideLoading(){
        
        self.subviews.flatMap {  $0 as? UIVisualEffectView }.forEach {
            $0.removeFromSuperview()
        }
    }
    
    
}


extension String{
    mutating func removingRegexMatches(pattern:String,replaceWith:String = ""){
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSMakeRange(0, self.count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        }catch{
            return
        }
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    /// Check if it is valid email address
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var fullRange:Range<String.Index> { return startIndex..<endIndex }
    
}

