enum USRingSize {
    case s3
    case s3_5
    case s4
    case s4_5
    case s5
    case s5_5
    case s6
    case s6_5
    case s7
    case s7_5
    case s8
    case s8_5
    case s9
    case s9_5
    case s10
    case s10_5
    case s11
    case s11_5
    case s12
    case s12_5
    case s13

    var name: String {
        switch self {
        case .s3:
            return "3"
        case .s3_5:
            return "3.5"
        case .s4:
            return "4"
        case .s4_5:
            return "4.5"
        case .s5:
            return "5"
        case .s5_5:
            return "5.5"
        case .s6:
            return "6"
        case .s6_5:
            return "6.5"
        case .s7:
            return "7"
        case .s7_5:
            return "7.5"
        case .s8:
            return "8"
        case .s8_5:
            return "8.5"
        case .s9:
            return "9"
        case .s9_5:
            return "9.5"
        case .s10:
            return "10"
        case .s10_5:
            return "10.5"
        case .s11:
            return "11"
        case .s11_5:
            return "11.5"
        case .s12:
            return "12"
        case .s12_5:
            return "12.5"
        case .s13:
            return "13"
        }
    }
}

final class USRingSizeCalculator: RingSizeCalculator {
    func calculate(sizeInMM: Float) -> USRingSize {
        switch sizeInMM {
        case ..<14.1:
            return .s3
        case 14.1..<14.45:
            return .s3_5
        case 14.45..<14.86:
            return .s4
        case 14.86..<15.27:
            return .s4_5
        case 15.27..<15.71:
            return .s5
        case 15.71..<16.1:
            return .s5_5
        case 16.1..<16.51:
            return .s6
        case 16.51..<16.92:
            return .s6_5
        case 16.92..<17.35:
            return .s7
        case 17.35..<17.75:
            return .s7_5
        case 17.75..<18.19:
            return .s8
        case 18.19..<18.53:
            return .s8_5
        case 18.53..<18.89:
            return .s9
        case 18.89..<19.41:
            return .s9_5
        case 19.41..<19.84:
            return .s10
        case 19.84..<20.2:
            return .s10_5
        case 20.2..<20.68:
            return .s11
        case 20.68..<21.08:
            return .s11_5
        case 21.08..<21.49:
            return .s12
        case 21.49..<21.89:
            return .s12_5
        case 21.89..<22.33:
            return .s13
        default:
            return .s13
        }
    }
}
