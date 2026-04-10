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

extension CPU.X86.Timestamp {
    /// Timestamp read operation accessor.
    public struct Read: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.X86.Timestamp.Read {
    /// Serialized read via RDTSCP.
    ///
    /// Waits for all prior instructions to complete before reading
    /// the timestamp counter. This provides stronger ordering guarantees
    /// than the portable `CPU.Timestamp.read()` which uses RDTSC.
    ///
    /// Also returns the processor ID (from the IA32_TSC_AUX MSR), which
    /// can be used to detect if the thread migrated between cores during
    /// measurement.
    ///
    /// x86-unique. Returns (0, 0) on non-x86 platforms.
    ///
    /// - Returns: A tuple containing the timestamp and processor ID.
    @inline(always)
    public func serialized() -> (value: CPU.Timestamp, processor: CPU.X86.Processor.ID) {
        var processorID: UInt32 = 0
        let timestamp = unsafe swift_x86_timestamp_serialized_v1(&processorID)
        return (.init(timestamp), .init(processorID))
    }
}
