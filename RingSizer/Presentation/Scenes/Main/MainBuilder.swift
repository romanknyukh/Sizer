import UIKit

protocol MainBuilder {
    func build() -> UIViewController
}

final class MainBuilderImpl: MainBuilder {
    typealias Context = MainContainer
    & TutorialContainer
    & NameAlertContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build() -> UIViewController {
        let view = MainView()
        let router = MainRouterImpl(
            view: view,
            tutorialBuilder: TutorialBuilderImpl(context: context),
            nameAlertBuilder: NameAlertBuilderImpl(context: context)
        )
        let viewModel = MainViewModelImpl(
            router: router,
            userDefaultsStore: context.userDefaultsStore
        )
        view.viewModel = viewModel
        return view
    }
}
