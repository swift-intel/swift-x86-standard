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

extension CPU.X86 {
    /// x86-specific timestamp variants.
    ///
    /// For portable timestamp access, use `CPU.Timestamp.read()`.
    /// This namespace provides x86-unique variants.
    public enum Timestamp {}
}

extension CPU.X86.Timestamp {
    /// Accessor for read operations.
    public static var read: Read { Read() }
}
