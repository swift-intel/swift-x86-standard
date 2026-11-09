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
        guard Self.available else { return (.init(0), .init(0)) }
        var processorID: UInt32 = 0
        let timestamp = unsafe swift_x86_timestamp_serialized_v1(&processorID)
        return (.init(timestamp), .init(processorID))
    }
}

extension CPU.X86.Timestamp.Read {

    @usableFromInline
    static let available: Bool =
        CPU.X86.Identification.query(leaf: 0x8000_0001).map { $0.edx.rawValue & (1 << 27) != 0 } ?? false
}
