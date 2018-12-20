//
//  User+Validations.swift
//  App
//
//  Created by Sviatoslav Semeniuk on 12/20/18.
//

import FluentMySQL
import Vapor

extension User: Validatable {
    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        try validations.add(\.firstName, .alphanumeric && .count(3...))
        try validations.add(\.lastName, .alphanumeric && .count(3...))
        try validations.add(\.email, .email)
        return validations
    }
}
