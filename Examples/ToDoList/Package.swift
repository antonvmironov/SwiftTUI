// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ToDoList",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "ToDoList",
            dependencies: ["SwiftTUI"]),
        .testTarget(
            name: "ToDoListTests",
            dependencies: ["ToDoList"]),
    ]
)
