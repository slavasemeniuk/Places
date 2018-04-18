//
//  UsersController.swift
//  App
//
//  Created by Slava Semeniuk on 4/12/18.
//

import Vapor
import Crypto
import Authentication

final class UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRouter = router.grouped("users")
        usersRouter.post(use: createHandler)
        
        let currentUserRouter = usersRouter.grouped("me")
        let basicAuthGroup = currentUserRouter.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
        basicAuthGroup.get(use: loginHandler)

    }
    
    func createHandler(_ req: Request) throws -> Future<User.Public> {
        return try req.content
            .decode(User.self)
            .flatMap(to: User.self) { user in
                user.password = try String.convertFromData(BCrypt.hash(user.password, cost: 1))
                return user.save(on: req)
            }
            .flatMap(to: (User, UserToken).self) { user in
                let token = try UserToken(user)
                return req.eventLoop.newSucceededFuture(result: user).and(token.save(on: req))
            }.map(to: User.Public.self) {
                return try User.Public(user: $0, token: $1)
        }
    }
    
    func loginHandler(_ req: Request) throws -> Future<User.Public> {
        let user = try req.requireAuthenticated(User.self)
        return try UserToken(user)
            .save(on: req)
            .map(to: User.Public.self) {
                try User.Public(user: user, token: $0)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        
        return User.query(on: req).all()
    }
}
