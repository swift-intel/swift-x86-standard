# swift-x86-standard

Use this package when you need instructions that only x86 processors have: CPUID queries, hardware random numbers from RDRAND and RDSEED, and a timestamp read that also tells you which processor it ran on. Start from `CPU.X86.Identification`, `CPU.X86.Random` or `CPU.X86.Timestamp`. For portable primitives such as barriers, spin hints and plain timestamp reads, use `CPU` from swift-cpu, which this package re-exports. On ARM, use swift-arm-standard.

## Laws

- The package builds on every architecture. Off x86, `CPU.X86.Identification.query(leaf:)`, `CPU.X86.Identification.query(leaf:subleaf:)`, `CPU.X86.Random.next()` and `CPU.X86.Random.seed()` return nil, and `CPU.X86.Timestamp.Read.serialized()` returns a zero timestamp and processor ID 0 rather than nil.
- When built with GCC or Clang, a CPUID query for a leaf above the highest one the processor supports returns nil. When built with MSVC, the query is always run and its result returned.
- `CPU.X86.Random.next()` and `CPU.X86.Random.seed()` make one attempt. Nil means the hardware had no value ready, and a later call can succeed.
- Two `CPU.X86.Timestamp.Read.serialized()` calls in a row never go backwards.
