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
        
        let currentUserRouter = usersRouter.grouped("me")
        let basicAuthGroup = currentUserRouter.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
        basicAuthGroup.get(use: loginHandler)
        
        let tokenGroup = usersRouter.grouped(User.tokenAuthMiddleware())
        tokenGroup.get(User.parameter, use: getAtIndex)
    }
    
    func createHandler(_ req: Request) throws -> Future<User.Public> {
        return try req.content
            .decode(User.self)
            .flatMap { usr in
                try usr.throwIfExist(with: \User.email, on: req)
            }
            .flatMap(to: User.self) { user in
                user.password = try BCrypt.hash(user.password, cost: 4)
                return user.save(on: req)
            }
            .flatMap(to: (User, UserToken).self) { user in
                let token = try UserToken(user)
                return req.eventLoop.newSucceededFuture(result: user).and(token.save(on: req))
            }.map { res in
                return try User.Public(user: res.0, token: res.1)
        }
    }
    
    func loginHandler(_ req: Request) throws -> Future<User.Public> {
        let user = try req.requireAuthenticated(User.self)
        try req.unauthenticate(User.self)
        return try user.authTokens.query(on: req)
            .delete()
            .map(to: UserToken.self) { try UserToken(user) }
            .save(on: req)
            .map(to: User.Public.self) {
                try User.Public(user: user, token: $0)
        }
    }
    
    func getAtIndex(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters
            .next(User.self)
            .map(to: User.Public.self) {
                try User.Public(user: $0)
        }
    }
}
