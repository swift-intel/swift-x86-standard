// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-x86-primitives open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-x86-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension CPU.X86.Random {
    /// A random value from RDRAND.
    public struct Value: Sendable, Hashable, RawRepresentable, ExpressibleByIntegerLiteral {
        public var rawValue: UInt64

        @inlinable
        public init(rawValue: UInt64) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(_ rawValue: UInt64) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(integerLiteral value: UInt64) {
            self.rawValue = value
        }
    }
}

// MARK: - Binary.Serializable

extension CPU.X86.Random.Value: Binary.Serializable {}
