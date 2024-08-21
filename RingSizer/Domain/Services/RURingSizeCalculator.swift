enum RURingSize {
    case s14
    case s14_5
    case s15
    case s15_5
    case s15_75
    case s16
    case s16_5
    case s17
    case s17_25
    case s17_75
    case s18
    case s18_5
    case s19
    case s19_5
    case s20
    case s20_25
    case s20_75
    case s21
    case s21_25
    case s21_75
    case s22

    var name: String {
        switch self {
        case .s14:
            return "14"
        case .s14_5:
            return "14.5"
        case .s15:
            return "15"
        case .s15_5:
            return "15.5"
        case .s15_75:
            return "15.75"
        case .s16:
            return "16"
        case .s16_5:
            return "16.5"
        case .s17:
            return "17"
        case .s17_25:
            return "17.25"
        case .s17_75:
            return "17.75"
        case .s18:
            return "18"
        case .s18_5:
            return "18.5"
        case .s19:
            return "19"
        case .s19_5:
            return "19.5"
        case .s20:
            return "20"
        case .s20_25:
            return "20.25"
        case .s20_75:
            return "20.75"
        case .s21:
            return "21"
        case .s21_25:
            return "21.25"
        case .s21_75:
            return "21.75"
        case .s22:
            return "22"
        }
    }
}

final class RURingSizeCalculator: RingSizeCalculator {
    func calculate(sizeInMM: Float) -> RURingSize {
        switch sizeInMM {
        case ..<14.1:
            return .s14
        case 14.1..<14.45:
            return .s14_5
        case 14.45..<14.86:
            return .s15
        case 14.86..<15.27:
            return .s15_5
        case 15.27..<15.71:
            return .s15_75
        case 15.71..<16.1:
            return .s16
        case 16.1..<16.51:
            return .s16_5
        case 16.51..<16.92:
            return .s17
        case 16.92..<17.35:
            return .s17_25
        case 17.35..<17.75:
            return .s17_75
        case 17.75..<18.19:
            return .s18
        case 18.19..<18.53:
            return .s18_5
        case 18.53..<18.89:
            return .s19
        case 18.89..<19.41:
            return .s19_5
        case 19.41..<19.84:
            return .s20
        case 19.84..<20.2:
            return .s20_25
        case 20.2..<20.68:
            return .s20_75
        case 20.68..<21.08:
            return .s21
        case 21.08..<21.49:
            return .s21_25
        case 21.49..<21.89:
            return .s21_75
        case 21.89..<22.33:
            return .s22
        default:
            return .s22
        }
    }
}
