//
//  Image+CoreDataProperties.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 13/09/23.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: Data?
    @NSManaged public var imageUrl: String?
    @NSManaged public var toPhotoDetails: PhotoDetails?

}

extension Image : Identifiable {

}
