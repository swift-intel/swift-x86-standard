// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-x86-standard",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27")
    ],
    products: [
        .library(
            name: "X86 Standard",
            targets: ["X86 Standard"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-cpu-primitives.git", branch: "main")
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
                .product(name: "CPU Primitives", package: "swift-cpu-primitives")
            ]
        ),
        .testTarget(
            name: "X86 Standard Tests",
            dependencies: [
                "X86 Standard",
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
