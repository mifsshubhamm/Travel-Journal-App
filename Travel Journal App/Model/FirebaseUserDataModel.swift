//
//  FirebaseUserDataModel.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 23/08/23.
//

import Foundation

struct FirebaseUserDataModel: Codable  {
    var email : String?
    var uid : String?
    var fullName : String?
    var userName : String?
    var mobileNumber : String?
    var password : String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case userName = "userName"
        case uid = "uid"
        case fullName = "fullName"
        case mobileNumber = "mobileNumber"
    }
}
