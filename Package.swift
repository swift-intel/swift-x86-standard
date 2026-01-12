// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-x86-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "X86 Primitives",
            targets: ["X86 Primitives"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-cpu-primitives.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "CX86Shim",
            dependencies: []
        ),
        .target(
            name: "X86 Primitives",
            dependencies: [
                .target(name: "CX86Shim"),
                .product(name: "CPU Primitives", package: "swift-cpu-primitives"),
            ]
        ),
        .testTarget(
            name: "X86 Primitives Tests",
            dependencies: [
                "X86 Primitives",
            ],
            path: "Tests/X86 Primitives Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
