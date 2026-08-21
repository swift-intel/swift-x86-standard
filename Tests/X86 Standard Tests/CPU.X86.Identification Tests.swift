import Testing

@testable import X86_Standard

@Suite("CPU.X86.Identification Tests")
struct CPUIdentificationTests {
    @Test
    func `query leaf 0 returns vendor string`() {
        #if arch(x86_64) || arch(i386)
            guard let result = CPU.X86.Identification.query(leaf: 0) else {
                Issue.record("CPUID leaf 0 failed on x86")
                return
            }

            #expect(result.eax >= 1, "Max leaf should be at least 1")

            let ebx = result.ebx.rawValue
            let edx = result.edx.rawValue
            let ecx = result.ecx.rawValue
            let vendorBytes =
                withUnsafeBytes(of: ebx) { Array($0) }
                + withUnsafeBytes(of: edx) { Array($0) }
                + withUnsafeBytes(of: ecx) { Array($0) }

            let vendor = String(decoding: vendorBytes, as: UTF8.self)
            #expect(!vendor.isEmpty, "Vendor string should not be empty")
        #else

            let result = CPU.X86.Identification.query(leaf: 0)
            #expect(result == nil, "CPUID should return nil on non-x86")
        #endif
    }

    @Test
    func `query leaf 1 returns feature flags`() {
        #if arch(x86_64) || arch(i386)
            guard let result = CPU.X86.Identification.query(leaf: 1) else {
                Issue.record("CPUID leaf 1 failed on x86")
                return
            }

            let hasFPU = (result.edx.rawValue & 1) != 0
            #expect(hasFPU, "FPU bit should be set")
        #else
            let result = CPU.X86.Identification.query(leaf: 1)
            #expect(result == nil)
        #endif
    }

    @Test
    func `query with subleaf works`() {
        #if arch(x86_64) || arch(i386)

            guard let leaf0 = CPU.X86.Identification.query(leaf: 0) else {
                Issue.record("CPUID leaf 0 failed")
                return
            }

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
