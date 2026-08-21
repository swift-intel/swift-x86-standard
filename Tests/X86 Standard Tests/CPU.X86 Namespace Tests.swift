import Testing

@testable import X86_Standard

@Suite("CPU.X86 Namespace Tests")
struct CPUX86NamespaceTests {
    @Test
    func `CPU.X86 namespace exists`() {

        typealias X86 = CPU.X86
        #expect(true)
    }

    @Test
    func `CPU.X86.Identification namespace exists`() {
        typealias Identification = CPU.X86.Identification
        #expect(true)
    }

    @Test
    func `CPU.X86.Random namespace exists`() {
        typealias Random = CPU.X86.Random
        #expect(true)
    }

    @Test
    func `CPU.X86.Timestamp namespace exists`() {
        typealias Timestamp = CPU.X86.Timestamp
        #expect(true)
    }

    @Test
    func `CPU.X86.Vector reserved namespace exists`() {
        typealias Vector = CPU.X86.Vector
        #expect(true)
    }

    @Test
    func `CPU.X86.Crypto reserved namespace exists`() {
        typealias Crypto = CPU.X86.Crypto
        #expect(true)
    }

    @Test
    func `Re-exported CPU primitives are accessible`() {

        typealias Spin = CPU.Spin
        typealias Barrier = CPU.Barrier
        typealias Cache = CPU.Cache
        typealias Timestamp = CPU.Timestamp
        typealias Integrity = CPU.Integrity

        CPU.Spin.hint()
        CPU.Barrier.compiler()
        let _ = CPU.Timestamp.read()

        #expect(true)
    }
}
