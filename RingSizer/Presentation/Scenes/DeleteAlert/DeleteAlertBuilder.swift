import UIKit

enum FlowResult<Value> {
    case finished(Value)
    case cancelled
}

extension FlowResult where Value == Void {
    static var finished: Self = .finished(())
}

typealias SimpleFlowResult = FlowResult<Void>

protocol DeleteAlertBuilder {
    func build(deleteAlertType: DeleteAlertType,
               completion: @escaping (SimpleFlowResult) -> Void
    ) -> UIViewController
}

final class DeleteAlertBuilderImpl: DeleteAlertBuilder {
    typealias Context = DeleteAlertContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build(deleteAlertType: DeleteAlertType,
               completion: @escaping (SimpleFlowResult) -> Void
    ) -> UIViewController {
        let view = DeleteAlertView()
        let router = DeleteAlertRouterImpl(
            view: view,
            completion: completion
        )
        let viewModel = DeleteAlertViewModelImpl(
            router: router,
            type: deleteAlertType
        )
        view.viewModel = viewModel
        return view
    }
}
