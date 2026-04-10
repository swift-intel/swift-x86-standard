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

@Suite("CPU.X86 Namespace Tests")
struct CPUX86NamespaceTests {
    @Test("CPU.X86 namespace exists")
    func namespaceExists() {
        // Verify the namespace compiles
        typealias X86 = CPU.X86
        #expect(true)
    }

    @Test("CPU.X86.Identification namespace exists")
    func identificationNamespaceExists() {
        typealias Identification = CPU.X86.Identification
        #expect(true)
    }

    @Test("CPU.X86.Random namespace exists")
    func randomNamespaceExists() {
        typealias Random = CPU.X86.Random
        #expect(true)
    }

    @Test("CPU.X86.Timestamp namespace exists")
    func timestampNamespaceExists() {
        typealias Timestamp = CPU.X86.Timestamp
        #expect(true)
    }

    @Test("CPU.X86.Vector reserved namespace exists")
    func vectorNamespaceExists() {
        typealias Vector = CPU.X86.Vector
        #expect(true)
    }

    @Test("CPU.X86.Crypto reserved namespace exists")
    func cryptoNamespaceExists() {
        typealias Crypto = CPU.X86.Crypto
        #expect(true)
    }

    @Test("Re-exported CPU primitives are accessible")
    func reExportedPrimitivesAccessible() {
        // Verify CPU primitives from swift-cpu-primitives are accessible
        // These should be re-exported via @_exported import
        typealias Spin = CPU.Spin
        typealias Barrier = CPU.Barrier
        typealias Cache = CPU.Cache
        typealias Timestamp = CPU.Timestamp
        typealias Integrity = CPU.Integrity

        // Also test that we can call them
        CPU.Spin.hint()
        CPU.Barrier.compiler()
        let _ = CPU.Timestamp.read()

        #expect(true)
    }
}
