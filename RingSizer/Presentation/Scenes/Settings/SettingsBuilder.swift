import UIKit

protocol SettingsBuilder {
    func build() -> UIViewController
}

final class SettingsBuilderImpl: SettingsBuilder {
    typealias Context = SettingsContainer
    & PremiumContainer
//    & PayWallContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build() -> UIViewController {
        let view = SettingsView()
        let router = SettingsRouterImpl(
            view: view,
            premiumBuilder: PremiumBuilderImpl(context: context)
        )
        let viewModel = SettingsViewModelImpl(
            router: router,
            userDefaultsStore: context.userDefaultsStore
        )
        view.viewModel = viewModel
        return view
    }
}
