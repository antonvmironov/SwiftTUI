// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Colors",
    platforms: [
        .macOS(.v26),
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
