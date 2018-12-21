//
//  UsersController.swift
//  App
//
//  Created by Slava Semeniuk on 4/12/18.
//

import Vapor
import Crypto
import Authentication
import Fluent

final class UsersController: RouteCollection {
    func boot(router: Router) throws {
        
        let usersRouter = router.grouped("users")
        usersRouter.post(use: createHandler)
        
        let currentUserRouter = usersRouter.grouped("me").grouped(User.basicAuthMiddleware(using: BCryptDigest()))
        currentUserRouter.get(use: loginHandler)
        
        let tokenGroup = usersRouter.grouped(User.tokenAuthMiddleware())
        tokenGroup.get(User.parameter, use: getAtIndex)
        tokenGroup.get(use: getList)
    }
    
    func createHandler(_ req: Request) throws -> Future<User.Public> {
        return try req
            .content
            .decode(User.self)
            .flatMap(to: User.self) { user in
                try user.validate()
                user.password = try BCrypt.hash(user.password, cost: 4)
                return user.save(on: req)
            }
            .flatMap(to: (User, UserToken).self) { user in
                let token = try UserToken(user)
                return req.eventLoop.newSucceededFuture(result: user).and(token.save(on: req))
            }.map { try User.Public(user: $0.0, token: $0.1)
        }
    }
    
    func loginHandler(_ req: Request) throws -> Future<User.Public> {
        let user = try req.requireAuthenticated(User.self)
        try req.unauthenticate(User.self)
        return try user
            .authTokens
            .query(on: req)
            .delete()
            .map { try UserToken(user) }
            .save(on: req)
            .map { try User.Public(user: user, token: $0) }
    }
    
    func getAtIndex(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters
            .next(User.self)
            .map { try User.Public(user: $0) }
    }
    
    func getList(_ req: Request) throws -> Future<[User.Public]> {
        return User.query(on: req)
            .all()
            .map { users in
                try users.map { try User.Public(user: $0) }
            }
    }
}
