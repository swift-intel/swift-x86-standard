public import x86_Shims

extension CPU.X86 {

    public enum Random {}
}

extension CPU.X86.Random {

    @inline(always)
    public static func next() -> Value? {
        guard available.next else { return nil }
        var value: UInt64 = 0
        let success = unsafe swift_x86_random_next_v1(&value)
        guard success else { return nil }
        return .init(value)
    }

    @inline(always)
    public static func seed() -> Seed? {
        guard available.seed else { return nil }
        var value: UInt64 = 0
        let success = unsafe swift_x86_random_seed_v1(&value)
        guard success else { return nil }
        return .init(value)
    }
}

extension CPU.X86.Random {

    @usableFromInline
    static let available: (next: Bool, seed: Bool) = (
        next: CPU.X86.Identification.query(leaf: 1).map { $0.ecx.rawValue & (1 << 30) != 0 } ?? false,
        seed: CPU.X86.Identification.query(leaf: 7, subleaf: 0).map { $0.ebx.rawValue & (1 << 18) != 0 }
            ?? false
    )
}
