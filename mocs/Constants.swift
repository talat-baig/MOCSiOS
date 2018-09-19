//
//  Constants.swift
//  mocs
//
//  Created by Rv on 21/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//

struct ApiKey {
    // LIVE
    //        static let KEY = "ea138c72-a297-40d4-8e6a-8de6bb3a2a1a"
    
    // UAT
    static let KEY = "739f9e13-e618-4214-9ffb-d1040609f5c2"
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
        
        static let ECR_LIST = "http://172.16.12.12/OCSWebApi/api/ECR/GetECR?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@"
        
        static let ECR_ADD = "http://172.16.12.12/OCSWebApi/api/ECR/AddECRDraft?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&AuthId=%@&chktype=%d"
        
        
        static let ECR_UPDATE =  "http://172.16.12.12/OCSWebApi/api/ECR/UpdateECRDraft?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&counter=%d&reference=%@"
        
        static let ECR_DELETE = "http://172.16.12.12/OCSWebApi/api/ECR/DeleteECR?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&AuthId=%@&EmployeePaymentRequestMainID=%@"
        
        static let ECR_SUBMIT = "http://172.16.12.12/OCSWebApi/api/ECR/SubmitDraftedECR?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&AuthId=%@&EPRMainReferenceID=%@&chktype=%d&EmployeePaymentRequestMainID=%@&EprRefIDCounter=%d"
        
        static let ECR_SEND_EMAIL = "http://172.16.12.12/OCSWebApi/api/ECR/SendECRMail?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&AuthId=%@&emailid=%@&EmployeePaymentRequestMainID=%@&EPRMainReferenceID=%@&EprRefIDCounter=%d"
        
        
        static let ECR_PAYMENT_LIST =  "http://172.16.12.12/OCSWebApi/api/ECR/GetExpenselist?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&referenceid=%@&count=%d"
        
        static let ECR_ADD_PAYMENT =  "http://172.16.12.12/OCSWebApi/api/ECR/AddExpense?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&referenceid=%@&counter=%d"
        
        static let ECR_UPDATE_PAYMENT =  "http://172.16.12.12/OCSWebApi/api/ECR/UpdateExpense?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&EmployeePaymentRequestItemsID=%@"
        
        static let GET_ACCOUNT_CHARGE =  "http://172.16.12.12/OCSWebApi/api/ECR/GetPaymentReason?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&EPRtype=%d&referenceid="
        
        static let GET_PAYMENT_REASON =  "http://172.16.12.12/OCSWebApi/api/ECR/GetAccountChargeHead?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&EPRtype=%@&type=%@&referenceid="
        
        static let ECR_EPR_ADVANCES =  "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_ECRFLOEPR?apiKey="+ApiKey.KEY+"&AuthId=%@"
        
        
        
        //        https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_ECRFLOEPR?apiKey=739f9e13-e618-4214-9ffb-d1040609f5c2&AuthId=CAD1266B-90CD-408D-8039-98BF38A0
    }
    
    struct AR {
        /**
         *ARI Overall Data*
         - 1: AuthID
         - 2: Filter
         */
        static let OVERALL = "https://api.appery.io/rest/1/apiexpress/api/ocsapicall/spmOCS_mOCSAROverall?apiKey="+ApiKey.KEY+"&AuthId=%@&Filter=%@"
        
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
        
        
        static let TRF_ADD = "http://172.16.12.12/OCSWebApi/api/BusinessTravel/AddBusinessTrip?key=33ddb2ee-59a5-428f-a0a5-7167859b8589&authe=%@&business"

        static let TRF_LIST = "http://172.16.12.12/OCSWebApi/api/BusinessTravel/GetBusinessTravelListing?apikeylist=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@"

        static let ITINERARY_LIST = "http://172.16.12.12/OCSWebApi/api/BusinessTravel/GetBusinessItineryListingByID?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&BID=%d"

        static let ITINERARY_ADD = "http://172.16.12.12/OCSWebApi/api/BusinessTravel/AddBusinessItinery?addapikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&ID=%d&itinery"

        
        
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
        
        //        http://172.16.12.12/OCSWebApi/api/
        static let LIST = "http://172.16.12.12/OCSWebApi/api/RequestOrder/GetAllRO?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&filter=%@&authid=%@"
        
        static let VIEW = "http://172.16.12.12/OCSWebApi/api/RequestOrder/GetROByID?apikey=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&referenceid=%@"
        
        static let CARGO_DETAILS = "http://172.16.12.12/OCSWebApi/api/RequestOrder/GetCargoinfoByRO?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&reference=%@&authid=%@"
        
        static let RRCPT_LIST = "http://172.16.12.12/OCSWebApi/api/RequestOrder/GetCargoinfoByWHR?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&referenceid=%@&guid=%@"
        
        static let ADD_RECEIPT = "http://172.16.12.12/OCSWebApi/api/RequestOrder/SaveROtoWHR?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&emailid=%@"
        
        static let EMAIL_RO = "http://172.16.12.12/OCSWebApi/api/RequestOrder/ROMailSend?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&emailid=%@&referenceid=%@"
    }
    
    
    struct CP {
        
        //        http://172.16.12.12/OCSWebApi/api/
        
        static let LIST = "http://172.16.12.12/OCSWebApi/api/CounterParty/GetCounterPartyListing?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@"
        
        //        static let LIST = "http://172.16.12.12/OCSWebApi/api/CounterParty/GetCounterPartyListing?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@"
        
        static let VIEW = "http://172.16.12.12/OCSWebApi/api/CounterParty/GetCounterPartyByID?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CustomID=%@"
        
        static let BANK_DETAILS = "http://172.16.12.12/OCSWebApi/api/CounterParty/GetCounterPartyBankDetailsByID?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CustID=%@"
        
        static let REL_DETAILS = "http://172.16.12.12/OCSWebApi/api/CounterParty/GetCounterPartyRelationByID?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CuID=%@"
        
        static let CP_ATTACHMENT = "http://172.16.12.12/OCSWebApi/api/CounterParty/GetAttachmentsByCounterParty?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CPName=%@"
        
        static let CP_KYC_DETAILS = "http://172.16.12.12/OCSWebApi/api/CounterParty/GetCounterPartyKYC?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CustomerID=%@"
        
        static let CP_APPROVE = "http://172.16.12.12/OCSWebApi/api/CPApproval/CheckCPApproved?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CusID=%@&Event=%d&KYCContactType=%@&KYCRequired=%@&REFID=%@"
        
        static let CP_MAIL = "http://172.16.12.12/OCSWebApi/api/CounterParty/SendCPMail?apiky=33ddb2ee-59a5-428f-a0a5-7167859b8589&authid=%@&CstrID=%@"
     
        
        static let CP_KYC_APPROVE = "http://172.16.12.12/OCSWebApi/api/CounterParty/AppproveKYCbyCP?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&KYCContactType=%@&KYCRequired=%@&KYCValidUntil=%@&ListCheck=%@&attachment=%@&status=%d&REFID=%@&docname=%@&compname=%@&DocumentReferenceNumber=%@"

//        http://172.16.12.12/OCSWebApi/api/CounterParty/AppproveKYCbyCP?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=DA58F943-A1B5-45F5-AB99-D0B8106A&KYCContactType=Trade&KYCRequired=Yes&KYCValidUntil=2018-09-12&ListCheck=No&attachment=&status=0&REFID=9125&docname=&compname=My%20New%20Counterparty&DocumentReferenceNumber=12-Sep-2018
        
        
        
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
        
        
        static let CP_LIST = "http://172.16.12.12/OCSWebApi/api/CounterParty/GetAttachmentsByCounterParty?api=33ddb2ee-59a5-428f-a0a5-7167859b8589&auth=%@&CPName=%@"
        
         static let DROPBOX_BASE_PATH =  "/UAT/DOCS"
//        static let DROPBOX_BASE_PATH =  "/LIVE/DOCS"
        
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

