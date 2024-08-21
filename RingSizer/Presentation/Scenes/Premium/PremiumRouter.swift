import UIKit
import MessageUI

protocol PremiumRouter {
    func dismiss()
}

final class PremiumRouterImpl: PremiumRouter {
    private weak var view: UIViewController?
//    private let paywallBuilder: PayWallBuilder

    init(
        view: UIViewController
//        ,
//        paywallBuilder: PayWallBuilder
    ) {
        self.view = view
//        self.paywallBuilder = paywallBuilder
    }

    func dismiss() {
        self.view?.dismiss(animated: true)
    }
}
