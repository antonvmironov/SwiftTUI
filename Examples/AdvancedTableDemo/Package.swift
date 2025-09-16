// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AdvancedTableDemo",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "AdvancedTableDemo",
            dependencies: [
                .product(name: "SwiftTUI", package: "SwiftTUI")
            ]
        )
    ]
)