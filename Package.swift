// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlashCard",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FlashCard",
            targets: ["FlashCard"]),
    ],
    targets: [
        .target(
            name: "FlashCard",
            resources: [
                .process("Resources/Media.xcassets")
            ]
        ),
        .testTarget(
            name: "FlashCardTests",
            dependencies: ["FlashCard"]
        ),
    ]
)
