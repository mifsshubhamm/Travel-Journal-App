//
//  PostTitleCollectionViewCell.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 28/08/23.
//

import UIKit

class PostTitleCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: configure
    public func configure(_ title: String, _ isSelectedCell: Bool) {
        titleOutlet.text = title
        if isSelectedCell {
            titleOutlet.backgroundColor = UIColor(named: AppColorConstant.BlueColor_50)
        } else {
            titleOutlet.backgroundColor = UIColor(named: AppColorConstant.ColorCACBD2)
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AppReuseIdentifier.postTitleCollectionViewCell, bundle: nil)
    }
    
}
