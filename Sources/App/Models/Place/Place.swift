//
//  Place.swift
//  App
//
//  Created by Slava Semeniuk on 5/11/18.
//

import FluentMySQL
import Vapor

final class Place: MySQLUUIDModel {
    
    // MARK: - Properties
    var id: UUID?
    var arrivalDate: Date
    var departureDate: Date?
    
    var latitude: Double
    var longitude: Double
    
    var cityID: UUID
    
    init(arrivalDate: Date, latitude: Double, longitude: Double, cityID: UUID) {
        self.arrivalDate = arrivalDate
        self.latitude = latitude
        self.longitude = longitude
        self.cityID = cityID
    }
}

extension Place {
    /// A relation to this token's owner.
    var city: Parent<Place, City> {
        return parent(\.cityID)
    }
}
