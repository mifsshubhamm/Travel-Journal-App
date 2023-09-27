//
//  LocationDetails+CoreDataProperties.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 13/09/23.
//
//

import Foundation
import CoreData


extension LocationDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationDetails> {
        return NSFetchRequest<LocationDetails>(entityName: "LocationDetails")
    }

    @NSManaged public var address: String?
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var locality: String?
    @NSManaged public var longitude: Double
    @NSManaged public var postalCode: String?
    @NSManaged public var subLocality: String?
    @NSManaged public var subThoroughfare: String?
    @NSManaged public var thoroughfare: String?
    @NSManaged public var toPostDetail: PostDetails?

}

extension LocationDetails : Identifiable {

}
