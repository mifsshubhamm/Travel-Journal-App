//
//  ProfileViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 18/08/23.
//

import UIKit
import CountryPicker

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var fullNameOutLet: PaddingTextField!
    @IBOutlet weak var mobileNumberViewOutlet: UIView!
    @IBOutlet weak var mobileNumberOutLet: UITextField!
    @IBOutlet weak var countryCodePicker: UITextField!
    @IBOutlet weak var userNameOutLet: PaddingTextField!
    @IBOutlet weak var emailTextOutlet: PaddingTextField!
    
    //MARK: Variables
    lazy var viewModel = { ProfileViewModel() }()
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar()
    }
    
    //MARK: Action
    @IBAction func updatebutton(_ sender: UIButton) {
        let userData = FirebaseUserDataModel(
            email: emailTextOutlet.text,
            fullName: fullNameOutLet.text,
            userName: userNameOutLet.text,
            mobileNumber: mobileNumberOutLet.text
        )
        
        viewModel.validation(userData: userData) { [self] validationResult in
            switch validationResult {
            case .success(_) :
                viewModel.setProfileData(userData: userData) { result in
                    switch result {
                    case .success(_) :
                        self.singleButtonAlertbox("", AppStringConstant.profiletUpdatedSuccessfully, AppStringConstant.ok ) {
                            self.navigationController?.popViewController(animated: true)
                        }
                        break
                    case .failure(let error) :
                        self.singleButtonAlertbox(AppStringConstant.error, error.errorDescription, AppStringConstant.ok ) {
                            
                        }
                        break
                    }
                }
                break
            case .failure(let error) :
                self.singleButtonAlertbox(AppStringConstant.error, error.errorDescription, AppStringConstant.ok ) {
                    
                }
                break
            }
        }
    }
    
    //MARK: initView
    private func initView() {
        fullNameOutLet.textFieldBackgourndView()
        fullNameOutLet.becomeFirstResponder()
        userNameOutLet.textFieldBackgourndView()
        mobileNumberViewOutlet.textFieldBackgourndView()
        emailTextOutlet.textFieldBackgourndView()
        initKeyborad()
        addDoneButtonOnKeyboard()
        setDataOnUI()
    }
    
    //MARK: set data on ui
    func setDataOnUI() {
        self.fullNameOutLet.text =  PrefsUserDefaults.sharedUserDefaults.fullName
        self.userNameOutLet.text = PrefsUserDefaults.sharedUserDefaults.userName
        self.emailTextOutlet.text = PrefsUserDefaults.sharedUserDefaults.email
        self.mobileNumberOutLet.text = PrefsUserDefaults.sharedUserDefaults.mobileNumber
        initCountryPicker()
    }
    
    //MARK: add done button on keyboard
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.isTranslucent = true
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: AppStringConstant.done, style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.mobileNumberOutLet.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction() {
        self.mobileNumberOutLet.resignFirstResponder()
    }
    
    //MARK: init country picker
    func initCountryPicker() {
        let picker = CountryPicker()
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.selectRow(0, inComponent: 0, animated: true)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(named: AppColorConstant.blueColor)
        toolBar.sizeToFit()
        
        let selectButton = UIBarButtonItem(title: AppStringConstant.select, style: UIBarButtonItem.Style.plain, target: self,  action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: AppStringConstant.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, selectButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        countryCodePicker.inputView = picker
        countryCodePicker.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        countryCodePicker.resignFirstResponder()
        countryCodePicker.text = viewModel.phoneCode
    }
    
    @objc func cancelPicker() {
        countryCodePicker.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    //MARK: Handle the return keyword
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.fullNameOutLet:
            self.userNameOutLet.becomeFirstResponder()
        case self.userNameOutLet:
            self.mobileNumberOutLet.becomeFirstResponder()
        case self.mobileNumberOutLet:
            self.mobileNumberOutLet.resignFirstResponder()
        default:
            self.mobileNumberOutLet.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return switchBasedValidationTextField(textField, range, string)
    }
    
    //MARK: Handle the validation TextField
    private func switchBasedValidationTextField(_ textField: UITextField, _ range: NSRange, _ enterLetter: String) -> Bool {
        switch textField {
        case self.fullNameOutLet:
            return textField.disableNumberKey(enterLetter)
        case self.userNameOutLet, self.emailTextOutlet:
            return textField.disableSpaceKey(enterLetter)
        default:
            return true
        }
    }
}

//MARK: Country Picker Delegate
extension ProfileViewController: CountryPickerDelegate {
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        viewModel.phoneCode = phoneCode
    }
}
