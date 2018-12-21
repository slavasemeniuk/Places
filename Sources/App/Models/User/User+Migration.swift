//
//  User+Migration.swift
//  App
//
//  Created by Slava Semeniuk on 3/30/18.
//

import FluentMySQL

extension User: Migration {
    static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.email)
        }
    }

    static func revert(on connection: MySQLConnection) -> Future<Void> {
        return Database.delete(self, on: connection)
    }
}
