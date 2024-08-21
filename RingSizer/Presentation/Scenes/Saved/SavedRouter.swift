import UIKit
import RxSwift

protocol SavedRouter {
    func showDeleteAlert(with type: DeleteAlertType) -> Single<SimpleFlowResult>
    func showNameAlert(for historyRecord: HistoryRecord)
}

final class SavedRouterImpl: SavedRouter {
    private weak var view: UIViewController?
    private let deleteAlertBuilder: DeleteAlertBuilder
    private let nameAlertBuilder: NameAlertBuilder

    init(
        view: UIViewController,
        deleteAlertBuilder: DeleteAlertBuilder,
        nameAlertBuilder: NameAlertBuilder
    ) {
        self.view = view
        self.deleteAlertBuilder = deleteAlertBuilder
        self.nameAlertBuilder = nameAlertBuilder
    }

    func showDeleteAlert(with type: DeleteAlertType) -> Single<SimpleFlowResult> {
        return .create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            let alertView = self.deleteAlertBuilder.build(
                deleteAlertType: type,
                completion: { result in
                    single(.success(result))
                })
            alertView.modalPresentationStyle = .overFullScreen
            alertView.modalTransitionStyle = .crossDissolve
            self.view?.present(alertView, animated: true)
            return Disposables.create { [weak alertView] in
                alertView?.dismiss(animated: true)
            }
        }
    }

    func showNameAlert(for historyRecord: HistoryRecord) {
        let alertView = self.nameAlertBuilder.build(with: historyRecord)
        alertView.modalPresentationStyle = .overFullScreen
        alertView.modalTransitionStyle = .crossDissolve
        view?.present(alertView, animated: true)
    }
}
