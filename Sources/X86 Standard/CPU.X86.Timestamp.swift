extension CPU.X86 {

    public enum Timestamp {}
}

extension CPU.X86.Timestamp {

    public static var read: Read { Read() }
}
