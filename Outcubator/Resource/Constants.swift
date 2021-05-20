//
//  Constants.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import Foundation

struct Constants {
    struct Tabbar {
        static let wallet = "Wallet"
        static let scan = "Scan"
        static let profile = "Profile"
    }
    
    struct SignIn {
        static let login = "Log in"
        static let signup = "Sign up"
        static let signIn = "Log In"
        static let useYour = "Use your"
        static let account = "account"
        static let email = "Email"
        static let password = "Password"
        static let fotgotPassword = "I forgot password"
        static let loginFailed = "Log In Failed"
        static let loginFailedMessage = "Please enter your email and password again"
    }
    
    struct SignUp {
        static let createAccount = "Create a Personal Account"
        static let toUse = "to use"
        static let account = "account"
        static let email = "Email"
        static let createPassword = "Create password"
        static let hintPassword = "Password must be at least 8 characters.\nMust include: (1 uppercase, 1 digit, 1 lowercase)"
        static let firstName = "Legal First Name"
        static let lastName = "Legal Last Name"
        static let policyFirst = "I have read and agree to Passport.io User Agreement and Provacy Policy."
        static let policySecond = "I allow FasterPay  to use my Passport.io data"
        static let emailError = "Please enter email again"
        static let firstNameError = "Please enter first name again"
        static let lastNameError = "Please enter last name again"
        static let confirmError = "Please confirm our condition before signing up"
        static let passwordError = "Please enter password again"
    }
    
    struct Wallet {
        static let availabel = "AVAILABLE BALANCE"
        static let topUp = "Top up"
        static let vault = "Vault"
        static let currencies = "Currencies"
    }
    
    struct Payment {
        static let navTitle = "Payment"
        static let paymentErrorTitle = "Make payment failed"
        static let paymentErrorMessage = "Due to the current balance is smaller than the payment amount"
    }
    
    struct TrasactionPopup {
        static let title = "TRANSACTION SUCCESSFUL"
        static let transactionCode = "Transaction code:"
        static let info = "We are sending a copy of all important order information to your email address."
        static let ok = "OK"
    }
    
    struct Transaction {
        static let companies = ["Apple", "Google", "Netflix", "Agoda", "PaymentWall", "Axon", "Techcombank", "Grab", "Gojek", "Traveloka"]
        static let currencies = ["USD", "EUR", "VND"]
    }
    
    struct Profile {
        static let logoutAlertTitle = "Do you want to log out from this app?"
        static let cancel = "Cancel"
        static let confirm = "Confirm"
        static let notifications = "Notifications"
        static let personalInfo = "Personal Information"
        static let term = "Terms of Use"
        static let support = "Help & Support"
        static let security = "Security Settings"
        static let logout = "Logout"
        static let fasterPay = "FasterPay"
        static let passport = "Passport"
    }
}
