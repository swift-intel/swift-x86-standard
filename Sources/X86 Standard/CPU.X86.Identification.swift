public import x86_Shims

extension CPU.X86 {

    public enum Identification {}
}

extension CPU.X86.Identification {

    @inline(always)
    public static func query(leaf: Leaf) -> Result? {
        var eax: UInt32 = 0
        var ebx: UInt32 = 0
        var ecx: UInt32 = 0
        var edx: UInt32 = 0

        let success = unsafe swift_x86_identification_query_v1(
            leaf.rawValue,
            &eax,
            &ebx,
            &ecx,
            &edx
        )

        guard success else { return nil }
        return Result(
            eax: .init(eax),
            ebx: .init(ebx),
            ecx: .init(ecx),
            edx: .init(edx)
        )
    }

    @inline(always)
    public static func query(leaf: Leaf, subleaf: Subleaf) -> Result? {
        var eax: UInt32 = 0
        var ebx: UInt32 = 0
        var ecx: UInt32 = 0
        var edx: UInt32 = 0

        let success = unsafe swift_x86_identification_query_subleaf_v1(
            leaf.rawValue,
            subleaf.rawValue,
            &eax,
            &ebx,
            &ecx,
            &edx
        )

        guard success else { return nil }
        return Result(
            eax: .init(eax),
            ebx: .init(ebx),
            ecx: .init(ecx),
            edx: .init(edx)
        )
    }
}
