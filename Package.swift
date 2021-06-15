// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "jsonlogic",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "jsonlogic",
            targets: ["jsonlogic"]),
        .library(
            name: "JSON",
            targets: ["JSON"]),
        .executable(
            name: "jsonlogic-cli",
            targets: ["jsonlogic-cli"]),
    ],
    targets: [
        .target(
            name: "jsonlogic-cli",
            dependencies: ["jsonlogic"]),
        .target(
            name: "jsonlogic",
            dependencies: ["JSON"]),
        .target(
            name: "JSON",
            dependencies: []),
        .testTarget(
            name: "jsonlogicTests",
            dependencies: ["jsonlogic"]),
        .testTarget(
            name: "JSONTests",
            dependencies: ["JSON"])
    ],
    swiftLanguageVersions: [.v5, .v4_2, .v4]
)
