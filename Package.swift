// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftTUI",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "SwiftTUI",
            targets: ["SwiftTUI"]),
        .executable(
            name: "SwiftTUIApp",
            targets: ["SwiftTUIApp"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.2"),
        .package(url: "https://github.com/swiftlang/swift-testing", from: "6.2.0"),
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            .upToNextMinor(from: "1.6.1")
        ),
        .package(
            url: "https://github.com/apple/swift-container-plugin",
            from: "1.1.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "SwiftTUIApp",
            dependencies: [
                "SwiftTUI",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            swiftSettings: [
            ]
        ),
        .target(
            name: "SwiftTUI",
            dependencies: [
            ],
            swiftSettings: [
            ]),
        .testTarget(
            name: "SwiftTUITests",
            dependencies: [
                "SwiftTUI",
                .product(name: "Testing", package: "swift-testing"),
            ],
            swiftSettings: [
            ]),
    ]
)

