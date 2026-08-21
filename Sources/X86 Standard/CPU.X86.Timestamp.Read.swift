public import x86_Shims

extension CPU.X86.Timestamp {

    public struct Read: Sendable {
        @usableFromInline
        internal init() {}
    }
}

extension CPU.X86.Timestamp.Read {

    @inline(always)
    public func serialized() -> (value: CPU.Timestamp, processor: CPU.X86.Processor.ID) {
        var processorID: UInt32 = 0
        let timestamp = unsafe swift_x86_timestamp_serialized_v1(&processorID)
        return (.init(timestamp), .init(processorID))
    }
}
