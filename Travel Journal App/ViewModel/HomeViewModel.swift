//
//  MapViewModel.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 27/08/23.
//

import Foundation
import Firebase

class HomeViewModel: NSObject {
    
    //MARK: Variables
    var list: Array<AddCoverPhotosAndDetailsModel> = Array()
    var listFilter: Array<AddCoverPhotosAndDetailsModel> = Array()
    var data: AddCoverPhotosAndDetailsModel?
    
    //MARK: get Add Post
    func getPostData( _ completion: @escaping (_ list: Array<AddCoverPhotosAndDetailsModel>) -> ()) {
        let ref = Database.database().reference()
        ref.child(AppFirebaseConstant.post).child(PrefsUserDefaults.sharedUserDefaults.uid ?? "").observe(.value) { (snapshot,_) in
            self.addingDataFromFirebaseToList(snapshot: snapshot,completion)
        }
    }
    
    //MARK: get Particular Post Data
    func getParticularPostData(firebaseUid: String, _ completion: @escaping (_ data: AddCoverPhotosAndDetailsModel?) ->()) {
        let ref = Database.database().reference()
        ref.child(AppFirebaseConstant.post).child(PrefsUserDefaults.sharedUserDefaults.uid ?? "").child(firebaseUid).observeSingleEvent(of: .value) { (snapshot,_) in
            if let item = snapshot.value as? NSDictionary {
                completion(self.fetchData(firebaseData: item))
            }
        }
    }
    
    //MARK: Adding Data From Firebase To List
    func addingDataFromFirebaseToList(snapshot: DataSnapshot, _ completion: @escaping (_ list: Array<AddCoverPhotosAndDetailsModel>) -> ()) {
        var mData = Array<AddCoverPhotosAndDetailsModel>()
        if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
            for snap in snapShot {
                var tempData : AddCoverPhotosAndDetailsModel? = nil
                if let snap = snap.value as? NSDictionary {
                    tempData = fetchData(firebaseData: snap)
                } else {
                    tempData = nil
                }
                if tempData != nil {
                    mData.append(
                        tempData!
                    )
                }
            }
        }
        completion(mData.reversed())
    }
    
    //MARK: Fetch data
    private func fetchData(firebaseData: NSDictionary) -> AddCoverPhotosAndDetailsModel? {
        var mData : AddCoverPhotosAndDetailsModel?
        let location = firebaseData[AppFirebaseKeyConstant.locationMain] as? [String:Any]
        let tempList = firebaseData[AppFirebaseKeyConstant.list] as? [[String:Any]]
        
        var list = Array<PhotosAndDetailModel>()
        
        if tempList != nil {
            for element in tempList! {
                list.append(
                    PhotosAndDetailModel(
                        title: element[AppFirebaseKeyConstant.title] as? String ?? "",
                        date: element[AppFirebaseKeyConstant.date] as? String ?? "",
                        description: element[AppFirebaseKeyConstant.description] as? String ?? "",
                        imagelist:element[AppFirebaseKeyConstant.imagelist] as? Array<String> ?? Array()
                    )
                )
            }
            mData = AddCoverPhotosAndDetailsModel(
                coverImage: firebaseData[AppFirebaseKeyConstant.coverImage] as? String ?? "",
                titleMain: firebaseData[AppFirebaseKeyConstant.titleMain] as? String ?? "",
                dateMain: firebaseData[AppFirebaseKeyConstant.dateMain] as? String ?? "",
                firebaseUID: firebaseData[AppFirebaseKeyConstant.firebaseUID] as? String ?? "",
                locationMain: GMSMapModel(
                    country: location?[AppFirebaseKeyConstant.country] as? String ?? "",
                    locality: location?[AppFirebaseKeyConstant.locality] as? String ?? "",
                    subLocality: location?[AppFirebaseKeyConstant.subLocality] as? String ?? "",
                    thoroughfare: location?[AppFirebaseKeyConstant.thoroughfare] as? String ?? "",
                    subThoroughfare: location?[AppFirebaseKeyConstant.subThoroughfare] as? String ?? "",
                    postalCode: location?[AppFirebaseKeyConstant.postalCode] as? String ?? "",
                    address: location?[AppFirebaseKeyConstant.address] as? String ?? "",
                    latitude: location?[AppFirebaseKeyConstant.latitude] as? Double ?? 0.0,
                    longitude: location?[AppFirebaseKeyConstant.longitude] as? Double ?? 0.0
                ) ,
                list: list
            )
        }
        
        return mData
    }
    
    //MARK: Delete Post
    func deletePost(firebaseUId: String, completion: @escaping (Result<Bool,Error>) -> ()) {
        let ref = Database.database().reference()
        ref.child(AppFirebaseConstant.post).child(PrefsUserDefaults.sharedUserDefaults.uid ?? "").child(firebaseUId).setValue(nil)
        completion(.success(true))
    }
}
