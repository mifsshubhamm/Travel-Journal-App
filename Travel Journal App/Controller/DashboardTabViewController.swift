//
//  DashboardTabViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 19/08/23.
//

import UIKit

class DashboardTabViewController: UITabBarController {
    
    //MARK: Outlet
    @IBOutlet weak var tabbarOutlet: UITabBar!
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarOutlet.addShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
}
