import UIKit

protocol DashboardRouter {
    func showTabs()
}

final class DashboardRouterImpl: DashboardRouter {
    private weak var view: UITabBarController?

    private let mainBuilder: MainBuilder
    private let savedBuilder: SavedBuilder
    private let settingsBuilder: SettingsBuilder

    init(
        view: UITabBarController,
        mainBuilder: MainBuilder,
        savedBuilder: SavedBuilder,
        settingsBuilder: SettingsBuilder
    ) {
        self.view = view
        self.mainBuilder = mainBuilder
        self.savedBuilder = savedBuilder
        self.settingsBuilder = settingsBuilder
    }

    func showTabs() {
        let mainView = mainBuilder.build()
        let mainNavigationView = UINavigationController(rootViewController: mainView)
        mainNavigationView.setNavigationBarHidden(true, animated: false)
        mainView.tabBarItem.title = "Main"
        mainView.tabBarItem.image = UIImage(named: "home.icon")

        let savedView = savedBuilder.build()
        let savedNavigationView = UINavigationController(rootViewController: savedView)
        savedNavigationView.setNavigationBarHidden(true, animated: false)
        savedView.tabBarItem.title = "Saved"
        savedView.tabBarItem.image = UIImage(named: "save.icon")

        let settingsView = settingsBuilder.build()
        let settingsNavigationView = UINavigationController(rootViewController: settingsView)
        settingsNavigationView.setNavigationBarHidden(true, animated: false)
        settingsView.tabBarItem.title = "Settigns"
        settingsView.tabBarItem.image = UIImage(named: "settings.icon")

        view?.viewControllers = [mainNavigationView, savedNavigationView, settingsNavigationView]
    }
}
