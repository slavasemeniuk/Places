import FluentMySQL
import Vapor
import Authentication

final class User: Model {
    
    // MARK: - Properties
    var id: UUID?
    var firsName: String
    var lastName: String
    
    init(id: UUID? = nil, firstName: String, lastName: String) {
        self.id = id
        self.firsName = firstName
        self.lastName = lastName
    }
}

// MARK: - MySQLUUIDModel
extension User: MySQLUUIDModel {}

// MARK: - TokenAuthenticatable
extension User: TokenAuthenticatable {
    typealias TokenType = UserToken
}
