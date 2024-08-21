protocol RingSizeCalculator {
    associatedtype Value

    func calculate(sizeInMM: Float) -> Value
}
