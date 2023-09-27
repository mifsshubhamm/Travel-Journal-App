//
//  Constant.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 17/08/23.
//

import Foundation

// MARK: - App Storyborad Constant
struct AppStoryboradConstant {
    static let loginViewController = "LoginViewController"
    static let walkThroughViewController = "WalkThroughViewController"
    static let createAccountViewController = "CreateAccountViewController"
    static let dashboardTabViewController = "DashboardTabViewController"
    static let gMSMapViewController = "GMSMapViewController"
    static let addCoverPhotosAndDetailsViewController = "AddCoverPhotosAndDetailsViewController"
    static let addPhotosAndDetailViewController = "AddPhotosAndDetailViewController"
    static let postDetailsViewController = "PostDetailsViewController"
    static let sortByViewController = "SortByViewController"
    static let profileViewController = "ProfileViewController"
}

// MARK: - App Color Name Constant
struct AppColorConstant {
    static let blueColor = "BlueColor"
    static let colorCACBD2 = "ColorCACBD2"
    static let BlueColor_50 = "BlueColor_50"
    static let ColorCACBD2 = "ColorCACBD2"
}

// MARK: - App Image Name Constant
struct AppImageNameConstant {
    static let check_box = "check_box"
    static let checked_box = "checked_box"
    static let eye_hide = "eye_hide"
    static let eye_show = "eye_show"
    static let plus = "plus.square.dashed"
}

// MARK: - App Value Constant
struct AppValueConstant {
    static let defaultCountryCode = "+91"
    static let googleMapKey = "AIzaSyDIg0quiiSztRFN1GxJOFa4nVUuzXLXkbE"
    static let passwordMaxCount = 24
    static let mobileNumberMaxCount = 10
    
    static let regEx = "\\w{7,18}"
    static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
    
    static let selfMatchesFormat = "SELF MATCHES %@"
    
    static let difficultyList = ["Easy","Medium","Hard"]
}

// MARK: - App String Constant
struct AppStringConstant {
    static let select = "Select"
    static let cancel = "Cancel"
    static let edit = "Edit"
    static let delete = "Delete"
    static let camera = "Camera"
    static let photo = "Photo"
    static let permission_is_not_found = "Permission is not found"
    
    // Create Account Screen
    static let pleaseEnterFullName = "Please enter full name."
    static let pleaseEnterUserName = "Please enter user name."
    static let aUserNameMinimum7CharactersAreReqired = "A user name minimum of 7 characters is required."
    static let pleaseEnterMobileNumber = "Please enter mobile number."
    static let pleaseEnterValidMobileNumber = "Please enter valid mobile number."
    static let pleaseEnterEmail = "Please enter email address."
    static let pleaseEnterValidEmail = "Please enter valid email address."
    static let pleaseEnterPassword = "Please enter password"
    static let pleaseEnterValidPassword = "Please enter valid password"
    static let pleaseEnterConfirmPassword = "Please enter confirm password"
    static let AMinimum8CharactersPasswordContainsACombinationOfUppercaseAndLowercaseLetterAndNumberAreRequired = "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required."
    static let yourPasswordAndConfirmationPasswordDoNotMatch = "Your password and confirmation password do not match."
    static let theUserNameIsAlreadyInUseByAnotherAccount = "The username is already in use by another account."
    static let isAgree = "Please agree the term and condition"
    static let errorAddingDocument = "Error adding document:"
    static let ok = "Ok"
    static let done = "Done"
    static let successfullySignUp = "Successfully Signup"
    static let error = "Error"
    
    // Login Screen
    static let theEmailAndPasswordIsWrong = "The email and password is wrong."
    static let successfullyLogin = "Successfully Login"
    static let postAddedSuccessfully = "Post Added Successfully"
    static let noPostFound = "No Post Found"
    
    //Add Cover Photos And Details
    static let pleaseSelectCoverImage = "Please Select Cover Image"
    static let pleaseEnterTitle = "Please Enter Title"
    static let pleaseSelectDate = "Please Select Date"
    static let pleaseSelectLocation = "Please Select Location"
    static let pleaseEnterDescription = "Please Enter Description"
    static let pleaseSelectAtleastPhoto = "Please Select At Least Photo"
    static let finishDoingthistask = "Finish doing this task"
    
    // Setting Screen
    static let thisScreenNeedMoreWorkItApproachingQuickly = "This screen needs more work. It's approaching quickly."
    
    // Home Screen
    static let areYouSureWantToDelete = "Are you sure want to delete"
    static let postDeleteSuccessfully = "post Delete Successfully"
    
    //Add Cover Photo Screen
    static let postUpdatedSuccessfully = "Post Updated Successfully"
    
    // Profile
    static let profiletUpdatedSuccessfully = "Profile Updated Successfully"
    
}

// MARK: - App Key String Constant
struct AppFirebaseKeyConstant {
    static let email = "email"
    static let userName = "userName"
    static let uid = "uid"
    static let firebaseUID = "firebaseUID"
    static let fullName = "fullName"
    static let mobileNumber = "mobileNumber"
    static let isLogin = "isLogin"
    static let coverImage = "coverImage"
    static let titleMain = "titleMain"
    static let dateMain = "dateMain"
    static let locationMain = "locationMain"
    static let list = "list"
    static let country = "country"
    static let locality = "locality"
    static let subLocality = "subLocality"
    static let thoroughfare = "thoroughfare"
    static let subThoroughfare = "subThoroughfare"
    static let postalCode = "postalCode"
    static let address = "address"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let title = "title"
    static let date = "date"
    static let description = "description"
    static let imagelist = "imagelist"
}

// MARK: - App Key String Constant
struct AppFirebaseConstant {
    static let user = "users"
    static let post = "post"
}

//MARK: AppReuseIdentifier
struct AppReuseIdentifier {
    static let photoCollectionViewCell = "PhotoCollectionViewCell"
    static let homePostCollectionViewCell = "HomePostCollectionViewCell"
    static let homeTableViewCell = "HomeTableViewCell"
    static let postTitleCollectionViewCell = "PostTitleCollectionViewCell"
    static let postPhotoCollectionViewCell = "PostPhotoCollectionViewCell"
    static let customInfoWindow = "CustomInfoWindow"
}
