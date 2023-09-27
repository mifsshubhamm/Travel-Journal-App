//
//  PrefsUserDefaults.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 23/08/23.
//

import Foundation

class PrefsUserDefaults {
    
    //MARK: Variable
    private let defaults = UserDefaults.standard
    
    var isLogin: Bool {
        get {
            return defaults.bool(forKey: AppFirebaseKeyConstant.isLogin)
        }
        set(newValue) {
            defaults.setValue(newValue, forKey: AppFirebaseKeyConstant.isLogin)
        }
    }
    
    var fullName: String {
        get {
            return defaults.string(forKey: AppFirebaseKeyConstant.fullName) ?? ""
        }
        set(newValue) {
            defaults.setValue(newValue, forKey: AppFirebaseKeyConstant.fullName)
        }
    }
    
    var userName: String? {
        get {
            return defaults.string(forKey: AppFirebaseKeyConstant.userName)
        }
        set(newValue) {
            defaults.setValue(newValue, forKey: AppFirebaseKeyConstant.userName)
        }
    }
    
    var mobileNumber: String? {
        get {
            return defaults.string(forKey: AppFirebaseKeyConstant.mobileNumber)
        }
        set(newValue) {
            defaults.setValue(newValue, forKey: AppFirebaseKeyConstant.mobileNumber)
        }
    }
    
    var email: String? {
        get {
            return defaults.string(forKey: AppFirebaseKeyConstant.email)
        }
        set(newValue) {
            defaults.setValue(newValue, forKey: AppFirebaseKeyConstant.email)
        }
    }
    
    var uid: String? {
        get {
            return defaults.string(forKey: AppFirebaseKeyConstant.uid)
        }
        set(newValue) {
            defaults.setValue(newValue, forKey: AppFirebaseKeyConstant.uid)
        }
    }
    
    func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    class var sharedUserDefaults: PrefsUserDefaults {
        struct Static {
            static let instance = PrefsUserDefaults()
        }
        return Static.instance
    }
}
