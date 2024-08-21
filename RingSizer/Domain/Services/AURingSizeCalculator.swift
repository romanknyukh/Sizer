enum AURingSize {
    case f
    case g
    case h
    case i
    case j
    case k
    case l
    case m
    case n
    case o
    case p
    case q
    case r
    case s
    case t
    case u
    case v
    case w
    case x
    case y
    case z

    var name: String {
        switch self {
        case .f:
            return "F"
        case .g:
            return "G"
        case .h:
            return "H"
        case .i:
            return "I"
        case .j:
            return "J"
        case .k:
            return "K"
        case .l:
            return "L"
        case .m:
            return "M"
        case .n:
            return "N"
        case .o:
            return "O"
        case .p:
            return "P"
        case .q:
            return "Q"
        case .r:
            return "R"
        case .s:
            return "S"
        case .t:
            return "T"
        case .u:
            return "U"
        case .v:
            return "V"
        case .w:
            return "W"
        case .x:
            return "X"
        case .y:
            return "Y"
        case .z:
            return "Z"
        }
    }
}

final class AURingSizeCalculator: RingSizeCalculator {
    func calculate(sizeInMM: Float) -> AURingSize {
        switch sizeInMM {
        case ..<14.1:
            return .f
        case 14.1..<14.45:
            return .g
        case 14.45..<14.86:
            return .h
        case 14.86..<15.27:
            return .i
        case 15.27..<15.71:
            return .j
        case 15.71..<16.1:
            return .k
        case 16.1..<16.51:
            return .l
        case 16.51..<16.92:
            return .m
        case 16.92..<17.35:
            return .n
        case 17.35..<17.75:
            return .o
        case 17.75..<18.19:
            return .p
        case 18.19..<18.53:
            return .q
        case 18.53..<18.89:
            return .r
        case 18.89..<19.41:
            return .s
        case 19.41..<19.84:
            return .t
        case 19.84..<20.2:
            return .u
        case 20.2..<20.68:
            return .v
        case 20.68..<21.08:
            return .w
        case 21.08..<21.49:
            return .x
        case 21.49..<21.89:
            return .y
        case 21.89..<22.33:
            return .z
        default:
            return .z
        }
    }
}
