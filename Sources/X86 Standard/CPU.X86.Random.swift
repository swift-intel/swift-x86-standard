public import x86_Shims

extension CPU.X86 {

    public enum Random {}
}

extension CPU.X86.Random {

    @inline(always)
    public static func next() -> Value? {
        var value: UInt64 = 0
        let success = unsafe swift_x86_random_next_v1(&value)
        guard success else { return nil }
        return .init(value)
    }

    @inline(always)
    public static func seed() -> Seed? {
        var value: UInt64 = 0
        let success = unsafe swift_x86_random_seed_v1(&value)
        guard success else { return nil }
        return .init(value)
    }
}
