//
//  Coutnry.swift
//  App
//
//  Created by Slava Semeniuk on 5/11/18.
//

import FluentMySQL
import Vapor

final class Country: MySQLUUIDModel {
    
    // MARK: - Properties
    var id: UUID?
    var name: String

}

