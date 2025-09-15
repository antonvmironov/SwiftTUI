// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Numbers",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "Numbers",
            dependencies: ["SwiftTUI"]),
        .testTarget(
            name: "NumbersTests",
            dependencies: ["Numbers"]),
    ]
)
