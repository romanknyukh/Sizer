import UIKit
import RxSwift
import RxCocoa

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let appContext = AppContextImpl()
//        let rootBuilder = RootBuilderImpl(context: appContext)
//        window?.rootViewController = rootBuilder.build()

        let dashboardBuilder = DashboardBuilderImpl(context: appContext)
        window?.rootViewController = dashboardBuilder.build()
        window?.makeKeyAndVisible()
    }
}
