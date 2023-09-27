//
//  SortByViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 29/08/23.
//

import UIKit

class SortByViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var sortByView: UIView!
    
    //MARK: variable
    var sortByProtocol: SortByProtocol?
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        sortByView.topRadius(20)
    }
    
    //MARK: Action
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func aToZButton(_ sender: UIButton) {
        sortByProtocol?.aToZ()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func zToAButton(_ sender: UIButton) {
        sortByProtocol?.zToA()
        self.dismiss(animated: true)
    }
    
    @IBAction func oldestToNewest(_ sender: UIButton) {
        sortByProtocol?.oldestToNewest()
        self.dismiss(animated: true)
    }
    
    @IBAction func newestToOldest(_ sender: UIButton) {
        sortByProtocol?.newestToOldest()
        self.dismiss(animated: true)
    }
}
