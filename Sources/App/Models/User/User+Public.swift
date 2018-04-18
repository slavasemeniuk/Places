//
//  User+Public.swift
//  App
//
//  Created by Slava Semeniuk on 4/12/18.
//
//
import FluentMySQL
import Vapor
import Authentication

extension User {
    final class Public: Content {
        
        var id: UUID
        var email: String
        var firstName: String
        var lastName: String
        var token: String?
        
        init(user: User, token: UserToken? = nil) throws {
            self.id = try user.requireID()
            self.email = user.email
            self.firstName = user.firstName
            self.lastName = user.lastName
            self.token = token?.token
        }
    }
}
