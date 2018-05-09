//
//  Model+Uniqueness.swift
//  App
//
//  Created by Slava Semeniuk on 5/10/18.
//

import Vapor
import Async
import Fluent

extension Model where Self.Database : QuerySupporting {

    func throwIfExist<T: Equatable>(with keyPath: KeyPath<Self, T>, on connection: DatabaseConnectable) throws -> Future<Self> {
        return try Self
            .query(on: connection)
            .filter(keyPath == self[keyPath: keyPath])
            .first()
            .thenThrowing {
                if $0 == nil {
                    return self
                }
                throw Abort(.conflict, reason: "\(Self.name) with '\(self[keyPath: keyPath])' is already exits.")
        }
    }
}
