//
//  BaseRepository.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 06/09/23.
//

import Foundation


protocol BaseRespository {
    
    associatedtype T
    
    func create( record: T)
    func getAll() -> [T]?
    func get( byIdenifier id: UUID) -> T?
    func update( record: T) -> Bool
    func delete( byIdenifier id: UUID) -> Bool
}
