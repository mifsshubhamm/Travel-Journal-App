//
//  AddPhotosAndDetailModel.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 27/08/23.
//

import Foundation
import UIKit

struct AddPhotosAndDetailModel  {
    var title : String
    var date : String
    var description : String
    var firebaseImage: String?
    var imagelist : Array<ImageItemModel>
}
