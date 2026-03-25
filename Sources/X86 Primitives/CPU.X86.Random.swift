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

public import CX86Shim

extension CPU.X86 {
    /// Hardware random number generation.
    ///
    /// x86-unique. ARM has no equivalent hardware RNG instruction.
    public enum Random {}
}

extension CPU.X86.Random {
    /// Generate random number via RDRAND.
    ///
    /// RDRAND provides cryptographically secure random numbers from the
    /// CPU's digital random number generator (DRNG). The DRNG continuously
    /// reseeds itself from an on-chip entropy source.
    ///
    /// - Returns: A random value, or `nil` if the hardware RNG
    ///   is unavailable or temporarily exhausted.
    @inline(always)
    public static func next() -> Value? {
        var value: UInt64 = 0
        let success = unsafe swift_x86_random_next_v1(&value)
        guard success else { return nil }
        return .init(value)
    }

    /// Generate random seed via RDSEED.
    ///
    /// RDSEED provides direct access to the on-chip entropy source,
    /// suitable for seeding software PRNGs. Unlike RDRAND, RDSEED
    /// samples directly from the entropy conditioner without the
    /// DRNG buffer.
    ///
    /// RDSEED may fail more frequently than RDRAND when entropy is
    /// being consumed faster than it can be generated.
    ///
    /// - Returns: A random seed value, or `nil` if the entropy
    ///   source is unavailable or temporarily exhausted.
    @inline(always)
    public static func seed() -> Seed? {
        var value: UInt64 = 0
        let success = unsafe swift_x86_random_seed_v1(&value)
        guard success else { return nil }
        return .init(value)
    }
}
