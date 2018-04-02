//
//  UserToken.swift
//  App
//
//  Created by Slava Semeniuk on 4/3/18.
//

import Vapor
import Authentication
import FluentMySQL

final class UserToken: Token {
    
    typealias Database = MySQLDatabase
    typealias UserType = User
    typealias ID = Int
    
    static var idKey: WritableKeyPath<UserToken, Int?> {
        return \.id
    }
    static var tokenKey: WritableKeyPath<UserToken, String> {
        return \.token
    }
    static var userIDKey: WritableKeyPath<UserToken, UUID> {
        return \.userID
    }
    
    var id: Int?
    var token: String
    var userID: UUID
    
    init(token: String, userID: UUID) {
        self.token = token
        self.userID = userID
    }
}
