import UIKit

protocol TutorialRouter {
    func cancel()
}

final class TutorialRouterImpl: TutorialRouter {
    private weak var view: UIViewController?

    init(
        view: UIViewController
    ) {
        self.view = view
    }

    func cancel() {
        view?.dismiss(animated: true)
    }
}
