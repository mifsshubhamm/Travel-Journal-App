//
//  PhotoHelper.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 20/08/23.
//

import Foundation
import PhotosUI


class PhotoHelper: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    //MARK: Variable
    var imagePickerProtocal : ImagePickerProtocal? = nil
    
    //MARK: ask Permission
    func askPermission(isMultiSelection: Bool) {
        PHPhotoLibrary.requestAuthorization({ (status) in
            if(status == PHAuthorizationStatus.authorized) {
                DispatchQueue.main.async {
                    self.alertController(isMultiSelection: isMultiSelection)
                }
            } else {
                print(AppStringConstant.permission_is_not_found)
            }
        })
    }
    
    //MARK: alert controller
    private func alertController(isMultiSelection: Bool) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: AppStringConstant.camera, style: .default) { (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let gallaryBtn = UIAlertAction(title: AppStringConstant.photo, style: .default) { (_) in
            //self.showImagePicker(selectedSource: .photoLibrary)
            var config = PHPickerConfiguration()
            var selectionLimit = 1
            if isMultiSelection {
                selectionLimit = 10
            } else {
                selectionLimit = 1
            }
            config.selectionLimit = selectionLimit
            
            let phController = PHPickerViewController(configuration: config)
            phController.delegate = self
            self.present(phController, animated: true)
            
        }
        let cancelBtn = UIAlertAction(title: AppStringConstant.cancel, style: .cancel, handler: nil)
        
        ac.addAction(cameraBtn)
        ac.addAction(gallaryBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac,animated: true,completion: nil)
    }
    
    //MARK: show Image Picker
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = selectedSource
        self.present(imagePicker, animated: true)
    }
    
    //MARK: image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] is UIImage {
            imagePickerProtocal?.getImage(info[.originalImage] as? UIImage, nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: image Picker Controller Did Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: picker
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.imagePickerProtocal?.getImage(image , nil)
                } else {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                        if let url = url {
                            self.imagePickerProtocal?.getImage( self.generateThumbnail(path: url) , nil)
                        }
                    }
                    
                }
            }
        }
    }
    
    //MARK: generate thumbnail
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch _ {
            return nil
        }
    }
}
