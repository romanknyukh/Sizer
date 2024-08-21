enum JPRingSize {
    case s4
    case s6
    case s7
    case s8
    case s9
    case s11
    case s12
    case s13
    case s14
    case s15
    case s16
    case s17
    case s18
    case s19
    case s20
    case s22
    case s23
    case s24
    case s25
    case s26
    case s27

    var name: String {
        switch self {
        case .s4:
            return "4"
        case .s6:
            return "6"
        case .s7:
            return "7"
        case .s8:
            return "8"
        case .s9:
            return "9"
        case .s11:
            return "11"
        case .s12:
            return "12"
        case .s13:
            return "13"
        case .s14:
            return "14"
        case .s15:
            return "15"
        case .s16:
            return "16"
        case .s17:
            return "17"
        case .s18:
            return "18"
        case .s19:
            return "19"
        case .s20:
            return "20"
        case .s22:
            return "22"
        case .s23:
            return "23"
        case .s24:
            return "24"
        case .s25:
            return "25"
        case .s26:
            return "26"
        case .s27:
            return "27"
        }
    }
}

final class JPRingSizeCalculator: RingSizeCalculator {
    func calculate(sizeInMM: Float) -> JPRingSize {
        switch sizeInMM {
        case ..<14.1:
            return .s4
        case 14.1..<14.45:
            return .s6
        case 14.45..<14.86:
            return .s7
        case 14.86..<15.27:
            return .s8
        case 15.27..<15.71:
            return .s9
        case 15.71..<16.1:
            return .s11
        case 16.1..<16.51:
            return .s12
        case 16.51..<16.92:
            return .s13
        case 16.92..<17.35:
            return .s14
        case 17.35..<17.75:
            return .s15
        case 17.75..<18.19:
            return .s16
        case 18.19..<18.53:
            return .s17
        case 18.53..<18.89:
            return .s18
        case 18.89..<19.41:
            return .s19
        case 19.41..<19.84:
            return .s20
        case 19.84..<20.2:
            return .s22
        case 20.2..<20.68:
            return .s23
        case 20.68..<21.08:
            return .s24
        case 21.08..<21.49:
            return .s25
        case 21.49..<21.89:
            return .s26
        case 21.89..<22.33:
            return .s27
        default:
            return .s27
        }
    }
}
