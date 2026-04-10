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

/// x86/x64 ISA-unique primitives.
///
/// Operations in this namespace have no ARM equivalent.
/// For portable operations, use `CPU.*` directly.
@_exported public import CPU_Primitives

extension CPU {
    /// x86/x64 architecture-unique primitives.
    public enum X86 {}
}
