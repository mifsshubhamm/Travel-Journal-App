//
//  PhotoDetails+CoreDataProperties.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 13/09/23.
//
//

import Foundation
import CoreData


extension PhotoDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoDetails> {
        return NSFetchRequest<PhotoDetails>(entityName: "PhotoDetails")
    }

    @NSManaged public var date: String?
    @NSManaged public var photoDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var toImage: Image?
    @NSManaged public var toPostDetails: PostDetails?

}

extension PhotoDetails : Identifiable {

}
