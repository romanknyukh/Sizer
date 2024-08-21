import Foundation

struct OnboardingStep {
    enum StepType {
        case info
        case restore(closeDelay: CGFloat, closeAlpha: CGFloat)
    }

    let backgroundImage: String
    let title: String
    let description: String
    let price: NSAttributedString?
    let buttonTitle: String
    var stepType: StepType = .info
}
