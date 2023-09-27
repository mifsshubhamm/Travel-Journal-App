//
//  HomeTableViewCell.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 02/09/23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var coverImageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var menubuttonOutLet: UIButton!
    
    //MARK: Variables
    var menuProtocol: MenuProtocol?
    var actionBlock: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Action
    @IBAction func menuButton(_ sender: Any) {
        menuProtocol?.onClickListener(index: menubuttonOutLet.tag)
    }
    
    //MARK: configure
    public func configure(_ image: String, title: String, address:String, date:String, index:Int) {
        coverImageOutlet.downloaded(from: image)
        coverImageOutlet.radius(8)
        titleOutlet.text = title
        addressOutlet.text = address
        dateOutlet.text = date
        menubuttonOutLet.tag = index
        
        contentView.setOnClickListener {
            self.actionBlock?()
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AppReuseIdentifier.homeTableViewCell, bundle: nil)
    }
}
