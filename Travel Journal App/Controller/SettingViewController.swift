//
//  SettingViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 24/08/23.
//

import UIKit

class SettingViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var userOutlet: UILabel!
    @IBOutlet weak var fullnameOutlet: UILabel!
    @IBOutlet var logoutStackView: UIStackView!
    @IBOutlet var changePassword: UIStackView!
    @IBOutlet var privacyPolicyStackView: UIStackView!
    @IBOutlet var termsConditionStackView: UIStackView!
    @IBOutlet var helpStackView: UIStackView!
    @IBOutlet var legalStackView: UIStackView!
    @IBOutlet var faqStackView: UIStackView!
    @IBOutlet weak var emailOutlet: UILabel!
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initView()
    }
    
    //MARK: Action
    @IBAction func editProfile(_ sender: UIButton) {
        guard let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.profileViewController) as? ProfileViewController  else { return }
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        PrefsUserDefaults.sharedUserDefaults.isLogin = false
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.loginViewController) as? LoginViewController else { return }
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    //MARK: initview
    private func initView() {
        fullnameOutlet.text =  PrefsUserDefaults.sharedUserDefaults.fullName
        userOutlet.text = PrefsUserDefaults.sharedUserDefaults.userName
        emailOutlet.text = PrefsUserDefaults.sharedUserDefaults.email
        initViewAction()
    }
    
    //MARK: init action
    func initViewAction() {
        changePassword.setOnClickListener {
            self.underdeveloped()
        }
        
        privacyPolicyStackView.setOnClickListener {
            self.underdeveloped()
        }
        
        termsConditionStackView.setOnClickListener {
            self.underdeveloped()
        }
        
        helpStackView.setOnClickListener {
            self.underdeveloped()
        }
        
        legalStackView.setOnClickListener {
            self.underdeveloped()
        }
        
        faqStackView.setOnClickListener {
            self.underdeveloped()
        }
        
        logoutStackView.setOnClickListener {
            self.goToLoginScreen()
        }
    }
    
    //MARK: under developed
    private func underdeveloped() {
        self.singleButtonAlertbox("", AppStringConstant.thisScreenNeedMoreWorkItApproachingQuickly, AppStringConstant.ok ) {
        }
    }
    
    //MARK: go to login screen
    func goToLoginScreen() {
        PrefsUserDefaults.sharedUserDefaults.isLogin = false
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.loginViewController) as? LoginViewController else { return }
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}
