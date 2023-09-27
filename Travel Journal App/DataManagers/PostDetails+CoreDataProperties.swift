//
//  PostDetails+CoreDataProperties.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 13/09/23.
//
//

import Foundation
import CoreData


extension PostDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostDetails> {
        return NSFetchRequest<PostDetails>(entityName: "PostDetails")
    }

    @NSManaged public var coverImage: Data?
    @NSManaged public var date: String?
    @NSManaged public var title: String?
    @NSManaged public var toLocation: LocationDetails?
    @NSManaged public var toPhotoDetails: PhotoDetails?

}

extension PostDetails : Identifiable {

}
