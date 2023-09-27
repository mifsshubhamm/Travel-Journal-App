//
//  LoginViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 17/08/23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    //MARK: outlet
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordEyeOutlet: UIButton!
    
    //MARK: Variables
    lazy var viewModel = { LoginViewModel() }()
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    //MARK: Action
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        underdeveloped()
    }
    
    @IBAction func passwordEyeButton(_ sender: UIButton) {
        if passwordOutlet.isSecureTextEntry {
            passwordEyeOutlet.setImage(UIImage(named: AppImageNameConstant.eye_hide), for: .normal)
            passwordOutlet.isSecureTextEntry = false
        } else {
            passwordEyeOutlet.setImage(UIImage(named: AppImageNameConstant.eye_show), for: .normal)
            passwordOutlet.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        viewModel.validation(emailTextFieldOutlet.text, passwordOutlet.text) { result in
            switch result {
            case .success(_) :
                self.signInOnFirebase()
                break
            case .failure(let error) :
                self.singleButtonAlertbox(AppStringConstant.error, error.errorDescription, AppStringConstant.ok ) {
                }
                break
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        goToCreateAccountScreen()
    }
    
    //MARK: initview
    func initView() {
        emailTextFieldOutlet.textFieldBackgourndView()
        passwordView.textFieldBackgourndView()
        emailTextFieldOutlet.becomeFirstResponder()
        initKeyborad()
    }
    
    //MARK: sign in
    private func signInOnFirebase() {
        startIndicatingActivity()
        viewModel.login(emailTextFieldOutlet.text ?? "", passwordOutlet.text ?? "") { result in
            self.stopIndicatingActivity()
            switch result {
            case .success(_) :
                self.singleButtonAlertbox("", AppStringConstant.successfullyLogin, AppStringConstant.ok ){
                    PrefsUserDefaults.sharedUserDefaults.isLogin = true
                    self.goToDashboardTabViewController()
                }
                break
            case .failure(let error) :
                self.singleButtonAlertbox(AppStringConstant.error, error.errorDescription, AppStringConstant.ok ) {
                }
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    //MARK: Handle the return keyword
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.emailTextFieldOutlet:
            self.passwordOutlet.becomeFirstResponder()
        case self.passwordOutlet:
            self.passwordOutlet.resignFirstResponder()
        default:
            self.passwordOutlet.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return switchBasedValidationTextField(textField, range, string)
    }
    
    //MARK: Handle the validation TextField
    private func switchBasedValidationTextField(_ textField: UITextField, _ range: NSRange, _ enterLetter: String) -> Bool {
        switch textField {
        case self.emailTextFieldOutlet:
            return textField.disableSpaceKey(enterLetter)
        case self.passwordOutlet:
            return textField.passwordMaxLength(enterLetter, range) && textField.disableSpaceKey(enterLetter)
        default:
            return true
        }
    }
    
    //MARK: under developed
    private func underdeveloped() {
        self.singleButtonAlertbox("", AppStringConstant.thisScreenNeedMoreWorkItApproachingQuickly, AppStringConstant.ok ) {
        }
    }
    
    //MARK: create account screen
    func goToCreateAccountScreen() {
        guard let createAccountViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.createAccountViewController) as? CreateAccountViewController  else { return }
        self.navigationController?.pushViewController(createAccountViewController, animated: true)
    }
    
    //MARK: dashboard tab viewcontroller
    func goToDashboardTabViewController() {
        guard let dashboardTabViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.dashboardTabViewController) as? DashboardTabViewController else { return }
        self.navigationController?.pushViewController(dashboardTabViewController, animated: true)
    }
}
