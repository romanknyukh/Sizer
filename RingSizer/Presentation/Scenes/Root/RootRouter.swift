import UIKit

protocol RootRouter {
    func showMainScreen()
    func showOnboarding()
}

final class RootRouterImpl: RootRouter {
    private weak var view: UIViewController?
    private let dashboardBuilder: DashboardBuilder
    private let onboardingBuilder: OnboardingBuilder

    init(
        view: UIViewController,
        dashboardBuilder: DashboardBuilder,
        onboardingBuilder: OnboardingBuilder
    ) {
        self.view = view
        self.dashboardBuilder = dashboardBuilder
        self.onboardingBuilder = onboardingBuilder
    }

    func showMainScreen() {
        let dashboardView = dashboardBuilder.build()
        dashboardView.modalPresentationStyle = .fullScreen
        view?.present(dashboardView, animated: true)
    }

    func showOnboarding() {
        let onboardingView = onboardingBuilder.build()
        onboardingView.modalPresentationStyle = .fullScreen
        view?.present(onboardingView, animated: true)
    }
}
