//
//  ProfileViewModel.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 01/09/23.
//

import Foundation
import Firebase

class ProfileViewModel: NSObject {
    
    //MARK: Variables
    private let db = Firestore.firestore()
    var phoneCode = AppValueConstant.defaultCountryCode
    
    //MARK: validation
    func validation(userData: FirebaseUserDataModel, completion: @escaping (Result<Bool,AppErrorUtil>) -> ()){
        if(userData.fullName.isNilorEmpty()) {
            completion(.failure(.enterFullName))
        } else if(userData.userName.isNilorEmpty()) {
            completion(.failure(.enterUserName))
        } else if(!userData.userName.isValidUserName()) {
            completion(.failure(.aUserNameMinimum7CharactersAreReqired))
        } else if(userData.mobileNumber.isNilorEmpty()) {
            completion(.failure(.enterMobileNumber))
        }  else if(!userData.mobileNumber.isValidMobileNumber()) {
            completion(.failure(.enterValidMobileNumber))
        } else if(userData.email.isNilorEmpty()) {
            completion(.failure(.enterEmail))
        } else if(!userData.email.isValidEmail()) {
            completion(.failure(.enterValidEmail))
        } else {
            completion(.success(true))
        }
    }
    
    //MARK: set Profile Data
    func setProfileData(userData: FirebaseUserDataModel, completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        let mData =  [
            AppFirebaseKeyConstant.fullName: userData.fullName,
            AppFirebaseKeyConstant.userName: userData.userName,
            AppFirebaseKeyConstant.mobileNumber: userData.mobileNumber,
            AppFirebaseKeyConstant.email: userData.email,
            AppFirebaseKeyConstant.uid: PrefsUserDefaults.sharedUserDefaults.uid ?? "",
        ]
        db.collection(AppFirebaseConstant.user).document(PrefsUserDefaults.sharedUserDefaults.uid ?? "").setData(mData as [String : Any]) { err in
            
            if let err = err {
                completion(.failure(.errorAddingDocument))
            } else {
                PrefsUserDefaults.sharedUserDefaults.fullName = userData.fullName ?? ""
                PrefsUserDefaults.sharedUserDefaults.mobileNumber = userData.mobileNumber
                PrefsUserDefaults.sharedUserDefaults.userName = userData.userName
                PrefsUserDefaults.sharedUserDefaults.email = userData.email
                completion(.success(true))
            }
        }
    }
}
