enum RingSizeMetric: CaseIterable {
    case us
    case au
    case eu
    case jp
    case ru

    var name: String {
        switch self {
        case .us:
            return "US/CA"
        case .au:
            return "AU/GB"
        case .eu:
            return "EU/ISO"
        case .jp:
            return "JP/CN"
        case .ru:
            return "RU"
        }
    }

    func name(from sizeInMM: Float) -> String {
        switch self {
        case .us:
            return USRingSizeCalculator().calculate(sizeInMM: sizeInMM).name
        case .au:
            return AURingSizeCalculator().calculate(sizeInMM: sizeInMM).name
        case .eu:
            return EURingSizeCalculator().calculate(sizeInMM: sizeInMM).name
        case .jp:
            return JPRingSizeCalculator().calculate(sizeInMM: sizeInMM).name
        case .ru:
            return RURingSizeCalculator().calculate(sizeInMM: sizeInMM).name
        }
    }
}
