import UIKit

protocol RootBuilder {
    func build() -> UIViewController
}

final class RootBuilderImpl: RootBuilder {
    typealias Context = OnboardingContainer
        & DashboardContainer
        & RootContainer
        & PremiumContainer
        & SettingsContainer
        & MainContainer
        & SavedContainer
        & TutorialContainer
        & DeleteAlertContainer
        & NameAlertContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build() -> UIViewController {
        let view = RootView()
        let router = RootRouterImpl(
            view: view,
            dashboardBuilder: DashboardBuilderImpl(context: context),
            onboardingBuilder: OnboardingBuilderImpl(context: context)
        )
        let viewModel = RootViewModelImpl(
            router: router,
            userDefaultsStore: context.userDefaultsStore
        )
        view.viewModel = viewModel
        return view
    }
}
