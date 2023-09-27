//
//  AddCoverPhotosAndDetailsViewModel.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 27/08/23.
//

import Foundation
import Firebase

class AddCoverPhotosAndDetailsViewModel: NSObject {
    
    //MARK: Variables
    private var imageList: [ImageItemModel] = []
    private var firebaseImageList = Array<String>()
    private var tempselectedImageList = [[String : Any]]()
    var tempCoverImage = ""
    var selectedCoverImage:UIImage?
    var list: Array<AddPhotosAndDetailModel> = []
    var parntIndex : Int = -1
    var gMSMapModel: GMSMapModel?
    private var title = ""
    private var date = ""
    var editData: AddCoverPhotosAndDetailsModel?
    
    //MARK: validation
    func validation(_ coverImage: UIImage?, title: String?, _ date: String?, location: String?, _ list: Array<AddPhotosAndDetailModel>, completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        if coverImage == nil && tempCoverImage.isEmpty {
            completion(.failure(.selectCoverImage))
        } else if title.isNilorEmpty() {
            completion(.failure(.enterTitle))
        } else if date.isNilorEmpty() {
            completion(.failure(.selectDate))
        } else if location.isNilorEmpty() {
            completion(.failure(.selectLocation))
        } else if list.isEmpty {
            completion(.failure(.selectAtleastPhoto))
        } else {
            self.title = title ?? ""
            self.date = date ?? ""
            completion(.success(true))
        }
    }
    
    //MARK: set Image
    // if index value is -1 it mean we upload cover image on firebase
    func setImage(completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        var tempImageList = Array<ImageItemModel>()
        
        if parntIndex == -1 {
            if selectedCoverImage != nil {
                tempImageList.append(ImageItemModel(imageItem: selectedCoverImage, imageUrl: ""))
            } else if !tempCoverImage.isEmpty {
                self.parntIndex += 1
                self.setImage(completion: completion)
            }
        } else {
            tempImageList.append(contentsOf: list[parntIndex].imagelist)
        }
        storageImage(imageList: tempImageList,completion: completion)
    }
    
    //MARK: storage Image
    func storageImage(imageList : Array<ImageItemModel>,completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        self.imageList = imageList
        if (!self.imageList.isEmpty) {
            firebaseImageList = []
            setFirebaseImage(index: 0,completion: completion)
        }
    }
    
    //MARK: saved image on firebase
    private func setFirebaseImage(index : Int,completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        let randomId = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "photos/\(randomId).jpg")
        if imageList[index].imageItem == nil {
            if self.imageList.count > index+1 {
                self.firebaseImageList.append(imageList[index].imageUrl ?? "")
                self.setFirebaseImage(index: index + 1, completion: completion)
            } else {
                self.firebaseImageList.append(imageList[index].imageUrl ?? "")
                checkUploadOnFirebase(true ,"", completion: completion)
            }
        } else {
            guard let imageData = imageList[index].imageItem?.jpegData(compressionQuality: 0.75) else { return }
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            
            uploadRef.putData(imageData, metadata: uploadMetaData) { [self] (downloadMetaData, error) in
                if error != nil {
                    checkUploadOnFirebase(false ,"",completion: completion)
                    return
                } else {
                    if self.imageList.count > index+1 {
                        uploadRef.downloadURL() { [self] url, error in
                            if error == nil {
                                self.firebaseImageList.append(url?.absoluteString ?? "")
                                self.setFirebaseImage(index: index + 1, completion: completion)
                            } else {
                                checkUploadOnFirebase(false ,"",completion: completion)
                            }
                        }
                    } else {
                        uploadRef.downloadURL() { [self] url, error in
                            if error == nil {
                                self.firebaseImageList.append(url?.absoluteString ?? "")
                                checkUploadOnFirebase(true ,"", completion: completion)
                            } else {
                                checkUploadOnFirebase(false ,"",completion: completion)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    //MARK: check the upload data
    func checkUploadOnFirebase(_ status:Bool , _ errorMessage: String, completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        if status {
            if parntIndex == -1 {
                self.tempCoverImage = firebaseImageList[0]
                self.parntIndex += 1
                self.setImage(completion: completion)
            } else {
                if list.count > parntIndex + 1 {
                    let postFirebaseData = [
                        AppFirebaseKeyConstant.title: list[parntIndex].title,
                        AppFirebaseKeyConstant.date: list[parntIndex].date,
                        AppFirebaseKeyConstant.description: list[parntIndex].description,
                        AppFirebaseKeyConstant.imagelist: firebaseImageList,
                    ] as [String : Any]
                    self.tempselectedImageList.append(postFirebaseData)
                    self.parntIndex += 1
                    self.setImage(completion: completion)
                } else {
                    let postFirebaseData = [
                        AppFirebaseKeyConstant.title: list[parntIndex].title,
                        AppFirebaseKeyConstant.date: list[parntIndex].date,
                        AppFirebaseKeyConstant.description: list[parntIndex].description,
                        AppFirebaseKeyConstant.imagelist: firebaseImageList,
                    ] as [String : Any]
                    self.tempselectedImageList.append(postFirebaseData)
                    
                    let locationMain = [
                        AppFirebaseKeyConstant.country: self.gMSMapModel?.country ?? "",
                        AppFirebaseKeyConstant.locality: self.gMSMapModel?.locality ?? "",
                        AppFirebaseKeyConstant.subLocality: self.gMSMapModel?.subLocality ?? "",
                        AppFirebaseKeyConstant.thoroughfare: self.gMSMapModel?.thoroughfare ?? "",
                        AppFirebaseKeyConstant.subThoroughfare: self.gMSMapModel?.subThoroughfare ?? "",
                        AppFirebaseKeyConstant.postalCode: self.gMSMapModel?.postalCode ?? "",
                        AppFirebaseKeyConstant.address: self.gMSMapModel?.address ?? "",
                        AppFirebaseKeyConstant.latitude: self.gMSMapModel?.latitude ?? "",
                        AppFirebaseKeyConstant.longitude: self.gMSMapModel?.longitude ?? "",
                    ] as [String : Any]
                    
                    let postData = [
                        AppFirebaseKeyConstant.coverImage: self.tempCoverImage,
                        AppFirebaseKeyConstant.titleMain: self.title,
                        AppFirebaseKeyConstant.dateMain: self.date,
                        AppFirebaseKeyConstant.locationMain: locationMain,
                        AppFirebaseKeyConstant.list: self.tempselectedImageList,
                    ] as [String : Any]
                    
                    createPost(postData: postData,completion: completion)
                }
            }
        } else {
            completion(.failure(.unknown))
        }
    }
    
    //MARK: Create Post
    func createPost(postData: [String:Any], completion: @escaping (Result<Bool,AppErrorUtil>) -> ()) {
        var tempPostdata = postData
        var ref: DatabaseReference
        if editData == nil {
            ref = Database.database().reference().child(AppFirebaseConstant.post).child(PrefsUserDefaults.sharedUserDefaults.uid ?? "").childByAutoId()
            ref.keepSynced(true)
            let uidFirebase = ref.key
            tempPostdata[AppFirebaseKeyConstant.firebaseUID] = uidFirebase ?? ""
        } else {
            ref = Database.database().reference().child(AppFirebaseConstant.post).child(PrefsUserDefaults.sharedUserDefaults.uid ?? "").child(editData?.firebaseUID ?? "")
            ref.keepSynced(true)
            tempPostdata[AppFirebaseKeyConstant.firebaseUID] = editData?.firebaseUID ?? ""
            
        }
        ref.setValue(tempPostdata)
        completion(.success(true))
    }
    
    //MARK: remove All Data 
    func removeAllDataFromViewModel() {
        imageList = Array<ImageItemModel>()
        firebaseImageList = Array<String>()
        tempselectedImageList = [[String : Any]]()
        tempCoverImage = ""
        selectedCoverImage = nil
        list = []
        parntIndex = -1
        gMSMapModel = nil
        title = ""
        date = ""
        editData = nil
    }
}
