//
//  Trip.swift
//  App
//
//  Created by Slava Semeniuk on 5/11/18.
//

import FluentMySQL
import Vapor

final class Trip: MySQLUUIDModel {
    
    // MARK: - Properties
    var id: UUID?
    var dateStart: Date
    var dateEnd: Date?
    
}
