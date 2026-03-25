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

internal import CX86Shim

extension CPU.X86 {
    /// CPU feature detection via CPUID instruction.
    ///
    /// x86-unique. ARM uses system registers for feature detection.
    public enum Identification {}
}

extension CPU.X86.Identification {
    /// Query with the given leaf.
    ///
    /// Returns the values of EAX, EBX, ECX, and EDX registers after
    /// executing CPUID with the specified leaf.
    ///
    /// - Parameter leaf: The CPUID leaf to query.
    /// - Returns: The register values, or `nil` if the operation failed
    ///   (e.g., on non-x86 platforms).
    @inline(always)
    public static func query(leaf: Leaf) -> Result? {
        var eax: UInt32 = 0
        var ebx: UInt32 = 0
        var ecx: UInt32 = 0
        var edx: UInt32 = 0

        let success = unsafe swift_x86_identification_query_v1(
            leaf.rawValue,
            &eax,
            &ebx,
            &ecx,
            &edx
        )

        guard success else { return nil }
        return Result(
            eax: .init(eax),
            ebx: .init(ebx),
            ecx: .init(ecx),
            edx: .init(edx)
        )
    }

    /// Query with leaf and subleaf.
    ///
    /// Returns the values of EAX, EBX, ECX, and EDX registers after
    /// executing CPUID with the specified leaf and subleaf (ECX input).
    ///
    /// - Parameters:
    ///   - leaf: The CPUID leaf to query.
    ///   - subleaf: The subleaf (ECX input) to query.
    /// - Returns: The register values, or `nil` if the operation failed
    ///   (e.g., on non-x86 platforms).
    @inline(always)
    public static func query(leaf: Leaf, subleaf: Subleaf) -> Result? {
        var eax: UInt32 = 0
        var ebx: UInt32 = 0
        var ecx: UInt32 = 0
        var edx: UInt32 = 0

        let success = unsafe swift_x86_identification_query_subleaf_v1(
            leaf.rawValue,
            subleaf.rawValue,
            &eax,
            &ebx,
            &ecx,
            &edx
        )

        guard success else { return nil }
        return Result(
            eax: .init(eax),
            ebx: .init(ebx),
            ecx: .init(ecx),
            edx: .init(edx)
        )
    }
}
