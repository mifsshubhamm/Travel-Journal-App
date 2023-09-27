//
//  PostPhotoCollectionViewCell.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 28/08/23.
//

import UIKit

class PostPhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: configure
    public func configure(with image: String) {
        photoImageView.downloaded(from: image)
        photoImageView.radius(8)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AppReuseIdentifier.postPhotoCollectionViewCell, bundle: nil)
    }
}
