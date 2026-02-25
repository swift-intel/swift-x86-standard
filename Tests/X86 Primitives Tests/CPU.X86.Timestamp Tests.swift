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
@testable import X86_Primitives

@Suite("CPU.X86.Timestamp Tests")
struct CPUTimestampTests {
    @Test("serialized read returns non-zero on x86")
    func serializedReadReturnsValue() {
        let (value, _) = CPU.X86.Timestamp.read.serialized()

        #if arch(x86_64) || arch(i386)
        #expect(value > 0, "RDTSCP should return non-zero on x86")
        #else
        #expect(value == 0, "RDTSCP should return 0 on non-x86")
        #endif
    }

    @Test("serialized read values increase")
    func serializedReadIncreases() {
        #if arch(x86_64) || arch(i386)
        let (v1, _) = CPU.X86.Timestamp.read.serialized()
        let (v2, _) = CPU.X86.Timestamp.read.serialized()

        // On same core, values should increase
        // (though wraparound is theoretically possible)
        #expect(v2 >= v1, "Timestamp should not decrease between reads")
        #else
        // Skip on non-x86
        #endif
    }

    @Test("serialized read returns processor ID")
    func serializedReadWithProcessorID() {
        let (value, processorID) = CPU.X86.Timestamp.read.serialized()

        #if arch(x86_64) || arch(i386)
        #expect(value > 0, "RDTSCP should return non-zero")
        // processorID is valid but we can't assert much about it
        // It's typically set by the OS in IA32_TSC_AUX
        _ = processorID
        #else
        #expect(value == 0)
        #expect(processorID == 0)
        #endif
    }

    @Test("accessor pattern works")
    func accessorPatternWorks() {
        // Verify the nested accessor pattern compiles and works
        let read = CPU.X86.Timestamp.read
        let _ = read.serialized()
    }
}
