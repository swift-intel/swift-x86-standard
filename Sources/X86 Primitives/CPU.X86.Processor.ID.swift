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

extension CPU.X86.Processor {
    /// Processor ID from IA32_TSC_AUX MSR.
    ///
    /// This value is returned by RDTSCP and can be used to detect
    /// if the thread migrated between cores during a measurement.
    public struct ID: Sendable, Hashable, RawRepresentable, ExpressibleByIntegerLiteral {
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
    }
}

// MARK: - Binary.Serializable

extension CPU.X86.Processor.ID: Binary.Serializable {}
