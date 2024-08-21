import UIKit

protocol NameAlertRouter {
    func finish(completion: @escaping () -> Void)
    func cancel()
}

final class NameAlertRouterImpl: NameAlertRouter {
    private weak var view: UIViewController?

    init(view: UIViewController) {
        self.view = view
    }

    func finish(completion: @escaping () -> Void) {
        view?.dismiss(animated: true, completion: {
            completion()
        })
    }

    func cancel() {
        view?.dismiss(animated: true)
    }
}
