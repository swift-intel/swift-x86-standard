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

@Suite("CPU.X86.Identification Tests")
struct CPUIdentificationTests {
    @Test("query leaf 0 returns vendor string")
    func queryLeafZero() {
        #if arch(x86_64) || arch(i386)
        guard let result = CPU.X86.Identification.query(leaf: 0) else {
            Issue.record("CPUID leaf 0 failed on x86")
            return
        }

        // EAX contains max supported leaf
        #expect(result.eax >= 1, "Max leaf should be at least 1")

        // EBX, EDX, ECX contain vendor string (12 bytes)
        // Common vendors: "GenuineIntel", "AuthenticAMD"
        let ebx = result.ebx.rawValue
        let edx = result.edx.rawValue
        let ecx = result.ecx.rawValue
        let vendorBytes = withUnsafeBytes(of: ebx) { Array($0) }
            + withUnsafeBytes(of: edx) { Array($0) }
            + withUnsafeBytes(of: ecx) { Array($0) }

        let vendor = String(bytes: vendorBytes, encoding: .ascii) ?? ""
        #expect(!vendor.isEmpty, "Vendor string should not be empty")
        #else
        // Non-x86: should return nil
        let result = CPU.X86.Identification.query(leaf: 0)
        #expect(result == nil, "CPUID should return nil on non-x86")
        #endif
    }

    @Test("query leaf 1 returns feature flags")
    func queryLeafOne() {
        #if arch(x86_64) || arch(i386)
        guard let result = CPU.X86.Identification.query(leaf: 1) else {
            Issue.record("CPUID leaf 1 failed on x86")
            return
        }

        // EDX bit 0 = FPU, should be set on any modern x86
        let hasFPU = (result.edx & 1).isNonZero
        #expect(hasFPU, "FPU bit should be set")
        #else
        let result = CPU.X86.Identification.query(leaf: 1)
        #expect(result == nil)
        #endif
    }

    @Test("query with subleaf works")
    func queryWithSubleaf() {
        #if arch(x86_64) || arch(i386)
        // Extended topology enumeration (leaf 0x0B)
        guard let leaf0 = CPU.X86.Identification.query(leaf: 0) else {
            Issue.record("CPUID leaf 0 failed")
            return
        }

        // Only test if leaf 0x0B is supported
        if leaf0.eax >= 0x0B {
            let result = CPU.X86.Identification.query(leaf: 0x0B, subleaf: 0)
            #expect(result != nil, "Subleaf query should succeed when leaf is supported")
        }
        #else
        let result = CPU.X86.Identification.query(leaf: 0x0B, subleaf: 0)
        #expect(result == nil)
        #endif
    }
}
