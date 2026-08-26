// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-x86-standard",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "X86 Standard",
            targets: ["X86 Standard"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-cpu.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "x86 Shims",
            dependencies: []
        ),
        .target(
            name: "X86 Standard",
            dependencies: [
                .target(name: "x86 Shims"),
                .product(name: "CPU", package: "swift-cpu"),
            ]
        ),
        .testTarget(
            name: "X86 Standard Tests",
            dependencies: [
                "X86 Standard"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
