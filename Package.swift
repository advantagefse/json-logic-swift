// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "jsonlogic",
    products: [
        .library(
            name: "jsonlogic",
            targets: ["jsonlogic"]),
        .executable(
            name: "jsonlogic-cli",
            targets: ["jsonlogic-cli"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/dankogai/swift-json.git", from: "4.0.0"
        )
    ],
    targets: [
        .target(
            name: "jsonlogic-cli",
            dependencies: ["jsonlogic"]),
        .target(
            name: "jsonlogic",
            dependencies: ["JSON"]),
        .testTarget(
            name: "jsonlogicTests",
            dependencies: ["jsonlogic"])
    ]
)
