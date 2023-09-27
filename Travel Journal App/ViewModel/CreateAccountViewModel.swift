//
//  CreateAccountViewModel.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 23/08/23.
//

import Foundation
import Firebase

class CreateAccountViewModel: NSObject {
    
    //MARK: Variables
    private let ref = Database.database().reference()
    var isAgree = false
    var phoneCode = AppValueConstant.defaultCountryCode
    
    //MARK: validation
    func validation(userData: FirebaseUserDataModel, confrimPassword: String?, isAgree: Bool, completion: @escaping (Result<Bool, AppErrorUtil>) -> ()){
        if(userData.fullName.isNilorEmpty()) {
            completion(.failure(AppErrorUtil.enterFullName))
        } else if(userData.userName.isNilorEmpty()) {
            completion(.failure(AppErrorUtil.enterUserName))
        } else if(!userData.userName.isValidUserName()) {
            completion(.failure(AppErrorUtil.aUserNameMinimum7CharactersAreReqired))
        } else if(userData.mobileNumber.isNilorEmpty()) {
            completion(.failure(AppErrorUtil.enterMobileNumber))
        }  else if(!userData.mobileNumber.isValidMobileNumber()) {
            completion(.failure(AppErrorUtil.enterValidMobileNumber))
        } else if(userData.email.isNilorEmpty()) {
            completion(.failure(AppErrorUtil.enterEmail))
        } else if(!userData.email.isValidEmail()) {
            completion(.failure(AppErrorUtil.enterValidEmail))
        } else if(userData.password.isNilorEmpty()) {
            completion(.failure(AppErrorUtil.enterPassword))
        } else if(!userData.password.isValidPassword()) {
            completion(.failure(AppErrorUtil.aMinimum8CharactersPasswordContainsACombinationOfUppercaseAndLowercaseLetterAndNumberAreRequired))
        }  else if(confrimPassword.isNilorEmpty()) {
            completion(.failure(AppErrorUtil.pleaseEnterConfirmPassword))
        } else if(confrimPassword != userData.password) {
            completion(.failure(AppErrorUtil.yourPasswordAndConfirmationPasswordDoNotMatch))
        } else if(!isAgree) {
            completion(.failure(AppErrorUtil.isAgree))
        } else {
            completion(.success(true))
        }
    }
    
    //MARK: createUser
    func createUser(userData: FirebaseUserDataModel ,completion: @escaping (Result<Bool, AppErrorUtil>) -> ()) {
        Auth.auth().createUser(withEmail: userData.email ?? "", password: userData.password ?? "") { authResult, error in
            if(error != nil) {
                completion(.failure(.theUserNameIsAlreadyInUseByAnotherAccount))
            } else {
                let db = Firestore.firestore()
                let mData =  [
                    AppFirebaseKeyConstant.fullName: userData.fullName,
                    AppFirebaseKeyConstant.userName: userData.userName,
                    AppFirebaseKeyConstant.mobileNumber: userData.mobileNumber,
                    AppFirebaseKeyConstant.email: userData.email,
                    AppFirebaseKeyConstant.uid: authResult?.user.uid,
                ]
                db.collection(AppFirebaseConstant.user).document(authResult?.user.uid ?? "").setData(mData as [String : Any]) { err in
                    if err != nil {
                        completion(.failure(.errorAddingDocument))
                    } else {
                        PrefsUserDefaults.sharedUserDefaults.uid = authResult?.user.uid ?? ""
                        PrefsUserDefaults.sharedUserDefaults.fullName = userData.fullName ?? ""
                        PrefsUserDefaults.sharedUserDefaults.mobileNumber = userData.mobileNumber
                        PrefsUserDefaults.sharedUserDefaults.userName = userData.userName
                        PrefsUserDefaults.sharedUserDefaults.email = userData.email
                        completion(.success(true))
                    }
                }
            }
        }
    }
}
