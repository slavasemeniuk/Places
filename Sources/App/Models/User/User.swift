import FluentMySQL
import Vapor
import Authentication

final class User: MySQLUUIDModel {
    
    // MARK: - Properties
    var id: UUID?
    var email: String
    var firstName: String
    var lastName: String
    var password: String
    
    init(id: UUID? = nil, firstName: String, lastName: String, email: String, password: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
    }
}

// MARK: - Parameter
extension User: Parameter {}

// MARK: - TokenAuthenticatable
extension User: TokenAuthenticatable {
    typealias TokenType = UserToken
}

extension User: BasicAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> {
        return \.email
    }
    
    static var passwordKey: WritableKeyPath<User, String> {
        return \.password
    }
}
