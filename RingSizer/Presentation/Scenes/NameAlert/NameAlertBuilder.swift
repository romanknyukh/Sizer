import UIKit

protocol NameAlertBuilder {
    func build(with historyRecord: HistoryRecord) -> UIViewController
}

final class NameAlertBuilderImpl: NameAlertBuilder {
    typealias Context = NameAlertContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build(with historyRecord: HistoryRecord) -> UIViewController {
        let view = NameAlertView()
        let router = NameAlertRouterImpl(view: view)
        let viewModel = NameAlertViewModelImpl(
            router: router,
            historyRecordRepository: context.historyRecordRepository,
            historyRecord: historyRecord
        )
        view.viewModel = viewModel
        return view
    }
}
