//
//  ErrorUtil.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 25/09/23.
//

import Foundation


enum AppErrorUtil: Error {
    
    case enterFullName
    case enterUserName
    case aUserNameMinimum7CharactersAreReqired
    case enterMobileNumber
    case enterValidMobileNumber
    case enterEmail
    case enterValidEmail
    case enterPassword
    case aMinimum8CharactersPasswordContainsACombinationOfUppercaseAndLowercaseLetterAndNumberAreRequired
    case pleaseEnterConfirmPassword
    case yourPasswordAndConfirmationPasswordDoNotMatch
    case isAgree
    case theUserNameIsAlreadyInUseByAnotherAccount
    case errorAddingDocument
    case theEmailAndPasswordIsWrong
    case selectCoverImage
    case enterTitle
    case selectDate
    case selectLocation
    case selectAtleastPhoto
    case unknown
}


extension AppErrorUtil: LocalizedError {
    
    public var errorDescription: String {
        switch self {
        case .enterFullName:
            return NSLocalizedString(AppStringConstant.pleaseEnterFullName, comment: AppStringConstant.pleaseEnterFullName)
        case .enterUserName:
            return NSLocalizedString(AppStringConstant.pleaseEnterUserName, comment: AppStringConstant.pleaseEnterUserName)
        case .aUserNameMinimum7CharactersAreReqired:
            return NSLocalizedString(AppStringConstant.aUserNameMinimum7CharactersAreReqired, comment: AppStringConstant.aUserNameMinimum7CharactersAreReqired)
        case .enterMobileNumber:
            return NSLocalizedString(AppStringConstant.pleaseEnterMobileNumber, comment: AppStringConstant.pleaseEnterMobileNumber)
        case .enterValidMobileNumber:
            return NSLocalizedString(AppStringConstant.pleaseEnterValidMobileNumber, comment: AppStringConstant.pleaseEnterValidMobileNumber)
        case .enterEmail:
            return NSLocalizedString(AppStringConstant.pleaseEnterEmail, comment: AppStringConstant.pleaseEnterEmail)
        case .enterValidEmail:
            return NSLocalizedString(AppStringConstant.pleaseEnterValidEmail, comment: AppStringConstant.pleaseEnterValidEmail)
        case .enterPassword:
            return NSLocalizedString(AppStringConstant.pleaseEnterPassword, comment: AppStringConstant.pleaseEnterPassword)
        case .aMinimum8CharactersPasswordContainsACombinationOfUppercaseAndLowercaseLetterAndNumberAreRequired:
            return NSLocalizedString(AppStringConstant.AMinimum8CharactersPasswordContainsACombinationOfUppercaseAndLowercaseLetterAndNumberAreRequired, comment: AppStringConstant.AMinimum8CharactersPasswordContainsACombinationOfUppercaseAndLowercaseLetterAndNumberAreRequired)
        case .pleaseEnterConfirmPassword:
            return NSLocalizedString(AppStringConstant.pleaseEnterConfirmPassword, comment: AppStringConstant.pleaseEnterConfirmPassword)
        case .yourPasswordAndConfirmationPasswordDoNotMatch:
            return NSLocalizedString(AppStringConstant.yourPasswordAndConfirmationPasswordDoNotMatch, comment: AppStringConstant.yourPasswordAndConfirmationPasswordDoNotMatch)
        case .isAgree:
            return NSLocalizedString(AppStringConstant.isAgree, comment: AppStringConstant.isAgree)
        case .theUserNameIsAlreadyInUseByAnotherAccount:
            return NSLocalizedString(AppStringConstant.theUserNameIsAlreadyInUseByAnotherAccount, comment: AppStringConstant.theUserNameIsAlreadyInUseByAnotherAccount)
        case .errorAddingDocument:
            return NSLocalizedString(AppStringConstant.errorAddingDocument, comment: AppStringConstant.errorAddingDocument)
        case .theEmailAndPasswordIsWrong:
            return NSLocalizedString(AppStringConstant.theEmailAndPasswordIsWrong, comment: AppStringConstant.theEmailAndPasswordIsWrong)
        case .selectCoverImage:
            return NSLocalizedString(AppStringConstant.pleaseSelectCoverImage, comment: AppStringConstant.pleaseSelectCoverImage)
        case .enterTitle:
            return NSLocalizedString(AppStringConstant.pleaseEnterTitle, comment: AppStringConstant.pleaseEnterTitle)
        case .selectDate:
            return NSLocalizedString(AppStringConstant.pleaseSelectDate, comment: AppStringConstant.pleaseSelectDate)
        case .selectLocation:
            return NSLocalizedString(AppStringConstant.pleaseSelectLocation, comment: AppStringConstant.pleaseSelectLocation)
        case .selectAtleastPhoto:
            return NSLocalizedString(AppStringConstant.pleaseSelectAtleastPhoto, comment: AppStringConstant.pleaseSelectAtleastPhoto)
        case .unknown:
            return NSLocalizedString(AppStringConstant.error, comment: AppStringConstant.error)
        }
    }
}
