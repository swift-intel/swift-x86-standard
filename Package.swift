// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-x86-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "X86 Primitives",
            targets: ["X86 Primitives"]
        )
    ],
    dependencies: [
        .package(path: "../swift-cpu-primitives")
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
                .product(name: "CPU Primitives", package: "swift-cpu-primitives")
            ]
        ),
        .testTarget(
            name: "X86 Primitives Tests",
            dependencies: [
                "X86 Primitives",
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
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
