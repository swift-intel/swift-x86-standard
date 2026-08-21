extension CPU.X86.Identification {

    public struct Result: Sendable, Equatable {

        public let eax: Register

        public let ebx: Register

        public let ecx: Register

        public let edx: Register

        public init(eax: Register, ebx: Register, ecx: Register, edx: Register) {
            self.eax = eax
            self.ebx = ebx
            self.ecx = ecx
            self.edx = edx
        }
    }
}
