enum EURingSize {
    case s44
    case s45_25
    case s46_5
    case s47_75
    case s49
    case s50_25
    case s51_5
    case s52_75
    case s54
    case s55_25
    case s56_5
    case s57_75
    case s59
    case s60_5
    case s61_75
    case s62_75
    case s64_25
    case s65_625
    case s67_25
    case s68_75
    case s69_5

    var name: String {
        switch self {
        case .s44:
            return "44"
        case .s45_25:
            return "45.3"
        case .s46_5:
            return "46.5"
        case .s47_75:
            return "47.8"
        case .s49:
            return "49.0"
        case .s50_25:
            return "50.3"
        case .s51_5:
            return "51.5"
        case .s52_75:
            return "52.8"
        case .s54:
            return "54.0"
        case .s55_25:
            return "55.3"
        case .s56_5:
            return "56.6"
        case .s57_75:
            return "57.8"
        case .s59:
            return "59.1"
        case .s60_5:
            return "60.3"
        case .s61_75:
            return "61.6"
        case .s62_75:
            return "62.8"
        case .s64_25:
            return "64.1"
        case .s65_625:
            return "65.3"
        case .s67_25:
            return "66.6"
        case .s68_75:
            return "67.9"
        case .s69_5:
            return "69.1"
        }
    }
}

final class EURingSizeCalculator: RingSizeCalculator {
    func calculate(sizeInMM: Float) -> EURingSize {
        switch sizeInMM {
        case ..<14.1:
            return .s44
        case 14.1..<14.45:
            return .s45_25
        case 14.45..<14.86:
            return .s46_5
        case 14.86..<15.27:
            return .s47_75
        case 15.27..<15.71:
            return .s49
        case 15.71..<16.1:
            return .s50_25
        case 16.1..<16.51:
            return .s51_5
        case 16.51..<16.92:
            return .s52_75
        case 16.92..<17.35:
            return .s54
        case 17.35..<17.75:
            return .s55_25
        case 17.75..<18.19:
            return .s56_5
        case 18.19..<18.53:
            return .s57_75
        case 18.53..<18.89:
            return .s59
        case 18.89..<19.41:
            return .s60_5
        case 19.41..<19.84:
            return .s61_75
        case 19.84..<20.2:
            return .s62_75
        case 20.2..<20.68:
            return .s64_25
        case 20.68..<21.08:
            return .s65_625
        case 21.08..<21.49:
            return .s67_25
        case 21.49..<21.89:
            return .s68_75
        case 21.89..<22.33:
            return .s69_5
        default:
            return .s69_5
        }
    }
}
