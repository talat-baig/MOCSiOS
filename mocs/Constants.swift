//
//  Constants.swift
//  mocs
//
//  Created by Rv on 21/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//

struct ApiKey {
    // LIVE
    static let KEY = "ea138c72-a297-40d4-8e6a-8de6bb3a2a1a"
    
    // UAT
//        static let KEY = "739f9e13-e618-4214-9ffb-d1040609f5c2"
}

struct ApiUrl {
    
    // LIVE
    static let URL = "http://ocsmis.phoenixgroup.net/MOCS_API/api"
    
    // UAT
//        static let URL = "http://172.16.12.12/OCSWebApi/api"
}


struct TaskAuthId {
    /// Authentication Id
    static let KEY = "9f1919491842d0bf2fb46897a81422175275"
}

struct AppColor {
    
    static let universalHeaderColor = UIColor(red:69.0/255.0, green:138.0/255.0, blue:255.0/255.0, alpha:1.0)
    static let universalBodyColor = UIColor(red:37.0/255.0, green:108.0/255.0, blue:230.0/255.0, alpha:1.0)
    static let univPopUpBckgColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    static let univVoucherCell = UIColor(red:69.0/255.0, green:138.0/255.0, blue:255.0/255.0, alpha:0.3)
    static let sideMenuGreen = UIColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
    static let lightGray = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    static let lightestBlue = UIColor(red: 218.0/255.0, green: 231.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    static let scrollVwColor = UIColor(red: 92.0/255.0, green: 94.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    
    static let grayColor = UIColor(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1.0)
    
    static let greenFlag = UIColor(red: 16.0/255.0, green: 155.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    static let amberFlag = UIColor(red: 255.0/255.0, green: 194.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let redFalg = UIColor(red: 239.0/255.0, green: 35.0/255.0, blue: 35.0/255.0, alpha: 1.0)

    
}


struct Constant
{
    
    struct PAHeaderTitle {
        
        static let TRI = "Trade Invoice - Approval"
        static let ARI = "Admin Receive Invoice - Approval"
        static let ECR = "Employee Claims - Approval"
        static let TCR = "Travel Claims - Approval"
        static let DO = "Delivery Orders - Approval"
        static let SC = "Sales Contract - Approval"
        static let PC = "Purchase Contract - Approval"
        static let RO = "Release Order - Approval"
        static let CP = "Counterparty - Approval"
        static let TR = "Travel Request - Approval"
    }
    
    /// Help Document Url link
    struct HelpDoc {
        static let LINK = "http://mobileocs.phoenixgroup.net/Help_iOS.pdf"
    }
    
    /// Modules Initials
    struct MODULES {
        
        static let EPRECR = "Employee Payments And Reimbursments";
        static let TCR = "Travel Claim Reimbursement";
        static let SC = "Sales Contract";
        static let PC = "Purchase Contract";
        static let DO = "Delivery Order";
        static let ARI = "Admin Receive Invoice";
        static let TRI = "Trade Receive Invoice";
        static let TASK_MANAGER = "Task Manager"
        static let CP = "Counterparty Profile"
        static let TT = "Travel Ticket"
    }
    
    struct API {
        
        /// Login API
        static let LOGIN = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_ALogin?apiKey="+ApiKey.KEY+"&ocsun=%@&ocspwd=%@&uuid=%@"
        
        /// News Feed API
        static let NEWS = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCSLP?apiKey="+ApiKey.KEY+"&AuthId=%@"
        
        /// Filter List
        static let FILTER_LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TACApp2?apiKey="+ApiKey.KEY+"&AuthID=%@"
        
        /**
         *TCR Claim List*
         - 1: AuthID
         */
        static let TCR_LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFLAMTCRs?apiKey="+ApiKey.KEY+"&AuthId=%@"
        
        /**
         *Send Email API*
         - 1: AuthID
         - 2: Module Name
         - 3: RefId
         */
        static let SEND_EMAIL = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_SE?apiKey="+ApiKey.KEY+"&AuthID=%@&ModuleName=%@&RefNo=%@"
        
        static let SEND_EMAIL_TCR = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_SE?apiKey="+ApiKey.KEY+"&AuthID=%@&ModuleName=%@&RefNo=%@&TEXCounter=%d"
        
        /**
         *TCR Claim Submit*
         - 1: AuthID
         - 2: RefId
         */
        static let TCR_SUBMIT = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFSTCR?apiKey="+ApiKey.KEY+"&AuthId=%@&TCRRefNo=%@&TEXCounter=%d"
        
        /**
         *TCR Claim Delete*
         - 1: AuthID
         - 2: RefId
         */
        static let TCR_DELETE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFDTCR?apiKey="+ApiKey.KEY+"&AuthId=%@&TCrRefNo=%@&TEXCounter=%d"
        
        /**
         *TCR Claim Update*
         - 1: AuthID
         - 2: RefId
         */
        static let TCR_UPDATE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFUTCR?apiKey="+ApiKey.KEY+"&AuthId=%@&TCRRefNo=%@&TravelType=%@&BusinessPurpose=%@&PlacesVisisted=%@&DateFrom=%@&DateTo=%@&TEXCounter=%d&EPRRef=%@"
        
        
        /**
         *TCR Claim Insert*
         - 1: AuthID
         - 2: RefId
         */
        static let TCR_INSERT = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFITCR?apiKey="+ApiKey.KEY+"&AuthId=%@&TravelType=%@&BusinessPurpose=%@&PlacesVisited=%@&DateFrom=%@&DateTo=%@&EPRRef=%@"
        
        static let EXPENSE_TYPE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFLET?apiKey="+ApiKey.KEY+"&AuthId=%@"
        
        
        static let CURRENCY_TYPE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFLC?apiKey="+ApiKey.KEY+"&AuthId=%@"
        
        
        static let EXPENSE_ADD = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFITCREI?apiKey="+ApiKey.KEY+"&AuthId=%@&TCRRefId=%@&ItemExpenseDate=%@&ItemExpenseCategory=%@&ItemExpenseSubCategory=%@&ItemExpenseVendor=%@&ItemExpensePaymentType=%@&ItemExpenseCurrency=%@&ItemExpenseAmount=%@&ItemExpenseComments=%@&TEXRefCounter=%d"
        
        
        static let EXPENSE_EDIT = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFUTCREItem?apiKey="+ApiKey.KEY+"&AuthId=%@&TCRRefId=%@&ExpenseId=%@&ItemExpenseDate=%@&ItemExpenseCategory=%@&ItemExpenseSubCategory=%@&ItemExpenseVendor=%@&ItemExpensePaymentType=%@&ItemExpenseCurrency=%@&ItemExpenseAmount=%@&ItemExpenseComments=%@&TEXRefCounter=%d"
        
        
        static let EXPENSE_DELETE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFDTCREI?apiKey="+ApiKey.KEY+"&AuthId=%@&TCRRefNo=%@&ExpenseId=%@&TEXCounter=%d"
        
        static let ECR_LIST = ApiUrl.URL + "/ECR/GetECR?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@"
        
        static let ECR_ADD = ApiUrl.URL + "/ECR/AddECRDraft?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&AuthId=%@&chktype=%d"
        
        
        static let ECR_UPDATE =  ApiUrl.URL + "/ECR/UpdateECRDraft?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&counter=%d&reference=%@"
        
        static let ECR_DELETE = ApiUrl.URL + "/ECR/DeleteECR?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&AuthId=%@&EmployeePaymentRequestMainID=%@"
        
        static let ECR_SUBMIT = ApiUrl.URL + "/ECR/SubmitDraftedECR?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&AuthId=%@&EPRMainReferenceID=%@&chktype=%d&EmployeePaymentRequestMainID=%@&EprRefIDCounter=%d"
        
        static let ECR_SEND_EMAIL = ApiUrl.URL + "/ECR/SendECRMail?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&AuthId=%@&emailid=%@&EmployeePaymentRequestMainID=%@&EPRMainReferenceID=%@&EprRefIDCounter=%d"
        
        
        static let ECR_PAYMENT_LIST =  ApiUrl.URL + "/ECR/GetExpenselist?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&referenceid=%@&count=%d"
        
        static let ECR_ADD_PAYMENT =  ApiUrl.URL + "/ECR/AddExpense?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&referenceid=%@&counter=%d"
        
        static let ECR_UPDATE_PAYMENT =  ApiUrl.URL + "/ECR/UpdateExpense?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&EmployeePaymentRequestItemsID=%@"
        
        static let ECR_DELETE_PAYMENT =  ApiUrl.URL + "/ECR/DeleteExpenseItem?delapiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&delauthid=%@&EmployeePaymentRequestItemsID=%@"
        
        static let GET_ACCOUNT_CHARGE =  ApiUrl.URL + "/ECR/GetPaymentReason?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&EPRtype=%d&referenceid=%@"
        
        static let GET_PAYMENT_REASON =  ApiUrl.URL + "/ECR/GetAccountChargeHead?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&EPRtype=%@&type=%@&referenceid=%@"
        
        static let ECR_EPR_ADVANCES =  "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_ECRFLOEPR?apiKey="+ApiKey.KEY+"&AuthId=%@"
        
        
    }
    
    struct AR {
        /**
         *ARI Overall Data*
         - 1: AuthID
         - 2: Filter
         */
        //     static let OVERALL = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_mOCSAROverall?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        static let OVERALL = ApiUrl.URL +  "/AR/GetARReport?apikeylist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&filter=%@"
        
        
        /**
         *ARI Chart*
         - 1: AuthID
         - 2: Filter
         */
        static let CHART = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spm_ShowARTop5?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        /**
         *ARI LIST*
         - 1: AuthID
         - 2: Filter
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_mOCSARCLBU?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        static let CP_LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_mOCSARCLBUC?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@&Company=%@&Location=%@&BV=%@"
        
        static let INSTRUMENTS = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_mOCSARCLBUCI?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@&Company=%@&Location=%@&BV=%@&Counterparty=%@"
        
        static let SEND_EMAIL = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_SCPEmails?apiKey="+ApiKey.KEY+"&AuthId=%@&InvoiceNos=%@&EmailIds=%@"
    }
    
    struct AvlRel {
        
        static let VESSEL_LIST = ApiUrl.URL +  "/AvailableReleaseReport/AvailableReportForVessel?apikeylist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&filter=%@"
        
        static let PRODUCT_LIST = ApiUrl.URL + "/AvailableReleaseReport/AvailableReportForProducts?productlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&filter=%@"
        
        static let WAREHOUSE_LIST = ApiUrl.URL + "/AvailableReleaseReport/AvailableReportForWarehouse?warehouselist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&filter=%@"
        
        static let VESSEL_WISE_PRODUCT_LIST = ApiUrl.URL + "/AvailableReleaseReport/AvailableProductForVessel?apikeyvessel=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&VesselName=%@"
        
        static let PRODUCT_WISE_RO_LIST = ApiUrl.URL + "/AvailableReleaseReport/AvailableROOfProduct?apikeyproduct=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&VesselName=%@&ROProduct=%@"

        static let GET_RO_LIST = ApiUrl.URL + "/AvailableReleaseReport/AvailableROForWarehouse?apikeyroware=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&Warehousename=%@&VesselName=%@&ROProduct=%@&flag=%d"
        
        static let AVL_WHR_FOR_RO = ApiUrl.URL + "/AvailableReleaseReport/AvailableWHROfRO?apikeyRO=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&ROProduct=%@&VesselName=%@&ROReferenceID=%@"
        
        static let WAREHOUSE_WISE_PRODUCT_LIST = ApiUrl.URL + "/AvailableReleaseReport/AvailableProductForWarehouse?apikeyware=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&Warehousename=%@&VesselName=%@"
        
        static let SEND_EMAIL = ApiUrl.URL + "/AvailableReleaseReport/MailAvailableReleaseReport?mailapi=33ddb2ee-59a5-428f-a0a5-7167859b8589&authmail=%@&emailid=%@&ROReferenceID=%@&WHRNo=%@&ManualNo=%@"

//        MailAvailableReleaseReport(string mailapi, string authmail, string emailid, string ROReferenceID, string WHRNo, string ManualNo)

        
    }
    
    
    struct AP {
        
        static let AP_OVERALL = ApiUrl.URL +  "/APReport/GetAPReport?apikeylist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&filter=%@"
        
        static let AP_CHART = ApiUrl.URL + "/APReport/ShowTop5CP?apitop=33ddb2ee-59a5-428f-a0a5-7167859b8589&authtop=%@&filter=%@"
        
        static let CP_LIST = ApiUrl.URL + "/APReport/ShowCounterParty?apicp=33ddb2ee-59a5-428f-a0a5-7167859b8589&authcp=%@&filter=%@&company=%@&location=%@&BV=%@"
        
        static let CP_INVOICE = ApiUrl.URL + "/APReport/ShowCounterPartyInvoice?apicpi=33ddb2ee-59a5-428f-a0a5-7167859b8589&authcpi=%@&filter=%@&company=%@&location=%@&BV=%@&counterparty=%@"
        
        static let SEND_EMAIL =  ApiUrl.URL + "/APReport/MailAPReport?mailapi=33ddb2ee-59a5-428f-a0a5-7167859b8589&authmail=%@&emailid=%@&invoiceno=%@"
        
    }
    
    struct EMPLOYEE {
        /**
         *Get All Employee Directory*
         - 1: AuthID
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_LAE?apiKey="+ApiKey.KEY+"&AuthId=%@"
        
        /**
         *Get Details of Employee*
         - 1: AuthID
         - 2: EmpID
         */
        static let DETAILS = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_VEP?apiKey="+ApiKey.KEY+"&AuthId=%@&EmpId=%@"
    }
    
    struct PC {
        /**
         *List of Purchase Contract*
         - 1: AuthID
         - 2: Filter *(eg. comp+loc+bu)*
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_PCLFA2?apiKey="+ApiKey.KEY+"&AuthId=%@&CompLocnBU=%@"
        
        /**
         *View Purchase Contract*
         - 1: AuthID
         - 2: RefID
         */
        static let VIEW = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_PCSD?apiKey="+ApiKey.KEY+"&AuthId=%@&PCRefNo=%@"
        
        /**
         *Approve Purchase Contract*
         - 1: AuthID
         - 2: RefNo
         - 3: Comment
         */
        static let APPROVE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_PCMAA?apiKey="+ApiKey.KEY+"&AuthId=%@&PCRefNo=%@&Comments=%@"
        
        
        /**
         *Decline Purchase Contract*
         - 1: AuthID
         - 2: RefNo
         - 3: Comment
         */
        static let DECLINE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_PCMAD?apiKey="+ApiKey.KEY+"&AuthId=%@&PCRefNo=%@&DeleteComments=%@"
    }
    
    struct SC {
        
        /**
         *Get List of Sales Contract*
         - 1: AuthID
         - 2: Filter *(eg com+loc+bu)*
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_SCFA2?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        
        /**
         *View Sales Contract*
         - 1: AuthID
         - 2: RefId
         */
        static let VIEW = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_SCSD2?apiKey="+ApiKey.KEY+"&AuthId=%@&SCRefNo=%@"
        
        /**
         *Approve Sales Contract*
         - 1: AuthID
         - 2: RefNo
         */
        static let APPROVE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_SCMAA?apiKey="+ApiKey.KEY+"&AuthId=%@&SCRefNo=%@"
        
        
        /**
         *Decline Sales Contract*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let DECLINE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_SCMAD?apiKey="+ApiKey.KEY+"&AuthId=%@&SCRefNo=%@&DeleteComments=%@"
    }
    
    struct DO {
        /**
         *Get List of Delivery Order*
         - 1: AuthID
         - 2: Filter *(eg Com+loc+bu)*
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_DOLFA2?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        
        /**
         *View Delivery Order*
         - 1: AuthID
         - 2: RefID
         */
        static let VIEW = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_DOSD?apiKey="+ApiKey.KEY+"&AuthId=%@&DORefNo=%@"
        
        
        /**
         *Approve Delivery Order*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let APPROVE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_DOMAA?apiKey="+ApiKey.KEY+"&AuthId=%@&DoRefNo=%@&Comments=%@"
        
        /**
         *Decline Delivery Order*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let DECLINE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_DOMAD?apiKey="+ApiKey.KEY+"&AuthId=%@&DORefNo=%@&Comments=%@"
    }
    
    struct TCR {
        /**
         *Get List of Travel Claim*
         - 1: AuthID
         - 2: Filter *(eg Com+loc+bu)*
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRLFA2?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        
        /**
         *View Travel Claim*
         - 1: AuthID
         - 2: RefNo.
         */
        static let VIEW = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRSD?apiKey="+ApiKey.KEY+"&AuthID=%@&TCRRefNo=%@&TEXCounter=%d"
        
        /**
         *Approve Delivery Order*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let APPROVE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRMAA?apiKey="+ApiKey.KEY+"&AuthId=%@&TCRRefNo=%@&Comments=%@"
        
        /**
         *Decline Delivery Order*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let DECLINE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRMAD?apiKey="+ApiKey.KEY+"&AuthId=%@&TCRRefNo=%@&Comments=%@"
        
        
        static let TCR_EPR_LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TCRFLOEPR?apiKey="+ApiKey.KEY+"&AuthId=%@"
        
    }
    
    struct TRF {
        
        static let TRF_ADD = ApiUrl.URL + "/BusinessTravel/AddBusinessTrip?key=33ddb2ee-59a5-428f-a0a5-7167859b8589&authe=%@&business"
        
        static let TRF_UPDATE = ApiUrl.URL + "/BusinessTravel/UpdateBusinessTravelByID?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&ID=%d&business"
        
        static let TRF_DELETE = ApiUrl.URL + "/BusinessTravel/DeleteBusinessTravel?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&ID=%d"
        
        static let TRF_SUBMIT = ApiUrl.URL + "/BusinessTravel/SubmitBusinessTravel?apisubmit=33ddb2ee-59a5-428f-a0a5-7167859b8589&authsubmit=%@&ID=%d"
        
        static let TRF_SEND_EMAIL = ApiUrl.URL + "/BusinessTravel/BusinessTravelSendMail?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&ID=%d"
        
        static let TRF_LIST = ApiUrl.URL + "/BusinessTravel/GetBusinessTravelListing?apikeylist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@"
        
        static let ITINERARY_LIST = ApiUrl.URL + "/BusinessTravel/GetBusinessItineryListingByID?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&BID=%d"
        
        static let ITINERARY_ADD = ApiUrl.URL + "/BusinessTravel/AddBusinessItinery?addapikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&ID=%d&itinery"
        
        static let ITINERARY_UPDATE = ApiUrl.URL + "/BusinessTravel/UpdateBusinessItineryByID?apiupdate=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&itinID=%@&itinery"
        
        static let ITINERARY_DELETE = ApiUrl.URL + "/BusinessTravel/DeleteBusinessItinery?apideleteitinery=33ddb2ee-59a5-428f-a0a5-7167859b8589&authdelete=%@&ID=%@"
        
        static let TRF_APPROVAL_LIST = ApiUrl.URL + "/BusinessTravel/GetBusinessTravelListingForApproval?apiget=33ddb2ee-59a5-428f-a0a5-7167859b8589&authget=%@"
        
        static let TRF_APPROVE = ApiUrl.URL + "/BusinessTravel/ApproveRejectBusinesstravel?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&ID=%d&check=%d&Reason=%@"
        
    }
    
    struct TT {
        
        static let TT_GET_LIST = ApiUrl.URL + "/TravelTickets/GetTravelTicketListing?apikeylist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@"
        
        static let TT_GET_COMPANY_LIST = ApiUrl.URL + "/TravelTickets/LoadCompanyList?apicomlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&comlistauth=%@&refid=%@"
        
        static let TT_GET_CURRNECY_LIST = ApiUrl.URL + "/TravelTickets/LoadCurrencyList?apicurlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&curlistauth=%@&refid=%@"
        
        static let TT_GET_TRAVELLER_LIST = ApiUrl.URL + "/TravelTickets/LoadTravellerDetails?apitravellist=33ddb2ee-59a5-428f-a0a5-7167859b8589&travellistauth=%@&CompID=%d"
        
        static let TT_GET_REPORTING_MNGR = ApiUrl.URL + "/TravelTickets/FillReportingManager?apifillmanager=33ddb2ee-59a5-428f-a0a5-7167859b8589&authfillmanager=%@&login=%@"
        
        static let TT_GET_TRAVEL_MODES = ApiUrl.URL + "/TravelTickets/LoadTravelModes?apimodelist=33ddb2ee-59a5-428f-a0a5-7167859b8589&modelistauth=%@"
        
        static let TT_GET_DEBIT_AC = ApiUrl.URL + "/TravelTickets/LoadDebitName?apidebitlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&debitlistauth=%@"
        
        static let TT_GET_CARRIER_LIST = ApiUrl.URL + "/TravelTickets/LoadCarrier?apicarrierlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&carrierlistauth=%@"
        
        static let TT_GET_CURRENCY_LIST = ApiUrl.URL + "/TravelTickets/LoadCurrencyList?apicurlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&curlistauth=%@"
        
        static let TT_GET_TRAVEL_AGENT = ApiUrl.URL + "/TravelTickets/LoadTravelAgent?apiagentlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&agentlistauth=%@"
        
        static let TT_GET_EPR_LIST = ApiUrl.URL + "/TravelTickets/LoadEPR?apiEPRlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&EPRlistauth=%@&empid=%@"
        
        static let TT_GET_REP_MNGR_LIST = ApiUrl.URL + "/TravelTickets/LoadReportingManager?apimanagerlist=33ddb2ee-59a5-428f-a0a5-7167859b8589&managerlistauth=%@"
        
        static let TT_GET_ITINRY_LIST = ApiUrl.URL + "/TravelTickets/GetTravelItineryListing?apikeyitilist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authitiid=%@&travelref=%@"
        
        static let TT_DELETE_ITINRY = ApiUrl.URL + "/TravelTickets/DeleteTravelItinery?itiapi=33ddb2ee-59a5-428f-a0a5-7167859b8589&authiti=%@&ID=%d"
        
        static let TT_GET_CITY_LIST = ApiUrl.URL + "/TravelTickets/LoadCity?apicitylist=33ddb2ee-59a5-428f-a0a5-7167859b8589&citylistauth=%@"
        
        static let TT_ADD_TRAVELTICKET = ApiUrl.URL + "/TravelTickets/AddTravelTicket?addapi=33ddb2ee-59a5-428f-a0a5-7167859b8589&addauth=%@&TravelTicket"
        
        static let TT_DELETE_TRAVELTICKET = ApiUrl.URL + "/TravelTickets/DeleteTravelTicket?deltraapi=33ddb2ee-59a5-428f-a0a5-7167859b8589&deltraauth=%@&travellerID=%d"
        
        static let TT_MAIL_TRAVELTICKET = ApiUrl.URL + "/TravelTickets/MailTravelTicket?mailapi=33ddb2ee-59a5-428f-a0a5-7167859b8589&authmail=%@&refID=%@&travellerid=%d"
        
        static let TT_DELETE_VOUCHER = ApiUrl.URL + "/TravelTickets/DeleteTravelItineryVoucher?voapi=33ddb2ee-59a5-428f-a0a5-7167859b8589&authvo=%@&docID=%@"
        
    }
    
    
    struct EPR {
        
        /**
         *Get List of Employee Payment*
         - 1: AuthID
         - 2: Filter *(eg Com+loc+bu)*
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_EPRFA3?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        
        /**
         *View Employee Payment Details*
         - 1: AuthID
         - 2: RefNo.
         */
        static let VIEW = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_EPRSD?apiKey="+ApiKey.KEY+"&AuthId=%@&EPRRefNo=%@"
        
        
        /**
         *Approve Employee Payment*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let APPROVE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_EPRMAA?apiKey="+ApiKey.KEY+"&AuthId=%@&EPRRefNo=%@&Comments=%@"
        
        /**
         *Decline Employee Payment*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let DECLINE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_EPRMAD?apiKey="+ApiKey.KEY+"&AuthId=%@&EPRRefNo=%@&Comments=%@"
        
    }
    
    struct ARI {
        /**
         *Get List of Admin Receive Invoice*
         - 1: AuthID
         - 2: Filter *(eg Com+loc+bu)*
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_ARILFA3?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        /**
         *View ARI Details*
         - 1: AuthID
         - 2: RefId
         */
        static let VIEW = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_APRSD?apiKey="+ApiKey.KEY+"&AuthID=%@&ARIRefNo=%@"
        
        /**
         *Approve Admin Receive Invoice*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let APPROVE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_ARIMAA?apiKey="+ApiKey.KEY+"&AuthId=%@&ARIRefNo=%@&Comments=%@"
        
        /**
         *Decline Admin Receive Invoice*
         - 1: AuthID
         - 2: RefNo.
         - 3: Comment
         */
        static let DECLINE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_ARIMAD?apiKey="+ApiKey.KEY+"&AuthId=%@&ARIRefNo=%@&Comments=%@"
    }
    
    
    struct RO {
        
        //        http://ocsmis.phoenixgroup.net/MOCS_API/api/
        static let LIST = ApiUrl.URL + "/RequestOrder/GetAllRO?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&filter=%@&authid=%@"
        
        static let VIEW = ApiUrl.URL + "/RequestOrder/GetROByID?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&referenceid=%@"
        
        static let CARGO_DETAILS = ApiUrl.URL + "/RequestOrder/GetCargoinfoByRO?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&reference=%@&authid=%@"
        
        static let RRCPT_LIST = ApiUrl.URL + "/RequestOrder/GetCargoinfoByWHR?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&referenceid=%@&guid=%@"
        
        static let ADD_RECEIPT = ApiUrl.URL + "/RequestOrder/SaveROtoWHR?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&emailid=%@"
        
        static let EMAIL_RO = ApiUrl.URL + "/RequestOrder/ROMailSend?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&emailid=%@&referenceid=%@"
    }
    
    
    struct CP {
        
        static let LIST = ApiUrl.URL + "/CounterParty/GetCounterPartyListing?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@"
        
        static let VIEW = ApiUrl.URL + "/CounterParty/GetCounterPartyByID?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CustomID=%@"
        
        
        static let BANK_DETAILS = ApiUrl.URL + "/CounterParty/GetCounterPartyBankDetailsByID?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CustID=%@"
        
        static let REL_DETAILS = ApiUrl.URL + "/CounterParty/GetCounterPartyRelationByID?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CuID=%@"
        
        static let CP_ATTACHMENT = ApiUrl.URL + "/CounterParty/GetAttachmentsByCounterParty?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CPName=%@"
        
        static let CP_KYC_DETAILS = ApiUrl.URL + "/CounterParty/GetCounterPartyKYC?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CustomerID=%@"
        
        static let CP_APPROVE = ApiUrl.URL + "/CPApproval/CheckCPApproved?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CusID=%@&Event=%d&KYCContactType=%@&KYCRequired=%@&REFID=%@"
        
        static let CP_MAIL = ApiUrl.URL + "/CounterParty/SendCPMail?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&CstrID=%@"
        
        
        static let CP_KYC_APPROVE = ApiUrl.URL + "/CounterParty/AppproveKYCbyCP?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&KYCContactType=%@&KYCRequired=%@&KYCValidUntil=%@&ListCheck=%@&attachment=%@&status=%d&REFID=%@&docname=%@&compname=%@&DocumentReferenceNumber=%@"
        
        
        //        AppproveKYCbyCP(string api, string auth, string KYCContactType, string KYCRequired, string KYCValidUntil, string ListCheck, string attachment)
    }
    
    struct TRI {
        /**
         *Get list Trave Receive Invoice*
         - 1: AuthID
         - 2: Filter
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TRILFA3?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
        /**
         *View Trade Receive Invoice Details*
         - 1: AuthID
         - 2: RefId
         */
        static let VIEW = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TRISD?apiKey="+ApiKey.KEY+"&AuthId=%@&TRIRefNo=%@"
        
        /**
         *Approve Trade Invoice*
         - 1: AuthID
         - 2: RefNo
         */
        static let APPROVE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TRIMAA?apiKey="+ApiKey.KEY+"&AuthId=%@&TRIRefNo=%@"
        
        /**
         *Decline Trade Invoice*
         - 1: AuthID
         - 2: RefNo
         */
        static let DECLINE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TRIMAD?apiKey="+ApiKey.KEY+"&AuthId=%@&TRIRefNo=%@"
    }
    
    /**
     *Dropbox Api for List*
     */
    struct DROPBOX {
        //1. AuthID | 2. Module Name | 3. Reference ID
        /**
         *List of Attachment in Dropbox*
         - 1: AuthID
         - 2: Module Name *(eg "TRI","EPR")*
         - 3: RefId
         */
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_LDI?apiKey="+ApiKey.KEY+"&AuthId=%@&DocumentModuleName=%@&DocumentReferenceID=%@"
        
        
        static let CP_LIST = ApiUrl.URL + "/CounterParty/GetAttachmentsByCounterParty?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CPName=%@"
        
//        static let DROPBOX_BASE_PATH =  "/UAT/DOCS"
                static let DROPBOX_BASE_PATH =  "/LIVE/DOCS"
        
        static let ADD_ITEM = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_AITD?apiKey="+ApiKey.KEY+"&AuthId=%@&DocumentModuleName=%@&Company=%@&Location=%@&BusinessUnit=%@&DocumentReferenceID=%@&DocumentName=%@&DocumentDescription=%@&DocumentFilePath=%@"
        
        static let REMOVE_ITEM = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_RDI?apiKey="+ApiKey.KEY+"&AuthId=%@&DocumentID=%@"
        
    }
    
    
    struct TASK_MANAGER {
        
        static let LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TLLists?apiKey="+ApiKey.KEY+"&AuthId="+TaskAuthId.KEY+"&MemberID=%@"
        
        static let CREATE_LIST = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TLAddList?apiKey="+ApiKey.KEY+"&LisName=%@&AuthID="+TaskAuthId.KEY+"&MemberID=%@"
        
        static let LIST_TASK = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TLTasks?apiKey="+ApiKey.KEY+"&AuthId="+TaskAuthId.KEY+"&ListID=%@"
        
        static let CREATE_TASK = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TLAddTask?apiKey="+ApiKey.KEY+"&AuthId="+TaskAuthId.KEY+"&TaskName=%@&ListID=%@&MemberID=%@&DueDate=%@"
        
        static let ADD_NOTE = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TLAppendNote?apiKey="+ApiKey.KEY+"&AuthId="+TaskAuthId.KEY+"&TaskID=%@&MemberID=%@&Note=%@&DueDate=%@"
        
        static let MARK_STAR = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TLSetStar?apiKey="+ApiKey.KEY+"&AuthId="+TaskAuthId.KEY+"&MemberID=%@&StarFlag=%@&TaskID=%@"
        
        static let COMPLETE_TASK = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_TLSetCompleteCancelled?apiKey="+ApiKey.KEY+"&AuthId="+TaskAuthId.KEY+"&MemberID=%@&CompleteCancelledFlag=%@&TaskID=%@&Note=%@"
        
    }
    
}

