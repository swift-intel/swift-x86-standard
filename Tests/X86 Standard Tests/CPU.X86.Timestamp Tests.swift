import Testing

@testable import X86_Standard

@Suite("CPU.X86.Timestamp Tests")
struct CPUTimestampTests {
    @Test
    func `serialized read returns non-zero on x86`() {
        let (value, _) = CPU.X86.Timestamp.read.serialized()

        #if arch(x86_64) || arch(i386)
            #expect(value.rawValue > 0, "RDTSCP should return non-zero on x86")
        #else
            #expect(value == 0, "RDTSCP should return 0 on non-x86")
        #endif
    }

    @Test
    func `serialized read values increase`() {
        #if arch(x86_64) || arch(i386)
            let (v1, _) = CPU.X86.Timestamp.read.serialized()
            let (v2, _) = CPU.X86.Timestamp.read.serialized()

            #expect(v2.rawValue >= v1.rawValue, "Timestamp should not decrease between reads")
        #else

        #endif
    }

    @Test
    func `serialized read returns processor ID`() {
        let (value, processorID) = CPU.X86.Timestamp.read.serialized()

        #if arch(x86_64) || arch(i386)
            #expect(value.rawValue > 0, "RDTSCP should return non-zero")

            _ = processorID
        #else
            #expect(value == 0)
            #expect(processorID == 0)
        #endif
    }

    @Test
    func `accessor pattern works`() {

        let read = CPU.X86.Timestamp.read
        let _ = read.serialized()
    }
}
