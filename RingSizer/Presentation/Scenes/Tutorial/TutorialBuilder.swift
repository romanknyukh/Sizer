import UIKit

protocol TutorialBuilder {
    func build(for sizerType: SizerType) -> UIViewController
}

final class TutorialBuilderImpl: TutorialBuilder {
    typealias Context = TutorialContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build(for sizerType: SizerType) -> UIViewController {
        let view = TutorialView()
        let router = TutorialRouterImpl(view: view)
        let viewModel = TutorialViewModelImpl(
            router: router,
            sizerType: sizerType
        )
        view.viewModel = viewModel
        return view
    }
}
