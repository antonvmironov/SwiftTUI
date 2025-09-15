// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Colors",
    platforms: [
        .macOS(.v11),
    ],
    dependencies: [
        .package(path: "../../"),
    ],
    targets: [
        .executableTarget(
            name: "Colors",
            dependencies: ["SwiftTUI"]
        ),
    ]
)
