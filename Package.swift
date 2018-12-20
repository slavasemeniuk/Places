// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Places",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.1.0"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0")
        ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentMySQL", "Authentication"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
        ]
)
