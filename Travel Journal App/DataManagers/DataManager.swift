//
//  DataManager.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 13/09/23.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    
    static let shared = DataManager()
    
    private init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Travel_Journal_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchPostData() {
        let requestPostDetails: NSFetchRequest<PostDetails> = PostDetails.fetchRequest()
        var fetchedPostDetailsList: [PostDetails] = []
        do {
            fetchedPostDetailsList = try persistentContainer.viewContext.fetch(requestPostDetails)
            
            for fetchedPostDetails in fetchedPostDetailsList {
                let requestLocationDetails: NSFetchRequest<LocationDetails> = LocationDetails.fetchRequest()
                requestLocationDetails.predicate = NSPredicate(format: "toPostDetail = %@", fetchedPostDetails)
                var fetchedLocationDetails: [LocationDetails] = []
                do {
                    fetchedLocationDetails = try persistentContainer.viewContext.fetch(requestLocationDetails)
                } catch let error {
                    print("Error fetching singers \(error)")
                }
                
                let requestPhotoDetails: NSFetchRequest<PhotoDetails> = PhotoDetails.fetchRequest()
                requestPhotoDetails.predicate = NSPredicate(format: "toPostDetails = %@", fetchedPostDetails)
                var fetchedPhotoDetailsList: [PhotoDetails] = []
                do {
                    fetchedPhotoDetailsList = try persistentContainer.viewContext.fetch(requestPhotoDetails)
                    for fetchedPhotoDetails in fetchedPhotoDetailsList {
                        let requestImageList: NSFetchRequest<Image> = Image.fetchRequest()
                        requestImageList.predicate = NSPredicate(format: "toPhotoDetails = %@", fetchedPhotoDetails)
                        var fetchedImageList: [Image] = []
                        do {
                            fetchedImageList = try persistentContainer.viewContext.fetch(requestImageList)
                        } catch let error {
                        }
                    }
                } catch let error {
                    print("Error fetching singers \(error)")
                }
            }
        } catch let error {
            print("Error fetching singers \(error)")
        }

    }
    
    func postDataSave(coverImage:UIImage, title:String, date:String, location:GMSMapModel, photoDataList: Array<AddPhotosAndDetailModel>) {
        let postCoreData = PostDetails(context: persistentContainer.viewContext)
        postCoreData.title = title
        postCoreData.date = date
        postCoreData.coverImage = coverImage.jpegData(compressionQuality: 1) as Data?
        
        let locationCoreData = LocationDetails(context: persistentContainer.viewContext)
        locationCoreData.country = location.country
        locationCoreData.locality = location.locality
        locationCoreData.subLocality = location.subLocality
        locationCoreData.thoroughfare = location.thoroughfare
        locationCoreData.subThoroughfare = location.subThoroughfare
        locationCoreData.postalCode = location.postalCode
        locationCoreData.address = location.address
        locationCoreData.latitude = location.latitude
        locationCoreData.longitude = location.longitude
        postCoreData.toLocation = locationCoreData
       
        save()
       
        for photoData in photoDataList {
            let photoCoreData = PhotoDetails(context: persistentContainer.viewContext)
            photoCoreData.title = photoData.title
            photoCoreData.date = photoData.date
            photoCoreData.photoDescription = photoData.description
            postCoreData.toPhotoDetails = photoCoreData
            save()
            
            for image  in photoData.imagelist {
                let imageCoreData = Image(context: persistentContainer.viewContext)
                if image.imageUrl == nil {
                    imageCoreData.image = image.imageItem?.jpegData(compressionQuality: 1) as Data?
                } else {
                    imageCoreData.imageUrl = image.imageUrl
                }
                photoCoreData.toImage = imageCoreData
                save()
            }
        }
        
    }
    
    // MARK: - Core Data Saving support
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("❗️Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deletePostDetails(postDetails: PostDetails) {
        let context = persistentContainer.viewContext
        context.delete(postDetails)
        save()
    }
    
    func deleteImage(image: Image) {
        let context = persistentContainer.viewContext
        context.delete(image)
        save()
    }
    
    func deleteLocationDetails(locationDetails: LocationDetails) {
        let context = persistentContainer.viewContext
        context.delete(locationDetails)
        save()
    }
    
    func deletePhotoDetails(photoDetails: PhotoDetails) {
        let context = persistentContainer.viewContext
        context.delete(photoDetails)
        save()
    }
}
