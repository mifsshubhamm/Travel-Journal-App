//
//  LoginViewModel.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 23/08/23.
//

import Foundation
import Firebase

class LoginViewModel: NSObject {
    
    //MARK: Variable
    let ref = Database.database().reference()
    
    //MARK: validation
    func validation(_ email: String?, _ password: String?, completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        if(email.isNilorEmpty()) {
            completion(.failure(.enterUserName))
        } else if(password.isNilorEmpty()) {
            completion(.failure(.enterPassword))
        } else{
            completion(.success(true))
        }
    }
    
    //MARK: login
    func login(_ email: String, _ password: String, completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password ) {  authResult, error in
            if(error != nil) {
                completion(.failure(.theEmailAndPasswordIsWrong))
            } else {
                PrefsUserDefaults.sharedUserDefaults.isLogin = true
                PrefsUserDefaults.sharedUserDefaults.uid = authResult?.user.uid ?? ""
                PrefsUserDefaults.sharedUserDefaults.isLogin = true
                self.getUserProfileDataFromFirebase(completion: completion)
            }
        }
    }
    
    //MARK: get User Profile
    func getUserProfileDataFromFirebase(completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        let db = Firestore.firestore()
        
        db.collection("users").document(PrefsUserDefaults.sharedUserDefaults.uid ?? "").getDocument(completion: { (document, error) in
            if  document?.data() != nil {
                let myData = document?.data()
                PrefsUserDefaults.sharedUserDefaults.uid = myData?[AppFirebaseKeyConstant.uid] as? String
                PrefsUserDefaults.sharedUserDefaults.fullName = myData?[AppFirebaseKeyConstant.fullName] as? String ?? ""
                PrefsUserDefaults.sharedUserDefaults.userName = myData?[AppFirebaseKeyConstant.userName] as? String
                PrefsUserDefaults.sharedUserDefaults.mobileNumber = myData?[AppFirebaseKeyConstant.mobileNumber] as? String
                PrefsUserDefaults.sharedUserDefaults.email = myData?[AppFirebaseKeyConstant.email] as? String
                completion(.success(true))
            } else {
                completion(.failure(.errorAddingDocument))
            }
        })
    }
}
