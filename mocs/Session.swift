//
//  Session.swift
//  mocs
//
//  Created by Rv on 21/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//


class Session {
    
    struct Veriable {
        static let LOGIN = "login"
        static let AUTH = "auth"
        static let USER = "user"
        static let EMAIL = "email"
        static let COMPANY = "company"
        static let COMPANYCODE = "compCode"

//        static let PRODUCTS = "products"

        static let LOCATION = "location"
        static let DEPARTMENT = "department"
        static let EMPCODE = "employeeCode"
        static let DESIGNATION = "designation"
        static let REPORTMNGR = "reportingManager"

        static let DBTOKEN = "dbtoken"
        static let CURRENCY = "currency"
        static let EXPCATEGORY = "category"
        static let EXPSUBCATEGORY = "subcategory"
        static let NEWS = "news"
        static let FILTERLIST = "filterlist"
        static let COMPANIES = "companies"
        static let CITIES = "cities"
        static let LEAVETYPES = "leaveTypes"


    }
    
    public static var login: Bool{
        get{
            return UserDefaults.standard.object(forKey: Veriable.LOGIN) as? Bool ?? false
        }
        set(isLogin){
            UserDefaults.standard.set(isLogin, forKey: Veriable.LOGIN)
        }
    }
    
    public static var authKey: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.AUTH) as? String ?? ""
        }
        set(auth){
            UserDefaults.standard.set(auth, forKey: Veriable.AUTH)
        }
    }
    
    public static var user: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.USER) as? String ?? ""
        }
        set(user){
            UserDefaults.standard.set(user, forKey: Veriable.USER)
        }
    }
    
    public static var email: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.EMAIL) as? String ?? ""
        }
        set(email){
            UserDefaults.standard.set(email, forKey: Veriable.EMAIL)
        }
    }
    
    public static var company: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.COMPANY) as? String ?? ""
        }
        set(company){
            UserDefaults.standard.set(company, forKey: Veriable.COMPANY)
        }
    }
    
    public static var compCode: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.COMPANYCODE) as? String ?? ""
        }
        set(compCode){
            UserDefaults.standard.set(compCode, forKey: Veriable.COMPANYCODE)
        }
    }
    
    public static var location: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.LOCATION) as? String ?? ""
        }
        set(location){
            UserDefaults.standard.set(location, forKey: Veriable.LOCATION)
        }
    }
    
    public static var department: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.DEPARTMENT) as? String ?? ""
        }
        set(department){
            UserDefaults.standard.set(department, forKey: Veriable.DEPARTMENT)
        }
    }
    
    public static var dbtoken: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.DBTOKEN) as? String ?? ""
        }
        set(token){
            UserDefaults.standard.set(token, forKey: Veriable.DBTOKEN)
        }
    }
    
    public static var currency: String {
        get{
            return UserDefaults.standard.string(forKey: Veriable.CURRENCY) ?? ""
        }
        set(currency){
            UserDefaults.standard.set(currency, forKey: Veriable.CURRENCY)
        }
    }
    
    public static var category: String {
        get{
            return UserDefaults.standard.string(forKey: Veriable.EXPCATEGORY) ?? ""
        }
        set(category){
            UserDefaults.standard.set(category, forKey: Veriable.EXPCATEGORY)
        }
    }
    
    public static var filterList: String {
        get{
            return UserDefaults.standard.string(forKey: Veriable.FILTERLIST) ?? ""
        }
        set(category){
            UserDefaults.standard.set(category, forKey: Veriable.FILTERLIST)
        }
    }
    
    
    public static var news: String {
        get{
            return UserDefaults.standard.string(forKey: Veriable.NEWS) ?? ""
        }
        set(news){
            UserDefaults.standard.set(news, forKey: Veriable.NEWS)
        }
    }
    
    public static var reportMngr: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.REPORTMNGR) as? String ?? ""
        }
        set(reportMngr){
            UserDefaults.standard.set(reportMngr, forKey: Veriable.REPORTMNGR)
        }
    }
    
    
    public static var designation: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.DESIGNATION) as? String ?? ""
        }
        set(designation){
            UserDefaults.standard.set(designation, forKey: Veriable.DESIGNATION)
        }
    }
    
    
    public static var empCode: String{
        get{
            return UserDefaults.standard.object(forKey: Veriable.EMPCODE) as? String ?? ""
        }
        set(empCode){
            UserDefaults.standard.set(empCode, forKey: Veriable.EMPCODE)
        }
    }
//    let array = ["Hello", "World"]
//    defaults.set(array, forKey: "SavedArray")

    public static var companies: [String] {
        get{
            return UserDefaults.standard.stringArray(forKey: Veriable.COMPANIES) ?? []
        }
        set(companies){
            UserDefaults.standard.set(companies, forKey: Veriable.COMPANIES)
        }
    }
    
    public static var cities: String {
        get{
            return UserDefaults.standard.string(forKey: Veriable.CITIES) ?? ""
        }
        set(cities){
            UserDefaults.standard.set(cities, forKey: Veriable.CITIES)
        }
    }
    
//    public static var companiesList: String {
//        get{
//            return UserDefaults.standard.string(forKey: Veriable.CITIES) ?? ""
//        }
//        set(companiesList){
//            UserDefaults.standard.set(companiesList, forKey: Veriable.CITIES)
//        }
//    }
    
    public static var leaveTypes: String {
        get{
            return UserDefaults.standard.string(forKey: Veriable.LEAVETYPES) ?? ""
        }
        set(leaveTypes){
            UserDefaults.standard.set(leaveTypes, forKey: Veriable.LEAVETYPES)
        }
    }
    
    
//    public static var productList: String{
//        get{
//            return UserDefaults.standard.object(forKey: Veriable.PRODUCTS) as? String ?? ""
//        }
//        set(productList){
//            UserDefaults.standard.set(company, forKey: Veriable.PRODUCTS)
//        }
//    }
}

