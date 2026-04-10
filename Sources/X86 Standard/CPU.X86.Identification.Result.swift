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
    /// Result of a CPUID query.
    ///
    /// Contains the values of all four general-purpose registers
    /// after executing CPUID with the specified leaf (and subleaf).
    public struct Result: Sendable, Equatable {
        /// The EAX register value.
        public let eax: Register

        /// The EBX register value.
        public let ebx: Register

        /// The ECX register value.
        public let ecx: Register

        /// The EDX register value.
        public let edx: Register

        /// Creates a CPUID result from register values.
        public init(eax: Register, ebx: Register, ecx: Register, edx: Register) {
            self.eax = eax
            self.ebx = ebx
            self.ecx = ecx
            self.edx = edx
        }
    }
}
