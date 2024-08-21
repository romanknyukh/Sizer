import UIKit

protocol MainRouter {
    func showTutorial(for type: SizerType)
    func showNameAlert(for historyRecord: HistoryRecord)
}

final class MainRouterImpl: MainRouter {
    private weak var view: UIViewController?
    private let tutorialBuilder: TutorialBuilder
    private let nameAlertBuilder: NameAlertBuilder

    init(
        view: UIViewController,
        tutorialBuilder: TutorialBuilder,
        nameAlertBuilder: NameAlertBuilder
    ) {
        self.view = view
        self.tutorialBuilder = tutorialBuilder
        self.nameAlertBuilder = nameAlertBuilder
    }

    func showTutorial(for type: SizerType) {
        let tutorialView = tutorialBuilder.build(for: type)
        tutorialView.modalPresentationStyle = .overFullScreen
        tutorialView.modalTransitionStyle = .crossDissolve
        view?.present(tutorialView, animated: true)
    }

    func showNameAlert(for historyRecord: HistoryRecord) {
        let alertView = self.nameAlertBuilder.build(with: historyRecord)
        alertView.modalPresentationStyle = .overFullScreen
        alertView.modalTransitionStyle = .crossDissolve
        view?.present(alertView, animated: true)
    }
}
