//
//  City.swift
//  App
//
//  Created by Slava Semeniuk on 5/11/18.
//

import FluentMySQL
import Vapor

final class City: MySQLUUIDModel {
    
    // MARK: - Properties
    var id: UUID?
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
}

extension City {
    public var places: Children<City, Place> {
        return children(\Place.cityID)
    }
}
