// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SwiftTUI",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftTUI",
            targets: ["SwiftTUI"]),
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.2"),
         .package(url: "https://github.com/swiftlang/swift-testing", from: "0.10.0")
    ],
    targets: [
        .target(
            name: "SwiftTUI",
            dependencies: [],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]),
        .testTarget(
            name: "SwiftTUITests",
            dependencies: ["SwiftTUI", .product(name: "Testing", package: "swift-testing")],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]),
    ]
)
