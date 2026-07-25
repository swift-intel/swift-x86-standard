# swift-x86-standard

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Typed Swift access to x86 processor facilities, including CPUID-based feature detection.

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-intel/swift-x86-standard.git", branch: "main")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "X86 Standard", package: "swift-x86-standard")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
