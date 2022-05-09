// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JsonLogic",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "JsonLogic",
            targets: ["JsonLogic"]),
        .library(
            name: "JSON",
            targets: ["JSON"]),
        .executable(
            name: "JsonLogic-cli",
            targets: ["JsonLogic-cli"]),
    ],
    
    targets: [
        .target(
            name: "JsonLogic-cli",
            dependencies: ["JsonLogic"]),
        .target(
            name: "JsonLogic",
            dependencies: ["JSON"]),
        .target(
            name: "JSON",
            dependencies: []),
        .testTarget(
            name: "JsonLogicTests",
            dependencies: ["JsonLogic"]),
        .testTarget(
            name: "JSONTests",
            dependencies: ["JSON"])
    ],
    
    swiftLanguageVersions: [.v5, .v4_2, .v4]
)
