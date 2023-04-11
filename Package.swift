// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "carbon-logger-backend",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.75.1"),
        .package(url: "https://github.com/mongodb/mongodb-vapor", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/thomasburguiere/carbonlog-swift-lib", branch: "develop"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "MongoDBVapor", package: "mongodb-vapor"),
                .product(name: "CarbonLogLib", package: "carbonlog-swift-lib"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(
            name: "Run",
            dependencies: [
                .target(name: "App"),
                .product(name: "MongoDBVapor", package: "mongodb-vapor"),
                .product(name: "CarbonLogLib", package: "carbonlog-swift-lib"),
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
                .product(name: "CarbonLogLib", package: "carbonlog-swift-lib"),
            ]
        ),
    ]
)
