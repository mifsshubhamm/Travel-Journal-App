//
//  PhotoCollectionViewCell.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 25/08/23.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var crossButtonOutlet: UIButton!
    @IBOutlet weak var photos: UIImageView!
    
    //MARK: Variables
    var menuProtocol: MenuProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Action
    @IBAction func crossButton(_ sender: UIButton) {
        menuProtocol?.onClickListener(index: crossButtonOutlet.tag)
    }
    
    //MARK: configure
    public func configure(with image: ImageItemModel, isCrossHide: Bool, index:Int) {
        crossButtonOutlet.isHidden = isCrossHide
        if image.imageItem != nil {
            photos.image = image.imageItem
        } else {
            photos.downloaded(from: image.imageUrl ?? "")
        }
        photos.radius(8)
        crossButtonOutlet.tag = index
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AppReuseIdentifier.photoCollectionViewCell, bundle: nil)
    }
}
