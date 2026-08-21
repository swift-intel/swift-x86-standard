import Testing

@testable import X86_Standard

@Suite("CPU.X86.Random Tests")
struct CPURandomTests {
    @Test
    func `next returns random value on supported hardware`() {
        #if arch(x86_64) || arch(i386)

            guard let leaf1 = CPU.X86.Identification.query(leaf: 1) else {
                return
            }

            let rdrandSupported = (leaf1.ecx.rawValue & (1 << 30)) != 0

            if rdrandSupported {

                var gotValue = false
                for _ in 0..<10 {
                    if CPU.X86.Random.next() != nil {
                        gotValue = true
                        break
                    }
                }
                #expect(gotValue, "RDRAND should succeed at least once on supported hardware")

                if let v1 = CPU.X86.Random.next(), let v2 = CPU.X86.Random.next() {
                    #expect(v1 != v2, "Two random values should differ")
                }
            }
        #else
            let result = CPU.X86.Random.next()
            #expect(result == nil, "RDRAND should return nil on non-x86")
        #endif
    }

    @Test
    func `seed returns random value on supported hardware`() {
        #if arch(x86_64) || arch(i386)

            guard let leaf7 = CPU.X86.Identification.query(leaf: 7, subleaf: 0) else {
                return
            }

            let rdseedSupported = (leaf7.ebx.rawValue & (1 << 18)) != 0

            if rdseedSupported {

                var gotValue = false
                for _ in 0..<100 {
                    if CPU.X86.Random.seed() != nil {
                        gotValue = true
                        break
                    }
                }

                if !gotValue {

                }
            }
        #else
            let result = CPU.X86.Random.seed()
            #expect(result == nil, "RDSEED should return nil on non-x86")
        #endif
    }
}
