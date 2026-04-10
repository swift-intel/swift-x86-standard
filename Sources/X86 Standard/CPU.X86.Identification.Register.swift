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

extension CPU.X86.Identification {
    /// A CPUID register value (EAX, EBX, ECX, or EDX).
    public struct Register: Sendable, Hashable, RawRepresentable, Comparable, ExpressibleByIntegerLiteral {
        public var rawValue: UInt32

        @inlinable
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(_ rawValue: UInt32) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(integerLiteral value: UInt32) {
            self.rawValue = value
        }

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}

// MARK: - Binary.Serializable

extension CPU.X86.Identification.Register: Binary.Serializable {}
