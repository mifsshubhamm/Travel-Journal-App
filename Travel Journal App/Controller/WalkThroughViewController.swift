//
//  ViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 16/08/23.
//

import UIKit

class WalkThroughViewController: UIViewController {
    
    //MARK: lifecycle of ViewController
    override func viewWillAppear(_ animated: Bool) {
        initView()
    }
    
    //MARK: Action
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        goToLoginScreen()
    }
    
    //MARK: init
    func initView() {
        hideNavigationBar()
    }
    
    //MARK: go to login screen
    func goToLoginScreen() {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.loginViewController) as? LoginViewController else { return }
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}

