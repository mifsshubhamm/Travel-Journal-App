//
//  HomePostCollectionViewCell.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 28/08/23.
//

import UIKit

class HomePostCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var coverImageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var menubuttonOutLet: UIButton!
    
    var menuProtocol: MenuProtocol?
    
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
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AppReuseIdentifier.homePostCollectionViewCell, bundle: nil)
    }
}
