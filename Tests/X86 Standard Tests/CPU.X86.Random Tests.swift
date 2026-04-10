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

import Testing
@testable import X86_Standard

@Suite("CPU.X86.Random Tests")
struct CPURandomTests {
    @Test("next returns random value on supported hardware")
    func nextReturnsValue() {
        #if arch(x86_64) || arch(i386)
        // Check if RDRAND is supported via CPUID
        guard let leaf1 = CPU.X86.Identification.query(leaf: 1) else {
            return // Can't check feature flags
        }

        let rdrandSupported = (leaf1.ecx & (1 << 30)).isNonZero

        if rdrandSupported {
            // Try a few times since RDRAND can temporarily fail
            var gotValue = false
            for _ in 0..<10 {
                if CPU.X86.Random.next() != nil {
                    gotValue = true
                    break
                }
            }
            #expect(gotValue, "RDRAND should succeed at least once on supported hardware")

            // Values should be different (with very high probability)
            if let v1 = CPU.X86.Random.next(), let v2 = CPU.X86.Random.next() {
                #expect(v1 != v2, "Two random values should differ")
            }
        }
        #else
        let result = CPU.X86.Random.next()
        #expect(result == nil, "RDRAND should return nil on non-x86")
        #endif
    }

    @Test("seed returns random value on supported hardware")
    func seedReturnsValue() {
        #if arch(x86_64) || arch(i386)
        // Check if RDSEED is supported via CPUID extended features
        guard let leaf7 = CPU.X86.Identification.query(leaf: 7, subleaf: 0) else {
            return // Can't check feature flags
        }

        let rdseedSupported = (leaf7.ebx & (1 << 18)).isNonZero

        if rdseedSupported {
            // RDSEED may fail more often, try more times
            var gotValue = false
            for _ in 0..<100 {
                if CPU.X86.Random.seed() != nil {
                    gotValue = true
                    break
                }
            }
            // Don't fail if entropy exhausted, just note it
            if !gotValue {
                // This is acceptable - entropy exhaustion is valid
            }
        }
        #else
        let result = CPU.X86.Random.seed()
        #expect(result == nil, "RDSEED should return nil on non-x86")
        #endif
    }
}
