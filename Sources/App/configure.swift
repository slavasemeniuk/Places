import FluentMySQL
import Vapor
import Authentication

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    
    try services.register(FluentMySQLProvider())
    try services.register(AuthenticationProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    let mysqlConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306,
                                          username: Environment.get("DB_USERNAME")!,
                                          password: Environment.get("DB_PASSWORD")!,
                                          database: Environment.get("DATABASE_NAME")!)
    services.register(mysqlConfig)
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: UserToken.self, database: .mysql)
    services.register(migrations)
}
