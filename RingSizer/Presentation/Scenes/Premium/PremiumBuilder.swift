import UIKit

protocol PremiumBuilder {
    func build() -> UIViewController
}

final class PremiumBuilderImpl: PremiumBuilder {
    typealias Context = PremiumContainer 
//    & PayWallContainer

    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func build() -> UIViewController {
        let view = PremiumView()
        let router = PremiumRouterImpl(
            view: view
//            ,
//            paywallBuilder: PayWallBuilderImpl(context: context)
        )
        let viewModel = PremiumViewModelImpl(
            router: router,
            userDefaultsStore: context.userDefaultsStore
//            ,
//            apphudService: context.apphudService
        )
        view.viewModel = viewModel
        return view
    }
}
