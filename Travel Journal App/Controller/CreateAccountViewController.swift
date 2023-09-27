//
//  CreateAccountViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 18/08/23.
//

import UIKit
import CountryPicker

class CreateAccountViewController: UIViewController, UITextFieldDelegate  {
    
    //MARK: Outlet
    @IBOutlet weak var fullNameOutlet: PaddingTextField!
    @IBOutlet weak var userNameOutlet: PaddingTextField!
    @IBOutlet weak var countryCodeOutlet: UITextField!
    @IBOutlet weak var mobileNumberViewOutlet: UIView!
    @IBOutlet weak var mobileNumberOutlet: UITextField!
    @IBOutlet weak var emailOutlet: PaddingTextField!
    @IBOutlet weak var passwordViewOutlet: UIView!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordEyeOutlet: UIButton!
    @IBOutlet weak var confirmPasswordViewOutlet: UIView!
    @IBOutlet weak var confirmPasswordOutlet: UITextField!
    @IBOutlet weak var confirmEyeOutlet: UIButton!
    @IBOutlet weak var agreeOutlet: UIButton!
    
    //MARK: Variable
    lazy var viewModel = { CreateAccountViewModel() }()
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    //MARK: Action
    @IBAction func passwordEyeButtton(_ sender: UIButton) {
        if passwordOutlet.isSecureTextEntry {
            passwordEyeOutlet.setImage(UIImage(named: AppImageNameConstant.eye_hide), for: .normal)
            passwordOutlet.isSecureTextEntry = false
        } else {
            passwordEyeOutlet.setImage(UIImage(named: AppImageNameConstant.eye_show), for: .normal)
            passwordOutlet.isSecureTextEntry = true
        }
    }
    
    @IBAction func confirmPasswordEyebutton(_ sender: UIButton) {
        if confirmPasswordOutlet.isSecureTextEntry {
            confirmEyeOutlet.setImage(UIImage(named: AppImageNameConstant.eye_hide), for: .normal)
            confirmPasswordOutlet.isSecureTextEntry = false
        } else {
            confirmEyeOutlet.setImage(UIImage(named: AppImageNameConstant.eye_show), for: .normal)
            confirmPasswordOutlet.isSecureTextEntry = true
        }
    }
    
    @IBAction func agreeButton(_ sender: UIButton) {
        if viewModel.isAgree {
            agreeOutlet.setImage(UIImage(named: AppImageNameConstant.check_box), for: .normal)
            viewModel.isAgree = false
        } else {
            agreeOutlet.setImage(UIImage(named: AppImageNameConstant.checked_box), for: .normal)
            viewModel.isAgree = true
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        signUpOnFirebase()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: init
    func initView() {
        fullNameOutlet.textFieldBackgourndView()
        fullNameOutlet.becomeFirstResponder()
        userNameOutlet.textFieldBackgourndView()
        mobileNumberViewOutlet.textFieldBackgourndView()
        emailOutlet.textFieldBackgourndView()
        passwordViewOutlet.textFieldBackgourndView()
        confirmPasswordViewOutlet.textFieldBackgourndView()
        initCountryPicker()
        initKeyborad()
        addDoneButtonOnKeyboard()
    }
    
    //MARK: Done Action
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
        
        self.mobileNumberOutlet.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction() {
        self.emailOutlet.becomeFirstResponder()
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
        countryCodeOutlet.inputView = picker
        countryCodeOutlet.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        countryCodeOutlet.resignFirstResponder()
        countryCodeOutlet.text = viewModel.phoneCode
    }
    
    @objc func cancelPicker() {
        countryCodeOutlet.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    //MARK: Handle the return keyword
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.fullNameOutlet:
            self.userNameOutlet.becomeFirstResponder()
        case self.userNameOutlet:
            self.mobileNumberOutlet.becomeFirstResponder()
        case self.mobileNumberOutlet:
            self.emailOutlet.becomeFirstResponder()
        case self.emailOutlet:
            self.passwordOutlet.becomeFirstResponder()
        case self.passwordOutlet:
            self.confirmPasswordOutlet.becomeFirstResponder()
        case self.confirmPasswordOutlet:
            self.confirmPasswordOutlet.resignFirstResponder()
        default:
            self.confirmPasswordOutlet.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return switchBasedValidationTextField(textField, range, string)
    }
    
    //MARK: Handle the validation TextField
    private func switchBasedValidationTextField(_ textField: UITextField, _ range: NSRange, _ enterLetter: String) -> Bool {
        switch textField {
        case self.fullNameOutlet:
            return textField.disableNumberKey(enterLetter)
        case self.userNameOutlet, self.emailOutlet:
            return textField.disableSpaceKey(enterLetter)
        case self.passwordOutlet, self.confirmPasswordOutlet:
            return textField.passwordMaxLength(enterLetter, range) && textField.disableSpaceKey(enterLetter)
        default:
            return true
        }
    }
    
    //MARK: signup
    func signUpOnFirebase() {
        startIndicatingActivity()
        let userData = FirebaseUserDataModel(
            email: emailOutlet.text,
            fullName: fullNameOutlet.text,
            userName: userNameOutlet.text,
            mobileNumber: mobileNumberOutlet.text,
            password: passwordOutlet.text
        )
        viewModel.validation(userData: userData, confrimPassword: confirmPasswordOutlet.text, isAgree: viewModel.isAgree) { [self] result in
            switch result {
            case .success(_):
                viewModel.createUser(userData: userData) { result in
                    self.stopIndicatingActivity()
                    switch result {
                    case .success(_):
                        self.singleButtonAlertbox("", AppStringConstant.successfullySignUp, AppStringConstant.ok ){
                            PrefsUserDefaults.sharedUserDefaults.isLogin = true
                            self.goToDashboardTabViewController()
                        }
                        break
                    case .failure(let error):
                        self.singleButtonAlertbox(AppStringConstant.error, error.errorDescription, AppStringConstant.ok ) {
                        }
                        break
                    }
                }
                break
            case .failure(let error):
                self.stopIndicatingActivity()
                self.singleButtonAlertbox(AppStringConstant.error, error.errorDescription, AppStringConstant.ok ) {
                }
                break
            }
        }
    }
    
    //MARK: dashboard tab viewcontroller
    func goToDashboardTabViewController() {
        guard let dashboardTabViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.dashboardTabViewController) as? DashboardTabViewController  else { return }
        self.navigationController?.pushViewController(dashboardTabViewController, animated: true)
    }
}

//MARK: Country Picker Delegate
extension CreateAccountViewController: CountryPickerDelegate {
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        viewModel.phoneCode = phoneCode
    }
}
