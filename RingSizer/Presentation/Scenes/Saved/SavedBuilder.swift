import UIKit

protocol SavedBuilder {
    func build() -> UIViewController
}

final class SavedBuilderImpl: SavedBuilder {
    typealias Context = SavedContainer
    & DeleteAlertContainer
    & NameAlertContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build() -> UIViewController {
        let view = SavedView()
        let router = SavedRouterImpl(
            view: view,
            deleteAlertBuilder: DeleteAlertBuilderImpl(context: context),
            nameAlertBuilder: NameAlertBuilderImpl(context: context)
        )
        let viewModel = SavedViewModelImpl(
            router: router,
            userDefaultsStore: context.userDefaultsStore,
            sizersRepository: context.historyRecordRepository
        )
        view.viewModel = viewModel
        return view
    }
}
