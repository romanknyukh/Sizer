import UIKit

protocol DashboardBuilder {
    func build() -> UIViewController
}

final class DashboardBuilderImpl: DashboardBuilder {
    typealias Context = DashboardContainer
        & OnboardingContainer
        & MainContainer
        & SavedContainer
        & SettingsContainer
        & PremiumContainer
        & DeleteAlertContainer
        & TutorialContainer
        & NameAlertContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build() -> UIViewController {
        let view = DashboardView()
        let router = DashboardRouterImpl(
            view: view,
            mainBuilder: MainBuilderImpl(context: context),
            savedBuilder: SavedBuilderImpl(context: context),
            settingsBuilder: SettingsBuilderImpl(context: context)
        )
        let viewModel = DashboardViewModelImpl(router: router)
        view.viewModel = viewModel
        return view
    }
}
