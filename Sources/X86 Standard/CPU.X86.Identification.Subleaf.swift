extension CPU.X86.Identification {

    public struct Subleaf: Sendable, Hashable, RawRepresentable, Comparable,
        ExpressibleByIntegerLiteral
    {
        public var rawValue: UInt32

        @inlinable
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(_ rawValue: UInt32) {
            self.rawValue = rawValue
        }

        @inlinable
        public init(integerLiteral value: UInt32) {
            self.rawValue = value
        }
    }
}

extension CPU.X86.Identification.Subleaf {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension CPU.X86.Identification.Subleaf: Binary.Serializable {}
