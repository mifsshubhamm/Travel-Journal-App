//
//  CodeDataProtocol.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 04/09/23.
//

import Foundation

protocol CoreDataProtocol {
    func getAllData() -> [AddCoverPhotosAndDetailsViewModel]
    func createData() -> AddCoverPhotosAndDetailsViewModel
    func deleteData() -> AddCoverPhotosAndDetailsViewModel
    func updateData() -> AddCoverPhotosAndDetailsViewModel
}
