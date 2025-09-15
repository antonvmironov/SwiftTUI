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
         .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.2")
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
            dependencies: ["SwiftTUI"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]),
    ]
)
