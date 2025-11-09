// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Translucent",
    products: [
        .library(
            name: "Translucent",
            targets: ["Translucent"])
    ],
    dependencies: [.package(url: "https://github.com/devicekit/DeviceKit", .upToNextMajor(from: .init(stringLiteral: "5.0.0")))],
    targets: [
        .target(
            name: "Translucent",
            dependencies: ["DeviceKit"],
            resources: [
                .process("mappings.json"),
                .process("mappings-ios-18.json")
            ]),
        .testTarget(
            name: "TranslucentTests",
            dependencies: ["Translucent"],
            resources: [
                .process("white.jpeg")
            ]
        ),
    ]
)
