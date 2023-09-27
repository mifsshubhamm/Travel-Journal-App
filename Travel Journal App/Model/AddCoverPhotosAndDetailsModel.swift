//
//  AddCoverPhotosAndDetailsModel.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 27/08/23.
//

import Foundation
import UIKit

struct AddCoverPhotosAndDetailsModel  {
    var coverImage : String
    var titleMain : String
    var dateMain : String
    var firebaseUID : String
    var locationMain : GMSMapModel
    var list : Array<PhotosAndDetailModel>
}
